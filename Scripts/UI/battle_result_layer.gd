extends ScreenFadeLayer
class_name BattleResultLayer

@onready var status_label: Label = $Control/DisplayElements/VBoxContainer/StatusLabel
@onready var gold_label: Label = $Control/DisplayElements/VBoxContainer/GoldLabel
@onready var display_elements: MarginContainer = $Control/DisplayElements
@onready var display_timer: Timer = $DisplayTimer
@onready var death_delay_timer: Timer = $DeathDelayTimer
@onready var reward_label: Label = $Control/DisplayElements/VBoxContainer/RewardLabel

@onready var continue_button: Button = $Control/MarginContainer/Continue
@onready var march_position: Node2D = $MarchPosition
const POP_PARTICLES = preload("res://Nodes/Effects/star_pop.tscn")
var target_scene:String

func _ready() -> void:
	display_elements.visible = false


func set_result(won_battle:bool,
		player_entity:BattleEntity,
		enemies:Array[BattleEntity]):
	
	player_entity.reparent(self)
	player_entity.hide_ui()
	if won_battle:
		GlobalSessionManager.run_progress.floor_progress += 1
		gold_label.visible = true
		status_label.text = player_entity.entity_data.name + " Survived!"
		continue_button.text = "Continue"
		
		var gold_amount:int = 0
		for enemy in enemies:
			if enemy.entity_data is EnemyData:
				gold_amount += enemy.entity_data.reward_amount
		gold_label.text = "Gold: " + str(gold_amount)
		await fade_in()
		player_entity.entity_sprite.flip_h = true
		player_entity.move_to(march_position.global_position)
		player_entity.entity_animator.play("battle_entity/march")
		display_timer.start()
		target_scene = "res://Map/map_screen/MapScreen.tscn"
		GlobalSessionManager.add_gold(gold_amount)
		GlobalSessionManager.save_character_health(player_entity.entity_data.health.value)
	else:
		reward_label.visible = false
		gold_label.visible = false
		status_label.text = "RIP " + player_entity.entity_data.name
		continue_button.text = "Main Menu"
		await fade_in()
		death_delay_timer.start()
		await death_delay_timer.timeout
		var particles:CPUParticles2D = POP_PARTICLES.instantiate()
		player_entity.add_child(particles)
		particles.global_position = player_entity.global_position
		player_entity.entity_sprite.visible = false
		particles.emitting = true
		await particles.finished
		particles.queue_free()
		display_timer.start()
		GlobalSessionManager.reset_progress()
		target_scene = "res://Screens/main_menu_screen.tscn"

func _on_display_timer_timeout() -> void:
	display_elements.visible = true
	continue_button.disabled = false
	continue_button.visible = true


func _on_continue_button_up() -> void:
	GlobalSceneLoader.load_scene(target_scene)
	pass # Replace with function body.

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
const POP_PARTICLES = preload("res://GeneralAssets/ParticleEffects/star_pop.tscn")
var target_scene:String

func _ready() -> void:
	display_elements.visible = false
	visible = false


func set_result(won_battle:bool,
		player_entity:BattleEntity,
		enemy_encounter:EnemyEncounter
):
	visible = true
	player_entity.reparent(self)
	
	if won_battle:
		GlobalSessionManager.run_progress.floor_progress += 1
		gold_label.visible = true
		status_label.text = player_entity.data.name + " Survived!"
		continue_button.text = "Continue"
		
		await fade_in()
		player_entity.sprite_2d.flip_h = true
		player_entity.move_to(march_position.global_position)
		player_entity.animation_player.play("entity/march")
		display_timer.start()
		target_scene = GlobalSceneLoader.MAP_SCENE_PATH
		var reward:int = enemy_encounter.get_gold_reward()
		gold_label.text = "collected " + str(reward) + " gold!"
		GlobalSessionManager.increase_gold(reward)
		GlobalSessionManager.save_character_health(player_entity._health.current_health)
		_clear_battle_lock()
	else:
		player_entity.sprite_2d.visible = true
		reward_label.visible = false
		gold_label.visible = false
		status_label.text = "RIP " + player_entity.data.name
		continue_button.text = "Main Menu"
		await fade_in()
		death_delay_timer.start()
		await death_delay_timer.timeout
		var particles:CPUParticles2D = POP_PARTICLES.instantiate()
		player_entity.add_child(particles)
		particles.global_position = player_entity.global_position
		player_entity.sprite_2d.visible = false
		particles.emitting = true
		await particles.finished
		particles.queue_free()
		display_timer.start()
		GlobalSessionManager.erase_run_progress()
		GlobalSaveManager.reset()
		target_scene = GlobalSceneLoader.MAIN_MENU_PATH


func _on_display_timer_timeout() -> void:
	display_elements.visible = true
	continue_button.disabled = false
	continue_button.visible = true


func _on_continue_button_up() -> void:
	GlobalSceneLoader.load_scene(target_scene)
	pass # Replace with function body.


func _clear_battle_lock() -> void:
	if GlobalSessionManager.run_progress == null:
		return
	if GlobalSessionManager.run_progress.battle == null:
		return
	GlobalSessionManager.run_progress.battle.is_active = false
	GlobalSaveManager.save_run(GlobalSessionManager.run_progress)

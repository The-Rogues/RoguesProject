extends CanvasLayer
class_name LoseScreen

@onready var results: Control = $Results
@onready var name_label: Label = $Results/DisplayElements/VBoxContainer/NinePatchRect/MarginContainer/Stats/Name
@onready var gold: Label = $Results/DisplayElements/VBoxContainer/NinePatchRect/MarginContainer/Stats/Gold
@onready var cards: Label = $Results/DisplayElements/VBoxContainer/NinePatchRect/MarginContainer/Stats/Cards
@onready var items: Label = $Results/DisplayElements/VBoxContainer/NinePatchRect/MarginContainer/Stats/Items
@onready var battles: Label = $Results/DisplayElements/VBoxContainer/NinePatchRect/MarginContainer/Stats/Battles
@onready var character_sprite: Sprite2D = $CharacterSprite


@onready var display_timer: Timer = $DisplayTimer
@onready var death_delay_timer: Timer = $DeathDelayTimer


const POP_PARTICLES = preload("res://General/Effects/Particles/star_pop.tscn")

func death_delay():
	death_delay_timer.start()
	await death_delay_timer.timeout

func play_lose_sequence(player_entity:BattleEntity):
	var p:RunProgress = GlobalSessionManager.run_progress
	name_label.text = "Name: " + p.character_name
	gold.text = "Gold collected: " + str(p.total_items_collected)
	cards.text = "Cards collected: " + str(p.total_cards_collected)
	items.text = "Items collected: " + str(p.total_items_collected)
	battles.text = "Battles: " + str(p.floor_progress)
	
	GlobalSaveManager.reset()
	GlobalSessionManager.run_progress = null
	
	character_sprite.texture = player_entity.sprite_2d.texture
	character_sprite.global_position = player_entity.global_position
	character_sprite.visible = true
	results.visible = false
	await death_delay()
	
	var particles:CPUParticles2D = POP_PARTICLES.instantiate()
	add_child(particles)
	particles.global_position = character_sprite.global_position
	character_sprite.visible = false
	particles.emitting = true
	await particles.finished
	particles.queue_free()
	
	display_timer.start()
	await display_timer.timeout
	


func display_game_results():
	results.visible = true


func _on_end_run_clicked() -> void:
	GlobalSceneLoader.load_scene(GlobalSceneLoader.MAIN_MENU_PATH)
	pass # Replace with function body.

extends Control


const CARD = preload("res://card_system/card.tscn")
@export var spawn_radius:float = 10
@export var preview_time:float = 1.5


func add_card_effect(data:CardData, target_pos:Vector2):
	var center:Vector2 = get_viewport().get_visible_rect().get_center()
	var card:Card = CARD.instantiate()
	var random_pos = center + Vector2(randf_range(0, spawn_radius), randf_range(0, spawn_radius))
	add_child(card)
	card.global_position = random_pos
	card.initialize(CardInstance.new(data))
	var timer = Timer.new()
	card.add_child(timer)
	timer.timeout.connect(func():
		card.launch_towards(target_pos, false))
	timer.start(preview_time)


func remove_card_effect(data:CardData):
	var center:Vector2 = get_viewport().get_visible_rect().get_center()
	var card:Card = CARD.instantiate()
	var random_pos = center + Vector2(randf_range(0, spawn_radius), randf_range(0, spawn_radius))
	add_child(card)
	card.global_position = random_pos
	card.initialize(CardInstance.new(data))
	var timer = Timer.new()
	card.add_child(timer)
	timer.timeout.connect(func():
		card.poof_card())
	
	timer.start(preview_time)

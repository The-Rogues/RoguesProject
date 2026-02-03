class_name CardHand
extends Node2D

signal play_card(card_data:CardData)

@export var card_datas:Array[CardData]
@export var y_position:float

var card_uis:Array[CardUI]
var heald_card_copy:CardUI = null
var heald_card:CardUI = null
var holding_card:bool = false

var screen_size:Vector2
var CARD_WIDTH:float = 100

const CARD_UI = preload("res://Nodes/UI/card_ui.tscn")

func _ready() -> void:
	screen_size = get_viewport().size
	initialize()
	#get_viewport().size_changed.connect(on_screen_size_changed)

func _process(delta: float) -> void:
	if holding_card:
		var mouse_pos = get_global_mouse_position()
		heald_card_copy.position = Vector2(clamp(mouse_pos.x, 0, screen_size.x),clamp(mouse_pos.y, 0, screen_size.y))
		if !Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
			_release_heald_card()
			holding_card = false

func initialize():
	for card_data in card_datas:
		draw_card(card_data)

func draw_card(card_data:CardData):
	var new_card_ui = CARD_UI.instantiate()
	new_card_ui.set_card_data(card_data)
	add_child(new_card_ui)
	
	new_card_ui.hovered.connect(on_card_hovered)
	new_card_ui.clicked.connect(on_clicked_card)
	card_uis.append(new_card_ui)
	
	update_card_positions()

func on_clicked_card(card_ui:CardUI):
	if heald_card:
		return
	
	heald_card = card_ui
	
	var new_card_ui:CardUI = CARD_UI.instantiate()
	new_card_ui.set_card_data(card_ui.card_data)
	add_child(new_card_ui)
	
	heald_card_copy = new_card_ui
	heald_card.visible = false
	holding_card = true

func _release_heald_card():
	if !heald_card:
		return
	
	if heald_card_copy.in_play_area:
		play_card.emit(heald_card.card_data)
		card_uis.erase(heald_card)
		heald_card.queue_free()
		heald_card_copy.queue_free()
		update_card_positions()
		return
	
	await tween_card_to_position(heald_card_copy, heald_card.position)
	heald_card_copy.queue_free()
	heald_card.visible = true
	heald_card = null

func update_card_positions():
	for i in range(0, card_uis.size()):
		var card_pos = Vector2(calculate_card_position(i), y_position)
		var card = card_uis[i]
		tween_card_to_position(card, card_pos)

func calculate_card_position(index):
	var total_width = (card_uis.size() - 1) * CARD_WIDTH
	var x_offset = (screen_size.x / 2) + index * CARD_WIDTH - total_width / 2
	return x_offset

func tween_card_to_position(card_ui:CardUI, new_positon:Vector2):
	var tween = get_tree().create_tween()
	tween.tween_property(card_ui, "position", new_positon, 0.2)
	await tween.finished

func clear_hand():
	for card in card_uis:
		card.queue_free()
	
	card_datas.clear()
	card_uis.clear()

func on_card_hovered(card_ui:CardUI, hovered:bool):
	if hovered:
		if !heald_card_copy:
			card_ui.blow_up(true)
	else:
		card_ui.blow_up(false)

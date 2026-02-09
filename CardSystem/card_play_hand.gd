# ==========================================================
# Author: Fabian 
# Description:
#   Attatch to a Node2D to make it a parent that displays a 
#   drawn hand of cards.
#   Works by passing an array of CardData and initializing
#   a new CardUI scene for each card_data.
#   Conencts click and release signals from CardUIs to allow
#   for dragging Cards accross the screen
#   Signals for a card to be played when releasing CardUI over
#   valid card play area (Area2D with mask layer 2)
#
# ==========================================================

class_name CardPlayHand
extends Node2D

# Emitted when dragged card is released over a play area
signal play_card(card_ui:CardUI)

# Stores data for drawn cards
@export var card_datas:Array[CardData]
# Changes the y position of where the card hand appears on screen
@export var y_position:float
@export var force_initialization:bool = false
# Stores the instantiated CardUIs
var card_uis:Array[CardUI]
# Stores a copy of the heald card UI to drag around
var dragged_card:CardUI = null
# Stores the actual heald card
var heald_card:CardUI = null
var holding_card:bool = false

var screen_size:Vector2
var CARD_WIDTH:float = 100

# Stores packed scene of CardUI we will use as a template for
# instantiation
const CARD_UI = preload("res://CardSystem/Cards/card_ui.tscn")

func _ready() -> void:
	screen_size = get_viewport().size
	if force_initialization:
		initialize(card_datas)
	#get_viewport().size_changed.connect(on_screen_size_changed)

func _process(delta: float) -> void:
	if holding_card:
		var mouse_pos = get_global_mouse_position()
		dragged_card.position = Vector2(clamp(mouse_pos.x, 0, screen_size.x),clamp(mouse_pos.y, 0, screen_size.y))
		if !Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
			_release_heald_card()
			holding_card = false

func initialize(new_card_datas:Array[CardData]):
	if !new_card_datas:
		return
	
	for card_data in new_card_datas:
		draw_card(card_data)

func draw_card(card_data:CardData):
	var new_card_ui = CARD_UI.instantiate()
	new_card_ui.set_card_data(card_data)
	add_child(new_card_ui)
	
	new_card_ui.hovered.connect(on_card_hovered)
	new_card_ui.clicked.connect(on_clicked_card)
	card_uis.append(new_card_ui)
	
	update_card_positions()

# Updates positioning of all cards currently in the play hand
#TODO: Implement card fanning and dynamic card positioning so that CardUIs
#      are closer together the more cards are added to the hand
func update_card_positions():
	if card_uis.is_empty():
		return
	
	for i in range(0, card_uis.size()):
		# Y position stays the same, X position is calculated
		var card_pos = Vector2(calculate_card_position(i), y_position)
		# Move cards towards their new calculated position
		var card = card_uis[i]
		tween_card_to_position(card, card_pos)

func calculate_card_position(index:int):
	# Total width of card hand with the size of all cards next to eachother included
	var total_width = (card_uis.size() - 1) * CARD_WIDTH
	# Middle of screen + index of card * its width - offset to be back in middle
	var x_offset = (screen_size.x / 2) + index * CARD_WIDTH - total_width / 2
	return x_offset

func tween_card_to_position(card_ui:CardUI, new_positon:Vector2):
	var tween = get_tree().create_tween()
	tween.tween_property(card_ui, "position", new_positon, 0.2)
	await tween.finished

func on_clicked_card(card_ui:CardUI):
	if heald_card:
		return
	
	heald_card = card_ui
	
	# Instead of dragging the actual clicked card
	# A copy is created and dragged around instead
	# This is done to perserve the original card's position
	# and makes returning it back easy as it never left
	var new_card_ui:CardUI = CARD_UI.instantiate()
	new_card_ui.set_card_data(card_ui.card_data)
	add_child(new_card_ui)
	dragged_card = new_card_ui
	heald_card.visible = false
	
	holding_card = true

func _release_heald_card():
	if !heald_card:
		return
	
	if dragged_card.in_play_area:
		play_card.emit(heald_card)
		return
	
	await tween_card_to_position(dragged_card, heald_card.position)
	dragged_card.queue_free()
	heald_card.visible = true
	heald_card = null

func return_dragged_card():
	if !dragged_card:
		return
	
	await tween_card_to_position(dragged_card, heald_card.position)
	dragged_card.queue_free()
	heald_card.visible = true
	heald_card = null

func remove_played_card(card_ui:CardUI):
	if !heald_card:
		return
	
	if card_uis.has(card_ui):
		card_uis.erase(heald_card)
		heald_card.queue_free()
		dragged_card.queue_free()
		update_card_positions()

func clear_hand():
	for card in card_uis:
		card.queue_free()
	
	card_datas.clear()
	card_uis.clear()

func on_card_hovered(card_ui:CardUI, hovered:bool):
	if hovered:
		if !dragged_card:
			card_ui.blow_up(true)
	else:
		card_ui.blow_up(false)

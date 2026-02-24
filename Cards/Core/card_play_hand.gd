extends Node2D
class_name CardPlayHand

signal play_card(card_ui: CardUI)
signal grabbed_card
signal released_card

@export var y_position: float = 700
@export var fan_angle: float = 20.0
@export var fan_spacing: float = 90.0
@export var force_initialization := false
@export var card_datas: Array[CardData]

const CARD_UI = preload("res://Cards/UI/card.tscn")

var card_uis:Array[CardUI] = []

var held_card:CardUI = null
var dragged_card:CardUI = null
var holding_card:bool = false

var screen_size:Vector2

func _ready() -> void:
	screen_size = get_viewport().size
	if force_initialization:
		initialize(card_datas)

func _process(_delta: float) -> void:
	if not holding_card or dragged_card == null:
		return
	
	dragged_card.global_position = get_global_mouse_position()
	
	if not Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
		_release_card()

# -------------------------------------------------
# Initialization / Drawing
# -------------------------------------------------

func initialize(new_card_datas: Array[CardData]) -> void:
	clear_hand()
	for data in new_card_datas:
		draw_card(data)

func draw_card(new_card_data: CardData) -> void:
	var card:CardUI = CARD_UI.instantiate() as CardUI
	add_child(card)
	card.set_card_data(new_card_data)
	
	card.clicked.connect(_on_card_clicked)
	card.hovered.connect(_on_card_hovered)
	
	card_uis.append(card)
	_update_card_layout()

# -------------------------------------------------
# Layout / Fanning
# -------------------------------------------------

func _update_card_layout() -> void:
	if card_uis.is_empty():
		return
	
	var count:float = card_uis.size()
	var center_x:float = screen_size.x * 0.45
	
	for i in count:
		var card:CardUI = card_uis[i]
		if card == held_card:
			continue
		
		var t:float = i - (count - 1) * 0.5
		var angle:float = t * fan_angle
		var x:float = center_x + t * fan_spacing
		var y:float = y_position + abs(t) * 10
		
		_move_card(card, Vector2(x, y), angle)

func _move_card(card: CardUI, pos: Vector2, rot: float) -> void:
	var tween := get_tree().create_tween()
	tween.set_parallel()
	tween.tween_property(card, "position", pos, 0.25)
	tween.tween_property(card, "rotation_degrees", rot, 0.25)

# -------------------------------------------------
# Input / Dragging
# -------------------------------------------------

func _on_card_clicked(card: CardUI) -> void:
	if holding_card:
		return
	
	held_card = card
	holding_card = true
	
	dragged_card = CARD_UI.instantiate()
	add_child(dragged_card)
	dragged_card.set_card_data(card.card_data)
	
	dragged_card.global_position = card.global_position
	dragged_card.scale = card.scale
	dragged_card.z_index = 100
	
	held_card.visible = false
	grabbed_card.emit()

func _release_card() -> void:
	holding_card = false
	
	if not held_card or not dragged_card:
		_cleanup_drag()
		return
	
	released_card.emit()
	if dragged_card.in_play_area:
		play_card.emit(held_card)
	else:
		_return_card()

func _return_card() -> void:
	if not dragged_card or not held_card:
		_cleanup_drag()
		return
	
	var tween := get_tree().create_tween()
	tween.tween_property(dragged_card, "position", held_card.position, 0.2)
	await tween.finished
	
	_cleanup_drag()

func _cleanup_drag() -> void:
	if dragged_card:
		dragged_card.queue_free()
	if held_card:
		held_card.visible = true
	
	held_card = null
	dragged_card = null

# -------------------------------------------------
# Play resolution (called by BattleManager)
# -------------------------------------------------

func reject_play() -> void:
	_return_card()

func confirm_play(card_ui: CardUI) -> void:
	if not card_uis.has(card_ui):
		return
	
	card_uis.erase(card_ui)
	card_ui.queue_free()
	
	_cleanup_drag()
	_update_card_layout()

# -------------------------------------------------
# Hover
# -------------------------------------------------

func _on_card_hovered(card: CardUI, hovering: bool) -> void:
	if holding_card:
		return
	
	card.blow_up(hovering)

# -------------------------------------------------
# Utility
# -------------------------------------------------

func clear_hand() -> void:
	for card in card_uis:
		card.queue_free()
	card_uis.clear()
	card_datas.clear()

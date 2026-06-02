extends Control
class_name PlayerCardHand

signal grabbed_card
signal released_card

@export var fan_angle: float = 20.0
@export var fan_spacing: float = 90.0

const CARD = preload("res://card_system/card.tscn")
const CARD_HOVER_OFFSET = 80

var held_card:Card = null

var dragged_card:Card = null
var holding_card:bool = false
#var screen_size:Vector2
var resolver:ActionResolver
var player:PlayerEntity
var hovered_card: Card = null

func initialize(_player:PlayerEntity, _resolver:ActionResolver):
	#screen_size = get_viewport().size
	clear_hand()
	player = _player
	_player.cards.drew_card.connect(_on_card_drawn)
	_player.cards.forced_card_to_discard.connect(_on_forced_card_to_discard)
	resolver = _resolver


func _on_card_drawn(instance:CardInstance):
	var card:Card = CARD.instantiate()
	add_child(card)
	card.initialize(instance)
	card.global_position = Vector2(0, 500)
	
	card.clicked.connect(_on_card_clicked)
	card.interaction_mode = true
	card.hovered.connect(_on_card_hovered)
	_update_card_layout()


func _process(_delta: float) -> void:
	if not holding_card or dragged_card == null:
		return
	
	dragged_card.global_position = get_global_mouse_position()
	
	if not Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
		_release_card()

# -------------------------------------------------
# Initialization / Drawing
# -------------------------------------------------


# -------------------------------------------------
# Layout / Fanning
# -------------------------------------------------

func _update_card_layout() -> void:
	var cards := get_children()
	if cards.is_empty():
		return
	
	var count:float = get_child_count()
	var center_x: float = size.x * 0.5
	
	for i in range(0, count):
		var card:Card = cards[i]
		if card == held_card:
			continue
		
		var t:float = i - (count - 1) * 0.5
		var angle:float = t * fan_angle
		var x:float = center_x + t * fan_spacing
		var base_y: float = size.y - 100 
		var y: float = base_y + abs(t) * 10

		if card == hovered_card:
			y -= CARD_HOVER_OFFSET

		_move_card(card, Vector2(x, y), angle)


func _move_card(card: Card, pos: Vector2, rot: float) -> void:
	var tween := get_tree().create_tween()
	tween.set_parallel()
	tween.tween_property(card, "position", pos, 0.25)
	tween.tween_property(card, "rotation_degrees", rot, 0.25)

# -------------------------------------------------
# Input / Dragging
# -------------------------------------------------

func _on_card_clicked(card: Card) -> void:
	if holding_card:
		return
	
	held_card = card
	holding_card = true
	
	dragged_card = CARD.instantiate()
	add_child(dragged_card)
	dragged_card.initialize(card.instance)
	
	dragged_card.global_position = card.global_position
	dragged_card.scale = card.scale
	dragged_card.z_index = 100
	
	held_card.visible = false
	grabbed_card.emit()


func _release_card() -> void:
	holding_card = false
	hovered_card = null
	
	if not held_card or not dragged_card:
		_cleanup_drag()
		return
	released_card.emit()
	
	if dragged_card.in_play_area:
		player.resolve_card(held_card, resolver, self)
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


func confirm_play(card: Card) -> void:
	var cards := get_children()
	if cards.has(card):
		if dragged_card:
			card.global_position = dragged_card.global_position
		card.launch_towards(Vector2(1000, 500))
		await get_tree().process_frame
		_cleanup_drag()
		_update_card_layout()

# -------------------------------------------------
# Hover
# -------------------------------------------------

func _on_card_hovered(card: Card, hovering: bool) -> void:
	if holding_card:
		return
	
	if hovering:
		hovered_card = card
		card.z_index = 50
	else:
		if hovered_card == card:
			hovered_card = null
		card.z_index = 0
	_update_card_layout()

# -------------------------------------------------
# Utility
# -------------------------------------------------

func clear_hand() -> void:
	for child in get_children():
		var card:Card = child
		card.launch_towards(Vector2(1000, 500))
		#child.queue_free()


func _on_forced_card_to_discard(instance:CardInstance):
	for child in get_children():
		var card:Card = child
		if card.instance == instance:
			confirm_play(card)

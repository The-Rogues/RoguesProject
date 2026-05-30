extends Control
class_name TraitDisplay
## UI script that displays a player's personality trait.
##
## Initialized with a specific trait in player's PersonalityData. Updates
## trait weight, image, and name displays as needed, with some simple animation
## logic when trait weights are changed.
## Author: Fabian.

signal finished_animation

@onready var trait_label: Label = $Offensive/TraitLabel
@onready var trait_context: ContextPanel = $Offensive/TraitLabel/TraitContext

@onready var weight_label: Label = %WeightLabel
@onready var operation_label: Label = %OperationLabel
@onready var operation_timer: Timer = %OperationTimer
@onready var trait_icon: TextureRect = %TraitIcon


const NORMAL_COLOR := Color.WHITE
const MODIFIED_COLOR := Color.YELLOW


var pending_weight_text:String = ""

var base_weight:int = 0
var temporary_offset:int = 0
var current_weight:int = 0


# -------------------------------------------------
# INITIALIZATION
# -------------------------------------------------

func initialize_display(_trait: PersonalityTrait, weight: int):
	base_weight = weight
	temporary_offset = 0
	current_weight = weight

	update_trait_label(_trait)

	weight_label.text = str(weight)
	weight_label.modulate = NORMAL_COLOR


# -------------------------------------------------
# BASE STAT CHANGES (persistent)
# -------------------------------------------------

func set_base_weight(weight:int, animate:bool = true):
	base_weight = weight

	var new_weight = base_weight + temporary_offset

	if animate:
		animate_weight_change(new_weight)
	else:
		set_weight_immediate(new_weight)


# -------------------------------------------------
# TEMPORARY BATTLE MODIFIERS
# -------------------------------------------------

func set_temporary_modifier(offset:int):
	temporary_offset = offset

	var modified_weight = base_weight + temporary_offset

	animate_weight_change(modified_weight)

	# yellow while modified
	if temporary_offset != 0:
		weight_label.modulate = MODIFIED_COLOR
	else:
		weight_label.modulate = NORMAL_COLOR


func clear_temporary_modifier():
	temporary_offset = 0

	animate_weight_change(base_weight)

	weight_label.modulate = NORMAL_COLOR


# -------------------------------------------------
# INTERNAL DISPLAY
# -------------------------------------------------

func set_weight_immediate(weight:int):
	current_weight = weight
	weight_label.text = str(weight)


func animate_weight_change(weight:int):
	current_weight = weight
	_start_operation_timer(weight)


func update_trait_label(_trait: PersonalityTrait):
	trait_icon.texture = _trait.display_texture
	trait_label.text = _trait.name
	trait_context.set_context(_trait.description)


# -------------------------------------------------
# SIGNAL CONNECTIONS
# -------------------------------------------------
func on_personality_updated(_trait: PersonalityTrait, weight:int):
	_on_updated_trait(_trait)
	_on_updated_weight(weight)

func connect_to_battle_trait(_trait: Trait):

	if !_trait.updated_trait_weight.is_connected(_on_updated_weight):
		_trait.updated_trait_weight.connect(_on_updated_weight)

	if !_trait.updated_trait.is_connected(_on_updated_trait):
		_trait.updated_trait.connect(_on_updated_trait)

	initialize_display(_trait.data, _trait.weight_value)


func disconnect_from_battle_trait(_trait: Trait):

	if _trait.updated_trait_weight.is_connected(_on_updated_weight):
		_trait.updated_trait_weight.disconnect(_on_updated_weight)

	if _trait.updated_trait.is_connected(_on_updated_trait):
		_trait.updated_trait.disconnect(_on_updated_trait)


# -------------------------------------------------
# SIGNAL EVENTS
# -------------------------------------------------

func _on_updated_trait(_trait: PersonalityTrait):
	update_trait_label(_trait)


func _on_updated_weight(current:int):

	# battle changes should behave as temporary modifiers
	var offset = current - base_weight

	set_temporary_modifier(offset)


# -------------------------------------------------
# ANIMATION
# -------------------------------------------------

func _start_operation_timer(weight:int):

	var current_displayed = weight_label.text.to_int()
	var difference = weight - current_displayed

	if difference > 0:
		operation_label.text = "+" + str(difference)
	elif difference < 0:
		operation_label.text = str(difference)
	else:
		operation_label.text = ""

	pending_weight_text = str(weight)

	operation_timer.start()


func _on_operation_timer_timeout() -> void:

	weight_label.text = pending_weight_text
	operation_label.text = ""

	finished_animation.emit()

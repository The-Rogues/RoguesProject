extends Control
class_name TraitDisplay

signal finished_animation

@onready var trait_label: Label = $Offensive/TraitLabel
@onready var trait_context: ContextPanel = $Offensive/TraitLabel/TraitContext
@onready var weight_label: Label = %WeightLabel
@onready var operation_label: Label = %OperationLabel
@onready var operation_timer: Timer = %OperationTimer
var pending_weigh_text:String = ""
@onready var trait_icon: TextureRect = %TraitIcon


func update_weight_label(weight:int):
	_start_operation_timer(weight)
	#weight_label.text = str(weight)


func update_trait_label(_trait:PersonalityTrait):
	trait_icon.texture = _trait.display_texture
	trait_label.text = _trait.name
	trait_context.set_context(_trait.description)


func connect_to_data(trait_category:String, data:PersonalityData):
	trait_category = trait_category.to_upper()
	
	if trait_category == "OFFENSIVE":
		data.updated_offensive_trait.connect(_on_trait_data_updated)
	elif trait_category == "DEFENSIVE":
		data.updated_defensive_trait.connect(_on_trait_data_updated)
	elif trait_category == "STRATEGIC":
		data.updated_strategic_trait.connect(_on_trait_data_updated)


func connect_to_battle_trait(_trait:Trait):
	_trait.updated_trait_weight.connect(_on_updated_weight)
	_trait.updated_trait.connect(_on_updated_trait)
	
	weight_label.text = str(_trait.weight_value)
	#update_weight_label(_trait.weight_value)
	update_trait_label(_trait.data)


func disconnect_from_battle_trait(_trait: Trait):
	if _trait.updated_trait_weight.is_connected(_on_updated_weight):
		_trait.updated_trait_weight.disconnect(_on_updated_weight)
	
	if _trait.updated_trait.is_connected(_on_updated_trait):
		_trait.updated_trait.disconnect(_on_updated_trait)


func _on_updated_trait(_trait:PersonalityTrait):
	update_trait_label(_trait)


func _on_updated_weight(current:int):
	update_weight_label(current)


func _on_trait_data_updated(_trait:PersonalityTrait, current:int):
	update_trait_label(_trait)
	update_weight_label(current)
	#weight_label.text = str(current)


func _start_operation_timer(weight:int):
	var current_weight = weight_label.text.to_int()
	var difference = weight - current_weight
	var operation_text = ""
	if difference > 0:
		operation_text = "+" + str(difference)
	elif difference < 0:
		operation_text = str(difference)
	else:
		operation_text = ""  # no change
	pending_weigh_text = str(weight)
	operation_label.text = operation_text
	operation_timer.start()


func _on_operation_timer_timeout() -> void:
	weight_label.text = pending_weigh_text
	operation_label.text = ""
	finished_animation.emit()
	pass # Replace with function body.

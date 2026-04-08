extends Control
class_name TraitDisplay

@onready var trait_label: Label = $Offensive/TraitLabel
@onready var trait_context: ContextPanel = $Offensive/TraitLabel/TraitContext
@onready var weight_label: Label = $Offensive/WeightLabel


func update_weight_label(weight:int):
	weight_label.text = str(weight)


func update_trait_label(_trait:PersonalityTrait):
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
	
	update_weight_label(_trait.weight_value)
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

extends PanelContainer
class_name TraitDisplay

@onready var offensive_trait_rect:TextureRect = $HBoxContainer/PanelContainer/VBoxContainer/VBoxContainer/HBoxContainer/OffensiveTraitRect
@onready var offensive_context:ContextPanel = $HBoxContainer/PanelContainer/VBoxContainer/VBoxContainer/HBoxContainer/OffensiveTraitRect/OffensiveContext
@onready var offensive_weight: Label = $HBoxContainer/PanelContainer/VBoxContainer/VBoxContainer/HBoxContainer/OffensiveTraitRect/OffensiveWeightLabel

@onready var defensive_trait_rect:TextureRect = $HBoxContainer/PanelContainer/VBoxContainer/VBoxContainer/HBoxContainer/DefensiveTraitRect
@onready var defensive_context:ContextPanel = $HBoxContainer/PanelContainer/VBoxContainer/VBoxContainer/HBoxContainer/DefensiveTraitRect/DefensiveContext
@onready var defensive_weight: Label = $HBoxContainer/PanelContainer/VBoxContainer/VBoxContainer/HBoxContainer/DefensiveTraitRect/DefensiveWeightLabel


@onready var strategic_trait_rect:TextureRect = $HBoxContainer/PanelContainer/VBoxContainer/VBoxContainer/HBoxContainer/StrategicRect
@onready var strategic_context:ContextPanel = $HBoxContainer/PanelContainer/VBoxContainer/VBoxContainer/HBoxContainer/StrategicRect/StrategicContext
@onready var strategic_weight: Label = $HBoxContainer/PanelContainer/VBoxContainer/VBoxContainer/HBoxContainer/StrategicRect/StrategicLabel


func _ready() -> void:
	if GlobalSessionManager.run_progress == null:
		return
	initialize(GlobalSessionManager.run_progress.personality_data)

func initialize(personality_data:PersonalityData):
	var offensive_trait:PersonalityTrait = personality_data.offensive_trait
	var defensive_trait:PersonalityTrait = personality_data.defensive_trait
	var strategic_trait:PersonalityTrait = personality_data.strategic_trait
	
	offensive_trait_rect.texture = offensive_trait.trait_icon
	defensive_trait_rect.texture = defensive_trait.trait_icon
	strategic_trait_rect.texture = strategic_trait.trait_icon
	
	offensive_context.set_context(
		offensive_trait.description
	)
	offensive_weight.text = str(personality_data.offensive_weight)
	
	defensive_context.set_context(
		defensive_trait.description
	)
	defensive_weight.text = str(personality_data.defensive_weight)
	
	strategic_context.set_context(
		strategic_trait.description
	)
	strategic_weight.text = str(personality_data.strategic_weight)

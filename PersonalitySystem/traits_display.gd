extends PanelContainer
class_name TraitDisplay

@export var aggression_trait:TextureRect
@export var aggressive_context:ContextPanel
@export var aggression_weight: Label

@export var survival_trait:TextureRect
@export var survival_context:ContextPanel
@export var survival_weight: Label


@export var drive_trait:TextureRect
@export var drive_context:ContextPanel
@export var drive_weight: Label


func _ready() -> void:
	if GlobalSessionManager.run_progress == null:
		return
	initialize()

func initialize():
	var offensive_trait:TraitData = GlobalSessionManager.get_character_trait("OFFENSIVE")
	var defensive_trait:TraitData = GlobalSessionManager.get_character_trait("DEFENSIVE")
	var strategic_trait:TraitData = GlobalSessionManager.get_character_trait("STRATEGIC")
	
	aggression_trait.texture = offensive_trait.trait_icon
	survival_trait.texture = defensive_trait.trait_icon
	drive_trait.texture = strategic_trait.trait_icon
	
	aggressive_context.set_context(
		offensive_trait.trait_display_description
	)
	aggression_weight.text = str(offensive_trait.weight)
	
	survival_context.set_context(
		defensive_trait.trait_display_description
	)
	survival_weight.text = str(defensive_trait.weight)
	
	drive_context.set_context(
		strategic_trait.trait_display_description
	)
	drive_weight.text = str(strategic_trait.weight)

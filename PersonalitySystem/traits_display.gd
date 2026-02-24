extends PanelContainer
class_name TraitDisplay
## UI that displays information on a character's personality traits for this
## game.
##
## Personality data can be set manually to update UI, or remotely by a different
## class by calling initialize and passing it's own personality data (recommended).
## Personality traits are displayed as their trait name. In the future we may
## try using destinct icons for each trait however it may clutter the presentation.
## Trait names can be hovered over to display descriptions of the trait.


@export var personality_data:PersonalityData

@onready var offensive_trait: Label = $HBoxContainer/Offensive/Trait
@onready var offensive_context: ContextPanel = $HBoxContainer/Offensive/Trait/Context
@onready var offensive_weight: Label = $HBoxContainer/Offensive/Weight

@onready var defensive_trait: Label = $HBoxContainer/Defensive/Trait
@onready var defensive_context: ContextPanel = $HBoxContainer/Defensive/Trait/Context
@onready var defensive_weight: Label = $HBoxContainer/Defensive/Weight

@onready var strategic_trait: Label = $HBoxContainer/Strategic/Trait
@onready var strategic_context: ContextPanel = $HBoxContainer/Strategic/Trait/Context
@onready var strategic_weight: Label = $HBoxContainer/Strategic/Weight


func _ready() -> void:
	if personality_data:
		initialize(personality_data)


func initialize(data:PersonalityData):
	offensive_trait.text = data.offensive_trait.name
	offensive_context.set_context(data.offensive_trait.description)
	offensive_weight.text = str(data.offensive_weight)
	
	defensive_trait.text = data.defensive_trait.name
	defensive_context.set_context(data.defensive_trait.description)
	defensive_weight.text = str(data.defensive_weight)
	
	strategic_trait.text = data.strategic_trait.name
	strategic_context.set_context(data.strategic_trait.description)
	strategic_weight.text = str(data.strategic_weight)
	
	data.updated_traits.connect(initialize)

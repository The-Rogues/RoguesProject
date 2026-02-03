extends Resource
class_name CardData

# Stores display and behaviour information of a card
# Create new instances in file system for different card types

@export var name:String = "New Card"
# TODO: Have description be dynamic in case cards stats change during gameplay
@export_multiline var description:String = "Action Description"
# TODO: Have energy cost also be dynamic for same reason as above
@export var energy_cost:int = 0
# Allows for configurable behaviour
# ActionGroup stores an list of actions that will be performed on a given target
# Add additional action groups to have more then one entity be effected
# Example: [0] ActionGroup A targets enemy to damage them
#          [1] ActionGroup B targets player and heals them 
# TODO: Editing card behaviours is clunky, consider creating custom card editor UI
@export var play_moves:Array[CombatMove]

#TODO: Experiment with card action images
#TODO: Associate cards with personality traits
"""
@export var display_image:AtlasTexture
@export var personality_alignment:Dictionary[PersonalityTraitData.NatureType,bool] = {
	PersonalityTraitData.NatureType.OFFENSIVE:false,
	PersonalityTraitData.NatureType.DEFENSIVE:false,
	PersonalityTraitData.NatureType.STRATEGIC:false
}

func _init(
			_name:String, 
			_description:String, 
			_cost:int, 
			_card_actions:Array[ActionGroup]) -> void:
	name = _name
	description = _description
	energy_cost = _cost
	card_actions = _card_actions
"""

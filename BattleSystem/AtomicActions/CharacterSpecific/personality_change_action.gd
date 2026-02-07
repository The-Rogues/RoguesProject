# ==========================================================
# Author: Fabian 
# Description:
#   An editable resource that performs a personality change
#   operation on the player character with paramaters for 
#   retaining old weight values.
#   To be used as a creatable asset in paramater fields of CombatMove.
#
# ==========================================================

extends AtomicAction
class_name PersonalityChangeAction

enum TraitType {OFFENSIVE, DEFENSIVE, STRATEGIC}
@export var change_trait:TraitType
## Trait that will replace specified trait
@export var new_trait:TraitData
## If toggled, weight of changed personality trai will be retained
## and specified weight is ignored
@export var keep_weight:bool = true
@export_range(1, 10) var new_weight:int = 0

# TODO: Implement the ability to make personality trait changes temporary
#   in a battle by tracking the number of turns passed in a battle

func execute(action_context:ActionContext):
	var character:CharacterData = action_context.get_player()
	var weight:int
	var chosen_trait:TraitData
	
	if change_trait == TraitType.OFFENSIVE:
		weight = character.offensive_trait.weight
		character.offensive_trait = new_trait
		chosen_trait = character.offensive_trait
	elif change_trait == TraitType.DEFENSIVE:
		weight = character.defensive_trait.weight
		character.defensive_trait = new_trait
		chosen_trait = character.defensive_trait
	elif change_trait == TraitType.STRATEGIC:
		weight = character.strategic_trait.weight
		character.strategic_trait = new_trait
		chosen_trait = character.strategic_trait
	
	if keep_weight:
		chosen_trait.weight = weight
	else:
		chosen_trait.weight = new_weight

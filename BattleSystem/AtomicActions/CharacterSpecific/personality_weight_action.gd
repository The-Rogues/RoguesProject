# ==========================================================
# Author: Fabian 
# Description:
#   An editable resource that performs a personality trait weight 
#   change operation on the player character.
#   To be used as a creatable asset in paramater fields of CombatMove.
#
# ==========================================================

extends AtomicAction
class_name PersonalityWeightAction

enum TraitType {OFFENSIVE, DEFENSIVE, STRATEGIC}
@export var change_weight_of:TraitType
## Ignores set change amount and chooses an amount in a range instead
@export var randomize_weight:bool
@export_range(-10, 10) var change_amount:int

func execute(action_context:ActionContext):
	var character:CharacterData = action_context.get_player()
	var weight:int
	if randomize_weight:
		weight = randi_range(-10, 10)
	else:
		weight = change_amount
	
	if change_weight_of == TraitType.OFFENSIVE:
		character.offensive_trait.weight += weight
	elif change_weight_of == TraitType.DEFENSIVE:
		character.defensive_trait.weight += weight
	elif change_weight_of == TraitType.STRATEGIC:
		character.strategic_trait.weight += weight

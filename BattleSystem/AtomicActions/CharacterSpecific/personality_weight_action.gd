extends AtomicAction
class_name PersonalityWeightAction
## AtomicAction that modifies the weight of a player personality trait.
##
## Adjusts the weight of the selected trait category by a fixed amount
## or a randomized value within a predefined range. This action does not
## replace the trait itself—only its influence strength.
##
## Currently applies a permanent change to the character's trait weight.
## Intended future support includes temporary, turn-based trait changes.

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

@abstract
extends BattleAction
class_name TargetedBattleAction
## Extended template for an atomic action with configurable targeting.
## Use for actions that will require a specific group or single entity that
## needs to be interacted with.

## Enum for targeting options of a targeted battle action.
enum TargetingOption {
	## Targeting chooses the entity who is executing the action.
	USER, 
	## Targeting chooses the player's character.
	PLAYER, 
	## Targeting chooses a random enemy by default. If character personality has
	## a bias towards specified types of entites, they are chosen instead. 
	ENEMY, 
	## Targeting chooses all enemies who are still alive.
	ALL_ENEMIES, 
	## Targeting is not defined by this instance. Available in case another
	## action needs to override targeting of another action.
	LAST_TARGET
}
# Sets what entities targeted
@export var targeting:TargetingOption

## The resolved targeting set after calling _resolve_target(). Is empty otherwise.
var targets:Array[Entity]

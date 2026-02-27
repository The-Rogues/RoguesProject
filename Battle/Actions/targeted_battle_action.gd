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
	INHERITED
}
# Sets what entities targeted
@export var targeting:TargetingOption

## The resolved targeting set after calling _resolve_target(). Is empty otherwise.
var targets:Array[BattleEntity]
## Targeting explicitly set by another script. Used if target is TargetType.INHERITED
var inherited_targeting:Array[BattleEntity]


func _execute(battle_instance:BattleManager, _action_user:BattleEntity = null):
	targets = []
	if inherited_targeting: 
		targets = inherited_targeting
	else :
		targets = _resolve_target(battle_instance, _action_user)


## Returns an array of entities according to the targeting option set in target
## member value.
func _resolve_target(
	battle_instance:BattleManager, 
	action_user:BattleEntity
) -> Array[BattleEntity]:
	match targeting:
		TargetingOption.USER:
			return [action_user] as Array[BattleEntity]
			
		TargetingOption.PLAYER:
			return [battle_instance.player_entity] as Array[BattleEntity]
			
		TargetingOption.ENEMY:
			# Target an enemy the character is biased towards if user is the
			# player character.
			if action_user == battle_instance.player_entity:
				return [
					battle_instance.character_personality.get_target_entity(
							battle_instance.living_enemies
					)
				]
			# Otherwise, assume enemy is targeting allies, excluding self.
			var target_canidates:Array[BattleEntity] = battle_instance.living_enemies
			if target_canidates.has(action_user):
				target_canidates.erase(action_user)
			return [target_canidates.pick_random()] as Array[BattleEntity]
			
		TargetingOption.ALL_ENEMIES:
			return battle_instance.living_enemies
			
		TargetingOption.INHERITED:
			return inherited_targeting
			
		_:
			printerr("Unresolvable targeting in TargetedBattleAction")
			return [] as Array[BattleEntity]

@abstract
extends BattleAction
class_name TargetedBattleAction

enum TargetType {USER, PLAYER, ENEMY, ALL_ENEMIES, INHERITED}
@export var target:TargetType
var targeting:Array[BattleEntity]
var inherited_targeting:Array[BattleEntity]

@abstract
func _execute(battle_instance:BattleManager, action_user:BattleEntity)


func _resolve_target(
			battle_instance:BattleManager, 
			action_user:BattleEntity
	) -> Array[BattleEntity]:
	match target:
		TargetType.USER:
			return [action_user] as Array[BattleEntity]
		TargetType.PLAYER:
			return [battle_instance.player_entity] as Array[BattleEntity]
		TargetType.ENEMY:
			var target_canidates:Array[BattleEntity] = \
					battle_instance.living_enemies
			if action_user == battle_instance.player_entity:
				
				return [
						battle_instance.character_personality.get_target(
								target_canidates
						)
				] as Array[BattleEntity]
			else:
				return [target_canidates.pick_random()] as Array[BattleEntity]
		TargetType.ALL_ENEMIES:
			return battle_instance.living_enemies as Array[BattleEntity]
		TargetType.INHERITED:
			return inherited_targeting
		_:
			printerr("Unresolvable targeting in TargetedBattleAction")
			return [] as Array[BattleEntity]

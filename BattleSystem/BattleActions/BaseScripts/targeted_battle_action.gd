@abstract
extends BattleAction
class_name TargetedBattleAction

enum TargetType {USER, PLAYER, ENEMY, ALL_ENEMIES}
@export var target:TargetType

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
			return [battle_instance.living_enemies.pick_random()] as Array[BattleEntity]
		TargetType.ALL_ENEMIES:
			return battle_instance.living_enemies as Array[BattleEntity]
		_:
			printerr("Unresolvable targeting in TargetedBattleAction")
			return [] as Array[BattleEntity]

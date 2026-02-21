extends BattleAction
class_name MovePlayerAction

enum DirectionType {LEFT, RIGHT, RANDOM}
@export var direction:DirectionType
@export_range(1, 4) var steps:int = 1

func _execute(battle_instance:BattleManager, action_user:BattleEntity):
	if not battle_instance.player_entity.can_move:
		battle_instance.player_entity.animation_player.play("entity/healed")
		await battle_instance.action_delay()
		return
	
	var dir:int = battle_instance.battle_field.get_nearest_object_direction(
		ObjectEntityData.Type.COVER
	)
	
	#var dir:int = steps
	if direction == DirectionType.LEFT:
		dir = -dir
	elif direction == DirectionType.RIGHT:
		pass
	battle_instance.battle_field.move_player(dir)
	await battle_instance.battle_field.moved_position

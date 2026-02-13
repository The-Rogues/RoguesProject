extends BattleAction
class_name MovePlayerAction

enum DirectionType {LEFT, RIGHT, RANDOM}
@export var direction:DirectionType
@export_range(1, 4) var steps:int = 1

func _execute(battle_instance:BattleManager, action_user:BattleEntity):
	if not battle_instance.player_entity.can_move:
		battle_instance.player_entity.entity_animator.play("battle_entity/healed")
		await battle_instance.player_entity.action_wait_time()
		return
	
	var dir:int = steps
	if direction == DirectionType.LEFT:
		dir = -dir
	elif direction == DirectionType.RIGHT:
		pass
	elif direction == DirectionType.RANDOM:
		var rand = randf()
		
		if rand < 0.5:
			dir *= -1
	
	battle_instance.battle_field.move_player(dir)
	await battle_instance.battle_field.moved_position

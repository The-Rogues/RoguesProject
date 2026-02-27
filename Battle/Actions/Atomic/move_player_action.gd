extends BattleAction
class_name MovePlayerAction
## Moves the player character to a specified direction or position.

enum DirectionType {LEFT, RIGHT, RANDOM, LEFT_MOST, RIGHT_MOST}
@export var direction:DirectionType
@export_range(1, 4) var steps:int = 1

func _execute(battle_instance:BattleManager, _action_user:BattleEntity = null):
	if not battle_instance.player_entity.can_move:
		battle_instance.player_entity.animation_player.play("entity/healed")
		await battle_instance.action_delay()
		return
	
	match direction:
		DirectionType.LEFT:
			battle_instance.battle_field.move_entity_left()
		DirectionType.RIGHT:
			battle_instance.battle_field.move_entity_right()
		DirectionType.RANDOM:
			_move_direction_bias(battle_instance)
		DirectionType.LEFT_MOST:
			var pos = battle_instance.battle_field.battle_positions[0]
			battle_instance.battle_field.move_entity(pos)
		DirectionType.RIGHT_MOST:
			var last_index = battle_instance.battle_field.battle_positions.size() - 1
			var pos = battle_instance.battle_field.battle_positions[last_index]
			battle_instance.battle_field.move_entity(pos)
	
	await battle_instance.battle_field.entity_arrived


func _move_direction_bias(battle_instance:BattleManager):
	var dir:int = battle_instance.character_personality.strategic_trait.get_direction(battle_instance.battle_field)
	if dir == 1:
		battle_instance.battle_field.move_entity_right()
	else:
		battle_instance.battle_field.move_entity_left()

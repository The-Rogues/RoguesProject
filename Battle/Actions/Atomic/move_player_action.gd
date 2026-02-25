extends BattleAction
class_name MovePlayerAction

enum DirectionType {LEFT, RIGHT, RANDOM}
@export var direction:DirectionType
@export_range(1, 4) var steps:int = 1

func _execute(battle_instance:BattleManager, _action_user:BattleEntity = null):
	if not battle_instance.player_entity.can_move:
		battle_instance.player_entity.animation_player.play("entity/healed")
		await battle_instance.action_delay()
		return
	
	var dir:int = battle_instance.character_personality.strategic_trait.get_direction(battle_instance.battle_field)
	if dir == 1:
		battle_instance.battle_field.move_entity_right()
	else:
		battle_instance.battle_field.move_entity_left()
	
	await battle_instance.battle_field.entity_arrived

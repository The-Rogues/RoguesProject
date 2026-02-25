extends BattleAction
class_name PositionEffectAction

@export var position_effects:Array[PositionEffectData]

func _execute(battle_instance:BattleManager, _action_user:BattleEntity = null):
	var position_effect:PositionEffectData = position_effects.pick_random()
	var battle_position = battle_instance.battle_field.battle_positions.pick_random()
	battle_position.set_effect(position_effect)
	await battle_instance.action_delay()

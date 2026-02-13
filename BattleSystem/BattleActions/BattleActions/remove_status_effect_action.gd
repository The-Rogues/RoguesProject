extends TargetedBattleAction
class_name RemoveStatusEffectAction

@export var status_effect:StatusEffectData

func _execute(battle_instance:BattleManager, action_user:BattleEntity):
	var targeting = _resolve_target(battle_instance, action_user)
	var battle_object:BattleFieldObject = \
			battle_instance.battle_field.get_object_infront_of_player()
	var object_data:BattleObjectData = null
	if battle_object:
		object_data = battle_object.entity_data
	
	for target in targeting:
		if battle_object:
			if object_data.attack_filter == object_data.BlockMode.BLOCK:
				battle_object.take_damage(0, action_user)
				await battle_object.action_wait_time()
				continue
		
		target.find_and_remove_status(status_effect.id)
		await target.action_wait_time()

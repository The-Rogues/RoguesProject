extends TargetedBattleAction
class_name DamageAndStatusEffectAction

enum Operation{ADD, REMOVE}
@export var operation:Operation
@export_range(0, 999) var damage:int = 6
@export var status_effect:StatusEffectData
@export var duration:int
@export var stack_count:int
@export_range(0,1) var status_chance:float = 1.0

func _execute(battle_instance:BattleManager, action_user:BattleEntity):
	var targeting := _resolve_target(battle_instance, action_user)
	var final_damage:int = action_user.get_attack_damage(damage)
	
	var battle_object:BattleFieldObject = \
			battle_instance.battle_field.get_object_infront_of_player()
	var object_data:BattleObjectData = null
	if battle_object:
		object_data = battle_object.entity_data as BattleObjectData
		final_damage = final_damage * object_data.attack_amplifier
	
	for target in targeting:
		if battle_object:
			if object_data.attack_filter == object_data.BlockMode.BLOCK:
				battle_object.take_damage(final_damage, action_user)
				await battle_object.action_wait_time()
				continue
		
		target.take_damage(final_damage, action_user)
		if targeting.size() == 1:
			await target.action_wait_time()
		
		if randf() <= status_chance:
			if operation == Operation.ADD:
				target.add_status(status_effect, duration, stack_count)
			elif operation == Operation.REMOVE:
				target.find_and_remove_status(status_effect.id)
			if targeting.size() == 1:
				await target.action_wait_time()

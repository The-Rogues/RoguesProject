extends AtomicAction
class_name DamageAction

@export var damage:int = 0

func execute(battle_info:BattleActionInfo):
	var user = battle_info.user
	var final_damage:int = damage
	var battle_object = battle_info.battle_field.get_object_infront_of_player()
	
	if user is BattleEntity:
		final_damage = damage * user.entity_data.attack_amplifier.value
	
	for target in battle_info.targets:
		if battle_object:
			battle_object.take_damage(damage, user)
			
			if battle_object.blocks_attacker(user):
				await battle_object.entity_animator.animation_finished
				return
		
		target.take_damage(final_damage)
		# Play all damage animations at once
		if battle_info.targets.size() > 1:
			continue
		# Waits for animation to finish before returning
		# Function that calls execute is also waiting for this function to finish
		# before running other functions
		if !target.is_defeated:
			await target.entity_animator.animation_finished
		#await battle_info.animation_bus.play_hit(entity)

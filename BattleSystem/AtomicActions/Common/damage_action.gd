extends AtomicAction
class_name DamageAction
## AtomicAction that applies immediate damage to targeted battle entities.
##
## Damage is optionally scaled by the attacking entity’s attack amplifier
## and may be intercepted or fully blocked by battlefield objects positioned
## in front of the player. When multiple targets are present, damage is
## applied without waiting; for single targets, execution briefly yields
## to improve hit readability and effect sequencing.
##
## All entities handle their own damage logic

## Controls the amount of damage a targeted entity will recieve
@export var damage:int = 0


# TODO: Creating a timer on the tree for pausing execution isn't reccomended
# in most cases. Consider having damage response time stored locally in 
# entity class
func execute(action_context:ActionContext):
	var user = action_context.user
	var final_damage:int = damage
	var battle_object = action_context.battle_field.get_object_infront_of_player()
	
	# Assumes user will not always be battle entity to make function testable
	# with null users
	if user is BattleEntity:
		final_damage = damage * user.entity_data.attack_amplifier.value
	
	for target in action_context.targets:
		# Checks for battle object incase it is destroyed between targets
		if battle_object:
			battle_object.take_damage(damage, user)
			
			if battle_object.blocks_attacker(user):
				await battle_object.get_tree().create_timer(0.15).timeout
				return
		
		target.take_damage(final_damage)
		
		if action_context.targets.size() > 1:
			await target.get_tree().create_timer(0.05).timeout
			continue
		
		if !target.is_defeated:
			await target.get_tree().create_timer(0.15).timeout

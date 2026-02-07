# ==========================================================
# Author: Fabian 
# Description:
#   An editable resource that performs a damage operation on
#   an entity, taking into account the user's attack amplifiers.
#   Incoming damage can be intercepted or blocked depending on
#   the set data fields in an object's BattleObjectData
#   To be used as a creatable asset in paramater fields of CombatMove.
#
# ==========================================================

extends AtomicAction
class_name DamageAction

## Damage to deal to targets
@export var damage:int = 0

func execute(action_context:ActionContext):
	var user = action_context.user
	var final_damage:int = damage
	var battle_object = action_context.battle_field.get_object_infront_of_player()
	# Check made in case user is null, which may be the case in testing
	# Example: Pressing a button that queues a damage action to an entity
	if user is BattleEntity:
		final_damage = damage * user.entity_data.attack_amplifier.value
	
	for target in action_context.targets:
		if battle_object:
			# battle object will check itself if a user can damage it
			battle_object.take_damage(damage, user)
			# battle object blocks an incoming attack
			if battle_object.blocks_attacker(user):
				await battle_object.entity_animator.animation_finished
				return
		# target handles its own damage logic
		target.take_damage(final_damage)
		# Doesn't wait for damage animation to finish before damaging
		# other targets
		if action_context.targets.size() > 1:
			continue
		# Waits for damage animation to finish before completing execution
		# Useful for if you want to make it clear an entity was hit multiple times
		# or hit then had a status effect inflected on them
		if !target.is_defeated:
			await target.entity_animator.animation_finished

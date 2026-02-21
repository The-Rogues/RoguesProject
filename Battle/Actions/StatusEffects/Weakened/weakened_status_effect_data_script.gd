extends StatusEffectData
class_name WeakenedStatusEffect


func modify_outgoing_damage(amount: int, instance: StatusEffect) -> int:
	return max(1, amount - instance.stack_count)


func get_description(instance: StatusEffect) -> String:
	return "Attack damage is reduced by " + str(instance.stack_count)

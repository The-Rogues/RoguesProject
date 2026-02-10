extends StatusEffectData
class_name ProtectedStatusEffect


func modify_incoming_damage(amount: int, instance: StatusEffect) -> int:
	return min(1, amount - instance.stack_count)


func get_description(instance: StatusEffect) -> String:
	return "Reduces incoming damage by " + str(instance.stack_count)

extends StatusEffectData
class_name ProtectedStatusEffect


func modify_incoming_damage(amount: int, instance: StatusEffect) -> int:
	return max(1, int(amount / 2))


func get_description(instance: StatusEffect) -> String:
	return "Reduces incoming damage by 50%"

extends StatusEffectData
class_name ProtectedStatusEffect


func modify_incoming_damage(amount: int, instance: StatusEffect) -> int:
	return int(max(amount / 2, 1))


func get_description(instance: StatusEffect) -> String:
	return "Reduces incoming damage by 50%"

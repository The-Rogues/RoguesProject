extends StatusEffectData
class_name WeakenedStatusEffect


func modify_outgoing_damage(amount: int, instance: StatusEffect) -> int:
	return max(1, amount * 0.5)


func get_description(instance: StatusEffect) -> String:
	return "Attack damage is reduced by 50%"

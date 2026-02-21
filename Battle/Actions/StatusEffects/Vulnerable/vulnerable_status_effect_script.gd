extends StatusEffectData
class_name VulnerableStatusEffect

func modify_incoming_damage(amount: int, instance: StatusEffect) -> int:
	return amount * 1.5 

func get_description(instance: StatusEffect) -> String:
	return "Increases damage from attacks by 50%"

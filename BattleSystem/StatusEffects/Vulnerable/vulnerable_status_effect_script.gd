extends StatusEffectData
class_name VulnerableStatusEffect

func modify_incoming_damage(amount: int, instance: StatusEffect) -> int:
	return amount + instance.stack_count

func get_description(instance: StatusEffect) -> String:
	return "Increases damage from attacks by " + str(instance.stack_count)

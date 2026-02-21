extends StatusEffectData
class_name StrengthStatusEffect

func modify_outgoing_damage(amount: int, instance: StatusEffect) -> int:
	return amount + instance.stack_count

func get_description(instance: StatusEffect) -> String:
	return "Increases damage dealt from attacks by " + str(instance.stack_count)

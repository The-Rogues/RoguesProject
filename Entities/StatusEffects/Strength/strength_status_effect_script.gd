extends StatusEffectData
class_name StrengthStatusEffect

func modify_outgoing_damage(amount: int, instance: StatusEffect) -> int:
	return amount + instance.stack_count

func get_description(_instance: StatusEffect) -> String:
	return "Increases attack damage by " + str(_instance.stack_count) + " per hit."

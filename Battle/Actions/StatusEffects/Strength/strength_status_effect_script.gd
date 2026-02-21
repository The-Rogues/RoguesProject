extends StatusEffectData
class_name StrengthStatusEffect

func modify_outgoing_damage(amount: int, instance: StatusEffect) -> int:
	return amount * 1.5

func get_description(instance: StatusEffect) -> String:
	return "Increases damage dealt from attacks by 50%"

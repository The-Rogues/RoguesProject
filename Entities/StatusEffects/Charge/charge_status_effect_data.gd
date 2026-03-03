extends StatusEffectData
class_name ChargeStatusEffectData

func modify_projectile_damage(amount: int, instance: StatusEffect) -> int:
	return amount + instance.stack_count

func get_description(instance: StatusEffect) -> String:
	return "Increases projectile damage by " + str(instance.stack_count) + ". Removed after use."

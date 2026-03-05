extends StatusEffectData
class_name RepeaterStatusEffect

func get_description(instance: StatusEffect) -> String:
	return "Increases number of projectiles fired by " + str(instance.stack_count)

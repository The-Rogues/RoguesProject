extends StatusEffectData
class_name RegeneratingStatusEffect

func on_turn_start(entity: BattleEntity, instance: StatusEffect) -> void:
	entity.heal(instance.stack_count)

func get_description(instance: StatusEffect) -> String:
	return "Restores " + str(instance.stack_count) + " health each turn"

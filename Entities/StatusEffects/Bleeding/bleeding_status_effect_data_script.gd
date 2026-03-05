extends StatusEffectData
class_name BleedingStatusEffect

func on_apply(entity: BattleEntity, instance: StatusEffect) -> void:
	entity.can_heal = false

func on_remove(entity: BattleEntity, instance: StatusEffect) -> void:
	entity.can_heal = true

func get_description(instance: StatusEffect) -> String:
	return "Prevents healing for " + str(instance.duration) + "turns"

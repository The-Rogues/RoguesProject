extends StatusEffectData
class_name PetrifiedStatusEffect

func on_apply(entity: BattleEntity, instance: StatusEffect) -> void:
	entity.can_move = false

func on_remove(entity: BattleEntity, instance: StatusEffect) -> void:
	entity.can_move = true

func get_description(instance: StatusEffect) -> String:
	return "Prevents movement for " + str(instance.duration) + " turns"

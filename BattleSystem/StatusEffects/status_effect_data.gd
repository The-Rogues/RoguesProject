@abstract
extends Resource
class_name StatusEffectData

@export var id: String
@export var display_name: String
@export var icon: Texture2D
@export var is_stackable: bool = false

func on_apply(entity: BattleEntity, instance: StatusEffect) -> void:
	pass

func on_remove(entity: BattleEntity, instance: StatusEffect) -> void:
	pass

func on_turn_start(entity: BattleEntity, instance: StatusEffect) -> void:
	pass

func modify_outgoing_damage(amount: int, instance: StatusEffect) -> int:
	return amount

func modify_incoming_damage(amount: int, instance: StatusEffect) -> int:
	return amount

func get_description(instance: StatusEffect) -> String:
	return "No effect"

extends Resource
class_name StatusCondition

@export var id: String
@export var display_name: String
@export var icon: Texture2D
@export var duration: int = 1
@export var stack_count: int = 1
@export var is_stackable: bool = false

func on_apply(entity: BattleEntity) -> void:
	pass

func on_remove(entity: BattleEntity) -> void:
	pass

func on_turn_start(entity: BattleEntity) -> void:
	pass

func modify_damage_out(amount: int) -> int:
	return amount

func modify_damage_in(amount: int) -> int:
	return amount

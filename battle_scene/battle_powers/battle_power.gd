@abstract
extends Resource
class_name BattlePower

signal power_ended(behaviour:BattlePower)

@export var can_reapply: bool = false

@abstract
func on_apply(_context:BattleContext)

func on_stack():
	pass

func on_remove():
	pass


func on_turn_entered(_context:BattleContext):
	pass

func on_turn_ended(_context: BattleContext):
	pass

func end_power():
	power_ended.emit(self)

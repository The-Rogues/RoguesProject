extends Resource
class_name StatusEffectConfig

@export var behaviour:StatusEffectBehaviour
@export_range(-1, 99) var duration:int = 1
@export_range(-99, 99) var stack:int = 1
@export var turn_entered: bool = true


func create_effect() -> ActiveStatusEffect:
	var instance := ActiveStatusEffect.new(
		behaviour,
		duration,
		stack,
		turn_entered
	)
	return instance

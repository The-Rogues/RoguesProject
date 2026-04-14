extends RefCounted
class_name ActiveStatusEffect

signal effect_ended(behaviour:Script)

var effect:StatusEffectBehaviour
var duration:int = 0
var stack:int = -1

func _init(
	behaviour:StatusEffectBehaviour,
	starting_duration:int,
	starting_stack:int,
) -> void:
	self.effect = behaviour
	self.duration = starting_duration
	self.stack = starting_stack
	
	behaviour.effect_ended.connect(_on_end_effect)


func _on_end_effect():
	effect_ended.emit(effect.get_script())

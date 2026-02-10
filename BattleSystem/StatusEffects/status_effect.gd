extends RefCounted
class_name StatusEffect

var effect: StatusEffectData
var duration: int = 0
var stack_count: int = 1

func _init(effect: StatusEffectData, new_duration: int, new_stack_count: int = 1):
	self.effect = effect
	self.duration = new_duration
	self.stack_count = new_stack_count

extends HBoxContainer
class_name StatusEffectsContainer

const Status_Icon = preload("res://battle_scene/entities/ui/stack_icon.tscn")

var icons:Dictionary[ActiveStatusEffect, StackIcon]


func initialize(effects_controller:StatusEffectController):
	if effects_controller == null:
		return
	
	effects_controller.effect_added.connect(_on_effect_added)
	effects_controller.effect_removed.connect(_on_effect_removed)
	effects_controller.effect_changed.connect(_on_effect_changed)


func _on_effect_added(instance:ActiveStatusEffect):
	var icon:StackIcon = Status_Icon.instantiate()
	add_child(icon)
	icon.initialize(instance)
	#icon.set_texture(instance.effect.get_texture())
	#icon.set_stack(instance.duration)
	icons[instance] = icon


func _on_effect_changed(instance:ActiveStatusEffect):
	if icons.has(instance):
		icons[instance].initialize(instance)


func _on_effect_removed(instance:ActiveStatusEffect):
	if icons.has(instance):
		icons[instance].queue_free()
		icons.erase(instance)

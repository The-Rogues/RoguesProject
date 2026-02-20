extends Control
class_name StatusEffectIcon

@onready var icon: TextureRect = $PanelContainer/MarginContainer/Icon
@onready var duration_label: Label = $Duration
@onready var context_panel: ContextPanel = $ContextPanel

var instance: StatusEffect

func initialize(status_instance: StatusEffect):
	instance = status_instance
	icon.texture = instance.effect.icon
	update_ui()

func update_ui():
	duration_label.visible = instance.duration >= 0
	duration_label.text = str(instance.duration)
	context_panel.set_context(instance.effect.get_description(instance))


func _on_icon_mouse_entered() -> void:
	context_panel.visible = true
	pass # Replace with function body.


func _on_icon_mouse_exited() -> void:
	context_panel.visible = false
	pass # Replace with function body.

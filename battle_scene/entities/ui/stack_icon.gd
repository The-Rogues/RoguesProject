extends Control
class_name StackIcon

@onready var icon: TextureRect = $StackIcon/MarginContainer/Icon
@onready var stack_label: Label = $StackIcon/StackLabel
@onready var status_tool_tip: StatusToolTip = $StatusToolTip


func initialize(instance:ActiveStatusEffect):
	icon.texture = instance.effect.get_texture()
	stack_label.text = str(instance.duration)
	status_tool_tip.initialize(instance)


func set_texture(texture_2d:Texture2D):
	icon.texture = texture_2d


func set_stack(stack:int):
	if stack > 0:
		stack_label.text = str(stack)
		stack_label.visible = true
	else:
		stack_label.visible = false


func _on_icon_mouse_entered() -> void:
	var pos = status_tool_tip.global_position
	status_tool_tip.visible = true
	status_tool_tip.top_level = true
	status_tool_tip.global_position = pos
	pass # Replace with function body.


func _on_icon_mouse_exited() -> void:
	var pos = status_tool_tip.global_position
	status_tool_tip.visible = false
	status_tool_tip.top_level = false
	status_tool_tip.global_position = pos
	pass # Replace with function body.

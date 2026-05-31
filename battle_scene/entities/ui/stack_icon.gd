extends Control
class_name StackIcon

@export var move_tooltip_up: bool = false
@export var tooltip_y_offset: float = 50.0

@onready var icon: TextureRect = $StackIcon/MarginContainer/Icon
@onready var stack_label: Label = $StackIcon/StackLabel
@onready var status_tool_tip: StatusToolTip = $StatusToolTip

var _base_tooltip_global_pos: Vector2


func _ready() -> void:
	_base_tooltip_global_pos = status_tool_tip.global_position


func initialize(instance: ActiveStatusEffect):
	icon.texture = instance.effect.get_texture()

	if instance.stack != 0:
		stack_label.text = str(instance.stack)
	else:
		stack_label.text = str(instance.duration)

	stack_label.modulate = Color(1.0, 0.0, 0.0)
	stack_label.label_settings = LabelSettings.new()
	stack_label.label_settings.outline_size = 10
	stack_label.label_settings.outline_color = Color(0.0, 0.0, 0.0)

	status_tool_tip.initialize(instance)


func set_texture(texture_2d: Texture2D):
	icon.texture = texture_2d


func set_stack(stack: int):
	if stack > 0:
		stack_label.text = str(stack)
		stack_label.visible = true
	else:
		stack_label.visible = false


func _on_icon_mouse_entered() -> void:
	var pos := status_tool_tip.global_position

	if move_tooltip_up:
		pos.y -= tooltip_y_offset

	status_tool_tip.top_level = true
	status_tool_tip.global_position = pos
	status_tool_tip.visible = true
	status_tool_tip.visible = true



func _on_icon_mouse_exited() -> void:
	var pos := status_tool_tip.global_position

	if move_tooltip_up:
		pos.y += tooltip_y_offset

	status_tool_tip.visible = false
	status_tool_tip.top_level = false
	status_tool_tip.global_position = pos

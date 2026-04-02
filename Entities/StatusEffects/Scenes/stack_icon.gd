extends PanelContainer
class_name StackIcon

@onready var icon: TextureRect = $MarginContainer/Icon
@onready var stack_label: Label = $StackLabel


func set_texture(texture_2d:Texture2D):
	icon.texture = texture_2d


func set_stack(stack:int):
	if stack > 0:
		stack_label.text = str(stack)
		stack_label.visible = true
	else:
		stack_label.visible = false

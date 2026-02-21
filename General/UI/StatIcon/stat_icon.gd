extends TextureRect
class_name StatIcon

@onready var stack: Label = $CenterContainer/Stack
#@onready var context_panel: ContextPanel = $ContextPanel

func update_ui(stack_count:int):
	if stack_count == 0:
		visible = false
		return
	visible = true
	stack.text = str(stack_count)

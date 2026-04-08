extends TextureRect

@onready var stack: Label = $Stack

func initialize(block:Block):
	block.changed.connect(_on_block_changed)


func _on_block_changed(current:int):
	if current > 0:
		visible = true
		stack.text = str(current)
	else:
		visible = false

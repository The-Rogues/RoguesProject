extends TextEdit

@onready var character_limit_label: Label = $CharacterLimit
@export var character_limit:int = 80

func _ready() -> void:
	character_limit_label.text =  "0/" + str(character_limit)

func _on_text_changed() -> void:
	var description:String = text
	if description.length() == character_limit + 1:
		description = description.left(description.length() - 1)
		text = description
		move_caret_to_end(self)
	
	character_limit_label.text = str(description.length()) + "/" + str(character_limit)
	pass # Replace with function body.


func move_caret_to_end(text_edit_node: TextEdit):
	# Get the total number of lines in the TextEdit
	var total_lines = text_edit_node.get_line_count()
	# The last line index is total_lines - 1 (since lines are 0-indexed)
	var last_line_index = total_lines - 1
	# Get the text of the last line to find its length
	var last_line_text = text_edit_node.get_line(last_line_index)
	var end_of_line_column = last_line_text.length()
	# Set the caret position to the end of the last line
	text_edit_node.set_caret_line(last_line_index)
	text_edit_node.set_caret_column(end_of_line_column)

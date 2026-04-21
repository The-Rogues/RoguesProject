extends RichTextLabel
class_name DialogueText

signal finished_dialogue

@export var dialogue_text_timer: Timer
var changed_dialogue: bool = false


func _ready() -> void:
	dialogue_text_timer.timeout.connect(_on_timer_timeout)


func _on_timer_timeout() -> void:
	if not changed_dialogue:
		return
	
	if visible_characters < get_total_character_count():
		visible_characters += 1
		dialogue_text_timer.start()
	else:
		changed_dialogue = false
		finished_dialogue.emit()


func say(_text: String):
	text = _text
	visible_characters = 0
	changed_dialogue = true
	dialogue_text_timer.start()

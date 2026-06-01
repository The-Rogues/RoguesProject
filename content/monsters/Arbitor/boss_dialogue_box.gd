#author: andy g
extends PanelContainer
class_name BossDialogueBox

@onready var speaker_label: Label = $VBoxContainer/SpeakerLabel
@onready var dialogue_text: RichTextLabel = $VBoxContainer/RichTextLabel

var typing_speed: float = 0.06


func _ready():
	visible = false


func start_dialogue(speaker:String, new_lines:Array[String]) -> void:
	visible = true
	speaker_label.text = speaker
	
	if new_lines.is_empty():
		return
	
	await _type_line(new_lines[0])
	
	await get_tree().create_timer(3.0).timeout
	
	visible = false


func _type_line(text:String) -> void:
	dialogue_text.text = ""
	
	for character in text:
		dialogue_text.text += character
		await get_tree().create_timer(typing_speed).timeout

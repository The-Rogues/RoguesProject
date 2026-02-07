extends PanelContainer
class_name DeckViewerUI

@onready var flow_container: FlowContainer = $VBoxContainer/MarginContainer/ScrollContainer/FlowContainer
const CARD_UI = preload("res://CardSystem/Scenes/card_ui.tscn")
@export var button:Button
signal opened

func _initialize(card_datas:Array[CardData]):
	
	for child in flow_container.get_children():
		child.queue_free()	
	
	for card in card_datas:
		var new_card_ui = CARD_UI.instantiate()
		flow_container.add_child(new_card_ui)
		new_card_ui.set_card_data(card)
		
	
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	visible = false
	button.button_up.connect(_on_button_up)

	

func _on_button_up():
	opened.emit()
	visible = true
	



func _on_button_button_up() -> void:
	visible = false
	

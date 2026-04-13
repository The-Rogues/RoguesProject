extends Control
class_name CardPicker


const CARD = preload("res://card_system/card.tscn")
@onready var card_container: HBoxContainer = $CardPanel/CardContainer


func initialize(cards:Array[CardData]):
	for child in card_container.get_children():
		child.queue_free()
	await get_tree().process_frame
	
	for data in cards:
		var card:Card = CARD.instantiate()
		card_container.add_child(card)
		card.initialize(CardInstance.new(data))
		card.interaction_mode = true
		card.clicked.connect(_on_card_chosen)
		


func _on_card_chosen(card:Card):
	var run = GlobalSessionManager.run_progress
	
	if run:
		run.player_data.add_card(card.instance.data)
	
	visible = false


func _on_cancel_button_up() -> void:
	visible = false
	pass # Replace with function body.

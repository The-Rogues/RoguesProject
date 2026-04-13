extends Control

signal confirmed_remove_card

@onready var card: Card = $Card


func set_card_to_remove(_card:Card):
	card.initialize(_card.instance)


func _on_no_button_up() -> void:
	visible = false


func _on_yes_button_up() -> void:
	var run = GlobalSessionManager.run_progress
	
	if run:
		run.player_data.remove_card(card.instance.data)
	
	visible = false
	confirmed_remove_card.emit()

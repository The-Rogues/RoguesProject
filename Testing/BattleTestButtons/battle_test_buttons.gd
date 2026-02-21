extends PanelContainer
class_name BattleTestButtons


@export var battle_manager:BattleManager
@onready var options: VBoxContainer = $MarginContainer/HBoxContainer/Options


func _on_label_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.button_index == 0 and event.is_pressed():
			options.visible = !options.visible
	pass # Replace with function body.


func _on_win_button_up() -> void:
	if not battle_manager:
		return
	
	for enemy in battle_manager.living_enemies:
		enemy.kill()
	pass # Replace with function body.



func _on_damage_player_pressed() -> void:
	if not battle_manager:
		return
	
	battle_manager.player_entity.take_damage(20)
	pass # Replace with function body.


func _on_damage_enemy_button_up() -> void:
	if not battle_manager:
		return
	
	battle_manager.living_enemies.pick_random().take_damage(20)
	pass # Replace with function body.


func _on_add_card_button_up() -> void:
	if not battle_manager:
		return
	
	var deck:CardDeck = load("res://CardSystem/Decks/starting_card_deck.tres")
	var card_data = deck.draw_card()
	battle_manager.player_card_hand.draw_card(card_data)
	battle_manager.card_drawn.emit(card_data)
	pass # Replace with function body.

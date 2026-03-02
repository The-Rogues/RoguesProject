extends PanelContainer
class_name BattleTestButtons


@export var battle_manager:BattleManager
@onready var options: VBoxContainer = $MarginContainer/HBoxContainer/Options


func _on_label_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.is_pressed():
			options.visible = !options.visible
	pass # Replace with function body.


func _on_win_button_up() -> void:
	if not battle_manager:
		return
	var _size = battle_manager.enemies.size()
	for i in range(0, _size):
		if i > 0:
			battle_manager.enemies[i - 1].kill()
		else:
			battle_manager.enemies[i].kill()
	pass # Replace with function body.



func _on_damage_player_pressed() -> void:
	if not battle_manager:
		return
	
	battle_manager.player_entity.take_damage(20)
	pass # Replace with function body.


func _on_damage_enemy_button_up() -> void:
	if not battle_manager:
		return
	
	battle_manager.enemies.pick_random().take_damage(20)
	pass # Replace with function body.


func _on_add_card_button_up() -> void:
	if not battle_manager:
		return
	
	var deck:CardDeck = load("res://CardSystem/Decks/starting_card_deck.tres")
	var card_data = deck.draw_card()
	battle_manager.player_card_hand.draw_card(card_data)
	battle_manager.card_drawn.emit(card_data)
	pass # Replace with function body.


func _on_add_gold_button_up() -> void:
	GlobalSessionManager.increase_gold(250)
	pass # Replace with function body.


func _on_draw_card_button_up() -> void:
	var card = battle_manager.draw_pile.draw_card()
	if card:
		battle_manager.player_card_hand.draw_card(card)
	pass # Replace with function body.

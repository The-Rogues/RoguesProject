extends PanelContainer
class_name BattleTestButtons


@export var battle_manager:BattleFlowManager
@onready var options: VBoxContainer = $MarginContainer/HBoxContainer/Options
@onready var add_item_menu: PanelContainer = $MarginContainer/HBoxContainer/Options/ItemMenu/AddItemMenu


func _on_label_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.is_pressed():
			options.visible = !options.visible
	pass # Replace with function body.


func _on_win_button_up() -> void:
	if not battle_manager:
		return
	
	while !battle_manager.enemies.is_empty():
		battle_manager.enemies[0].health.kill()
	
	pass # Replace with function body.



func _on_damage_player_pressed() -> void:
	if not battle_manager:
		return
	
	battle_manager.player.take_damage(20)
	pass # Replace with function body.


func _on_damage_enemy_button_up() -> void:
	if not battle_manager:
		return
	
	battle_manager.enemies.pick_random().take_damage(20)
	pass # Replace with function body.


func _on_add_gold_button_up() -> void:
	GlobalSessionManager.run_progress.player_data.set_gold(
		GlobalSessionManager.run_progress.player_data.gold + 10
	)
	pass # Replace with function body.


func _on_draw_card_button_up() -> void:
	if not battle_manager:
		return
	
	battle_manager.player.cards.draw_cards(1)
	pass # Replace with function body.


func _on_item_menu_button_up() -> void:
	add_item_menu.visible = !add_item_menu.visible
	pass # Replace with function body.

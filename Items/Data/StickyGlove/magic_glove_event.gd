extends BattleTurnEvent
class_name MagicGloveEvent

var sticky_card:CardData = null

func initialize(
		new_battle_instance:BattleManager, 
		user:BattleEntity = null
) -> void:
	super(new_battle_instance, user)
	new_battle_instance.new_turn_started.connect(_on_new_turn_started)
	new_battle_instance.battle_card_manager.played_card.connect(_on_card_played)


func _on_new_turn_started():
	sticky_card = null


func _on_card_played(card:CardData):
	if sticky_card == null:
		sticky_card = card
		battle_instance.battle_card_manager.discard_pile.remove_card(card)
		battle_instance.battle_card_manager.draw_pile.add_card(card, true)

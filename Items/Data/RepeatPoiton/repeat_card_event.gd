extends BattleTurnEvent
class_name RepeatCardEvent

var stack:int = 1

func initialize(
		new_battle_instance:BattleManager, 
		user:BattleEntity = null
) -> void:
	super(new_battle_instance, user)
	new_battle_instance.battle_card_manager.played_card.connect(_on_card_played)


func _on_card_played(card:CardData):
	print("repeating")
	for i in range(0, stack):
		battle_instance._execute_battle_move(card.move, battle_instance.player_entity)
	
	cleanup()
	event_ended.emit(self)


func on_stack():
	stack += 1


func cleanup():
	if battle_instance and battle_instance.battle_card_manager:
		if battle_instance.battle_card_manager.played_card.is_connected(_on_card_played):
			battle_instance.battle_card_manager.played_card.disconnect(_on_card_played)

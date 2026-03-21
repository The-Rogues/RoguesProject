extends BattleTurnEvent
class_name RepeatCardEvent

var stack:int = 1

func initialize(
		new_battle_instance:BattleManager, 
		user:BattleEntity = null
) -> void:
	super(new_battle_instance, user)
	print("repeat next card")
	new_battle_instance.battle_card_manager.played_card.connect(_on_card_played)


func _on_card_played(card:CardData):
	for i in range(0, stack):
		battle_instance._execute_battle_move(card.move, battle_instance.player_entity)
	event_ended.emit(self)


func on_stack():
	stack += 1

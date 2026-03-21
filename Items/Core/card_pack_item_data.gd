extends ItemData
class_name CardPackItemData

@export var card_pool:CardPool
@export_range(1, 99) var draw_count:int

func use_item(_battle_instance:BattleManager = null) -> bool:
	if !_battle_instance:
		return false
	
	var card:CardData = card_pool.get_items(1)[0]
	for i in draw_count:
		GlobalSessionManager.run_progress.card_deck.add_card(card)
		_battle_instance.battle_card_manager.draw_pile.add_card(card)
	
	GlobalSaveManager.save_run(GlobalSessionManager.run_progress)
	return true

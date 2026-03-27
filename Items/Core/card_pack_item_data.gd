extends ItemData
class_name CardPackItemData

@export var card_pool:CardPool
@export_range(1, 99) var draw_count:int
@export var unique:bool = true

func use_item(_battle_instance:BattleManager = null) -> bool:
	if !_battle_instance:
		return false
	
	var cards:Array[CardData] = []
	
	if unique:
		# Get N unique cards
		cards = card_pool.get_unique_items(draw_count)
	else:
		# Get 1 random card, repeat it N times
		var picked:Array[CardData] = card_pool.get_items(1)
		if picked.is_empty():
			return false
		
		var card:CardData = picked[0]
		
		for i in range(draw_count):
			cards.append(card)
	
	# Apply cards
	for card in cards:
		GlobalSessionManager.run_progress.card_deck.add_card(card)
		_battle_instance.battle_card_manager.draw_pile.add_card(card)
	
	GlobalSaveManager.save_run(GlobalSessionManager.run_progress)
	return true

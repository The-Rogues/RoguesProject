extends ItemData
class_name CardPackItemData

@export var card_pool:Array[CardData]
@export_range(1, 99) var draw_count:int
@export var unique:bool = true

func use_item(_player:PlayerEntity = null) -> bool:
	var run := GlobalSessionManager.run_progress
	
	if run == null:
		return false
	
	var cards:Array[CardData] = []
	
	if unique:
		# Get N unique cards
		var shuffle_pool = card_pool.duplicate()
		shuffle_pool.shuffle()
		for i in range(0, draw_count):
			cards.append(shuffle_pool[i])
	else:
		# Get 1 random card, repeat it N times
		var picked_card = card_pool.pick_random()
		for i in range(0, draw_count):
			cards.append(picked_card)
	
	# Apply cards
	for card in cards:
		run.player_data.add_card(card)
		
		if _player:
			var instance = CardInstance.new(card)
			_player.cards.add_card_to_draw_pile(
					instance)
	
	return true

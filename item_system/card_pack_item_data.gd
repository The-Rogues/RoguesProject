extends ItemData
class_name CardPackItemData

@export var card_pool:Array[CardData]
@export_range(1, 99) var draw_count:int


func use_item(_player:PlayerEntity = null) -> bool:
	var run := GlobalSessionManager.run_progress
	
	if run == null:
		return false
	
	var cards:Array[CardData] = []
	
	var shuffle_pool = card_pool.duplicate()
	shuffle_pool.shuffle()
	for i in range(0, draw_count):
		cards.append(shuffle_pool[i])
	
	GlobalSessionInterface.open_card_picker(cards)
	
	#run.player_data.add_cards(cards)
	
	# Apply cards
	#for card in cards:
	#	if _player:
	#		var instance = CardInstance.new(card)
	#		_player.cards.add_card_to_draw_pile(
	#				instance)
	
	return true
	
func get_random_card(old_card: CardData) -> CardData:
	var possible_cards =card_pool.duplicate()
	possible_cards.erase(old_card)
	possible_cards.shuffle()
	return possible_cards[0]

extends BattleRewardData
class_name CardPackRewardData

@export var card_pack: CardPackItemData
@export var card_count:int = 3

func get_reward() -> bool:
	var cards = card_pack.card_pool.duplicate(true)
	cards.shuffle()
	var chosen_cards:Array[CardData]
	
	for i in range(0, card_count):
		chosen_cards.append(cards.pop_front())
	
	GlobalSessionInterface.open_card_picker(chosen_cards, false)
	return true

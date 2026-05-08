extends BattleRewardData
class_name CardRewardData

@export var card_pool:Array[CardData]
@export var card_count:int = 3
@export var modify_stat_option:bool = true

func get_reward() -> void:
	var cards = card_pool.duplicate(true)
	cards.shuffle()
	var chosen_cards:Array[CardData]
	
	for i in range(0, card_count):
		chosen_cards.append(cards.pop_front())
	
	GlobalSessionInterface.open_card_picker(chosen_cards, modify_stat_option)

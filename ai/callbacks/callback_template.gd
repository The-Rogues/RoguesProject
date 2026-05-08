# --AI Callback Template--
# Author: Insert name here

extends RefCounted
signal generation_error

func create_card(card_data: AiCardData, ai_selection: Array[int]) -> CardData:
	return CardData.new()

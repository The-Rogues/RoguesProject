extends ShopServiceData
class_name CardPackServiceData


@export var card_pool:Array[CardData]


func execute_service():
	var chosen_cards:Array[CardData] = card_pool.duplicate(true)
	chosen_cards.shuffle()
	chosen_cards.resize(3)
	
	GlobalSessionInterface.card_picker.closed.connect(_on_card_picker_closed)
	GlobalSessionInterface.open_card_picker(chosen_cards, false)


func _on_card_picker_closed(picked_card:bool):
	if picked_card:
		service_completed.emit()
	else:
		service_canceled.emit()
	
	GlobalSessionInterface.card_picker.closed.disconnect(_on_card_picker_closed)

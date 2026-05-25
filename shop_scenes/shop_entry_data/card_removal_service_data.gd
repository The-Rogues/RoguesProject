extends ShopServiceData
class_name CardRemovalServiceData


func execute_service():
	GlobalSessionInterface.card_remover.closed.connect(_on_card_remover_closed)
	GlobalSessionInterface.open_card_removal()


func _on_card_remover_closed(removed_card:bool):
	if removed_card:
		service_completed.emit()
	else:
		service_canceled.emit()
	
	GlobalSessionInterface.card_remover.closed.disconnect(_on_card_remover_closed)

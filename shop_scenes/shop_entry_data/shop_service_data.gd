@abstract
extends ShopEntryData
class_name ShopServiceData

signal service_completed
signal service_canceled
@export var service_id:int = 0

@abstract
func execute_service()

@abstract
extends Resource
class_name ItemBehaviour

var item_data:ItemData

func initialize(new_item_data:ItemData):
	item_data = new_item_data.duplicate(true)

@abstract
func execute()

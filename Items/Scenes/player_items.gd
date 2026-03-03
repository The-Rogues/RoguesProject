extends VBoxContainer
class_name PlayerItems

signal item_used(_item:ItemData)

@onready var item_interface: ItemInterface = $ItemInterface
var held_items:Array[ItemData]
var battle:BattleManager


func _ready() -> void:
	if GlobalSessionManager.run_progress:
		_initialize(GlobalSessionManager.run_progress.held_items)


func connect_to_battle(battle_instance:BattleManager):
	battle = battle_instance


func _initialize(items:Array[ItemData]):
	held_items = items.duplicate(true)
	item_interface.initialize(items)
	item_interface.activate_item.connect(_on_use_item)
	GlobalSessionManager.increased_item_capacity.connect(_on_capacity_increased)


func _on_use_item(index:int):
	var item:ItemData = held_items.pop_at(index)
	item.use_item(battle)
	GlobalSessionManager._remove_held_item(item)
	item_interface.update_ui(held_items)
	item_used.emit(item)


func _on_capacity_increased(new_capacity:int):
	item_interface.minimum_item_slot_count = new_capacity
	_initialize(held_items)

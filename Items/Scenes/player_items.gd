extends VBoxContainer
class_name PlayerItems

signal item_used(_item:ItemData)

@onready var use_particles: CPUParticles2D = $UseParticles
@onready var item_interface: ItemInterface = $ItemInterface
var battle:BattleManager = null
var in_battle_scene:bool = false


func _initialize(items:Array[ItemData]):
	item_interface.minimum_item_slot_count = GlobalSessionManager.run_progress.maximum_item_capacity
	item_interface.populate_item_slots(items, in_battle_scene)
	item_interface.use_item.connect(_on_use_item)
	item_interface.discard_item.connect(_on_discard_item)
	GlobalSessionManager.increased_item_capacity.connect(_on_capacity_increased)
	GlobalSessionManager.items_updated.connect(_on_items_updated)


func _on_use_item(index:int, item_slot:ItemSlot):
	var item:ItemData = GlobalSessionManager.run_progress.held_items[index]
	GlobalSessionManager.use_heald_item(index, battle)
	
	use_particles.global_position = item_slot.global_position
	use_particles.emitting = true
	item_interface.populate_item_slots(GlobalSessionManager.run_progress.held_items, true)
	item_used.emit(item)


func _on_discard_item(index:int, item_slot:ItemSlot):
	var item:ItemData = GlobalSessionManager.run_progress.held_items[index]
	use_particles.global_position = item_slot.global_position
	use_particles.emitting = true
	GlobalSessionManager._remove_held_item(item)
	item_interface.update_ui(GlobalSessionManager.run_progress.held_items)


func _on_capacity_increased(new_capacity:int):
	item_interface.minimum_item_slot_count = new_capacity
	item_interface.add_slot()
	#item_interface.initialize(held_items)


func _on_items_updated(items:Array[ItemData]):
	item_interface.populate_item_slots(items)

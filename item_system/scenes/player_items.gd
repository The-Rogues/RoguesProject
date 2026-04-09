extends VBoxContainer
class_name PlayerItems

signal item_used(_item:ItemData)

@onready var use_particles: CPUParticles2D = $UseParticles
@onready var item_interface: ItemInterface = $ItemInterface
var battle:BattleScene = null
var in_battle_scene:bool = false


func initialize():
	var run := GlobalSessionManager.run_progress
	
	if run:
		item_interface.minimum_item_slot_count = run.player_data.item_capacity
		item_interface.populate_item_slots(run.player_data.items)
		
		item_interface.use_item.connect(_on_use_item)
		item_interface.discard_item.connect(_on_discard_item)
		
		run.player_data.item_capacity_updated.connect(_on_item_capacity_updated)
		run.player_data.items_updated.connect(_on_items_updated)


func _on_use_item(index:int, item_slot:ItemSlot):
	var run := GlobalSessionManager.run_progress
	
	if run:
		var item:ItemData = run.player_data.items[index]
		var player:PlayerEntity = null
		
		if get_tree().current_scene is BattleScene:
			var battle_scene = get_tree().current_scene
			player = battle_scene.player
		
		if item.use_item(player):
			_spawn_item_particles(item_slot)
			item_used.emit(item)
			run.player_data.remove_item(item)


func _spawn_item_particles(item_slot:ItemSlot):
	var particle_position = Vector2(
		item_slot.global_position.x + 21,
		item_slot.global_position.y + 21
	)
	use_particles.global_position = particle_position
	use_particles.emitting = true


func _on_discard_item(index:int, item_slot:ItemSlot):
	var player = GlobalSessionManager.run_progress.player_data
	var item:ItemData = player.items[index]
	_spawn_item_particles(item_slot)
	player.remove_item(item)
	#item_interface.populate_item_slots(GlobalSessionManager.run_progress.held_items)


func _on_item_capacity_updated(current:int):
	item_interface.minimum_item_slot_count = current
	item_interface.add_slot()


func _on_items_updated(items:Array[ItemData]):
	item_interface.populate_item_slots(items, true)

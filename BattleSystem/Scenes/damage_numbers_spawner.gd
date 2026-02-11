extends Node2D

const POP_TEXT = preload("res://GeneralAssets/UI/PopNumbers/pop_numbers.tscn")
@export var entity:Entity

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if entity:
		entity.updated_entity_data.connect(_on_entity_data_changed)
	pass # Replace with function body.

func _on_entity_data_changed():
	if entity == null: return
	if entity.damaged.is_connected(_on_entity_damaged): entity.damaged.disconnect(_on_entity_damaged)
	entity.damaged.connect(_on_entity_damaged)
	if entity.healed.is_connected(_on_entity_healed): entity.healed.disconnect(_on_entity_healed)
	entity.healed.connect(_on_entity_healed)

func _on_entity_damaged(amount:int):
	var new_pop_text = POP_TEXT.instantiate()
	add_child(new_pop_text)
	
	if amount == 0:
		new_pop_text.initialize("0", Color.DARK_SLATE_GRAY)
	else:
		new_pop_text.initialize("-" + str(amount), Color.CRIMSON)
	pass

func _on_entity_healed(amount:int):
	var new_pop_text = POP_TEXT.instantiate()
	add_child(new_pop_text)
	
	new_pop_text.initialize("+" + str(amount), Color.SEA_GREEN)
	pass

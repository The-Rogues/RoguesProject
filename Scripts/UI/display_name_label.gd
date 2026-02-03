# Author: Fabian
# Updates label text to entity name when entity data is loaded
extends Label

@export var battle_entity:Entity
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if battle_entity:
		battle_entity.updated_entity_data.connect(_on_entity_data_changed)

func _on_entity_data_changed():
	text = battle_entity.entity_data.name

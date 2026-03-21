extends Node2D
class_name BattlePosition
## Represents a static position a [BattleEntity] can be moved towards in battles.
##
## Battle positions can have objects infront of them and the position itself
## can have a effect when stood on or exited. Both affect the entity standing
## on the position so the player can be enticed or avoid positions throughout
## a battle. BattlePositions will act as normal if they have no objects or 
## effects assigned. The ideal implementation of a [BattlePosition] is for it
## to be stored in a serialized array as part of a battle position management
## script

signal object_removed(object:ObjectEntity)

@onready var object_slot: Node2D = $ObjectSlot
var object:ObjectEntity
@onready var effect: PositionEffect = $PositionEffect
var entity:BattleEntity

const OBJECT = preload("res://Entities/Scenes/object_entity.tscn")
const FLOATING_NUMBERS = preload(
		"res://General/UI/DamageNumbers/floating_numbers.tscn"
)

func display_floating_numbers(text:String):
	var new_pop_text = FLOATING_NUMBERS.instantiate()
	add_child(new_pop_text)
	
	new_pop_text.initialize(text, Color.WHITE)


func set_object(object_data:ObjectEntityData):
	if not object_data or object != null:
		return
	
	var object_entity:ObjectEntity = OBJECT.instantiate()	
	object_slot.add_child(object_entity)
	object_entity.initialize(object_data)
	object_entity.global_position = object_slot.global_position
	object = object_entity
	
	object.defeated.connect(remove_object)


func remove_object(object_entity:Entity):
	if object:
		object.queue_free()
		object = null


func set_effect(effect_data:PositionEffectData):
	if !effect.data:
		effect.initialize(effect_data)
		display_floating_numbers(effect_data.name)
	elif effect.data.priority < effect_data.priority:
		effect.initialize(effect_data)
		display_floating_numbers(effect_data.name)
	effect_data.ended.connect(remove_effect)
	
	if entity:
		on_entity_entered(entity)


func remove_effect():
	if effect.data:
		effect.end_effect()
	display_floating_numbers("Effect Over")


func on_entity_entered(battle_entity:BattleEntity):
	if effect.data:
		effect.data.on_entered(battle_entity)
	
	entity = battle_entity
	battle_entity.on_object_carried.connect(_on_entity_grabbed_object)
	if battle_entity.carried_object and object == null:
		set_object(battle_entity.carried_object)
		battle_entity.drop_object()


func on_entity_exited(battle_entity:BattleEntity):
	if effect.data:
		effect.data.on_exited(battle_entity)
	
	battle_entity.on_object_carried.disconnect(_on_entity_grabbed_object)
	entity  = null


func _on_entity_grabbed_object():
	if object == null:
		set_object(entity.carried_object)
		entity.drop_object()


func start_turn():
	if effect.data and entity:
		effect.data.on_turn_started(entity)
	
	if object:
		object._on_new_turn_started()
	elif entity and entity.carried_object:
		set_object(entity.carried_object)

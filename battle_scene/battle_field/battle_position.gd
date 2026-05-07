extends Node2D
class_name BattlePosition
## A position the Player can stand on and move towards in battles. Can have
## objects and position buffs and debuffs. 

signal object_placed(object:ObjectEntity)
signal object_state_updated
signal effect_state_updated

@onready var object_position: Node2D = $ObjectPosition
@onready var effect_position: Node2D = $EffectPosition
@onready var floating_text: FloatingTextSpawner = $FloatingText

var _effect:PositionEffect = null
var _object:ObjectEntity = null

const Object_Scene = preload("res://battle_scene/entities/object/object_entity.tscn")
const Position_Effect = preload("res://battle_scene/battle_field/position_effects/position_effect.tscn")

func has_object() -> bool: return _object != null
func get_object() -> ObjectEntity: return _object
func has_effect() -> bool: return _effect != null
func get_effect() -> PositionEffect: return _effect

## Attempts to place _object in position. Returns True if succesful
func place_object(data:ObjectData) -> void:
	if not data or _object != null:
		return
	
	var object_entity:ObjectEntity = Object_Scene.instantiate()	
	object_position.add_child(object_entity)
	
	object_entity.global_position = object_position.global_position
	object_entity.initialize(data)
	_object = object_entity
	
	#_object.health.died.connect(remove_object)
	_object.health.died.connect(_on_object_died)
	object_entity.on_placed()
	object_state_updated.emit()
	#floating_text.create("Placed " + data.name)
	object_state_updated.emit()
	object_placed.emit(object_entity)


func remove_object():
	if _object:
		floating_text.create("Destroyed " + _object.data.name)
		_object.queue_free()
		_object = null
		object_state_updated.emit()


func add_position_effect(data:PositionEffectConfig) -> void:
	if !data and _effect != null:
		return
	
	var effect:PositionEffect = Position_Effect.instantiate()
	effect_position.add_child(effect)
	effect.global_position = effect_position.global_position
	
	effect.initialize(data)
	effect.effect_ended.connect(remove_position_effect)
	effect_state_updated.emit()
	floating_text.create(
		data.behaviour.get_effect_name(), 
		data.display.floor_color
	)
	
	_effect = effect
	
	effect_state_updated.emit()


func remove_position_effect() -> void:
	if _effect:
		floating_text.create("Effect Over")
		_effect.queue_free()
		_effect = null
		effect_state_updated.emit()


func on_player_entered(player:PlayerEntity):
	if _effect:
		_effect.on_player_entered(player)
		effect_state_updated.connect(
				player.movement_controller.position_state_updated)
	if _object:
		_object.on_player_entered()
		_object.health.died.connect(player.place_object)


func on_player_exited(player:PlayerEntity):
	if _effect:
		_effect.on_player_exited(player)
		effect_state_updated.connect(
				player.movement_controller.position_state_updated)
	if _object:
		_object.on_player_exited()
		_object.health.died.disconnect(player.place_object)


func enter_turn(turn_count:int):
	decay_effect()
	
	if _object:
		_object.enter_turn(turn_count)


func decay_effect():
	if _effect:
		_effect.duration -= 1
		
		if _effect.duration == 0:
			remove_position_effect()
			
func _on_object_died():
	if _object == null:
		return
	
	floating_text.create("Destroyed " + _object.data.name)
	
	await _object.on_destroyed()
	
	# THEN remove safely
	_object.queue_free()
	_object = null
	object_state_updated.emit()
	
	# small delay to stabilize
	await get_tree().create_timer(0.05).timeout

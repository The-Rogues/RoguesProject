@abstract
extends Node2D
class_name AbstractEntity

var attacker = null
var last_attacked = null
@export var health:Health
@export var projectile_launcher:ProjectileLauncher
signal turn_entered
signal attacked_entity(entity:AbstractEntity)

@abstract
func take_damage(amount:int, _attacker = null)


@abstract
func on_destroyed()


@abstract
func enter_turn(turn_count:int)


func set_last_attacked_entity(entity:AbstractEntity):
	last_attacked = entity
	attacked_entity.emit(entity)

@abstract
extends Node2D
class_name AbstractEntity

signal queue_actions(actions)

var attacker = null
@export var health:Health


@abstract
func take_damage(amount:int, _attacker = null)


@abstract
func on_destroyed()


@abstract
func on_turn_entered()

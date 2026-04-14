@abstract
extends Node2D
class_name AbstractEntity

var attacker = null
@export var health:Health
@export var projectile_launcher:ProjectileLauncher


@abstract
func take_damage(amount:int, _attacker = null)


@abstract
func on_destroyed()


@abstract
func enter_turn(turn_count:int)

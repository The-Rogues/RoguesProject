extends StatusEffectBehaviour
class_name ResloveEffect

var instance_ref: ActiveStatusEffect = null

func on_stack(
	instance:ActiveStatusEffect, 
	_other:ActiveStatusEffect = null,
	_affected: AbstractCreature = null
) -> void:
	instance.stack += 1
	instance.duration = -1

func get_status_name() -> String:
	return "Resolve"

func get_description(_instance:ActiveStatusEffect) -> String:
	return "On Enemy Death: Gains [color=orange]strength[/color] equal to resolve."

func get_texture() -> Texture2D:
	return load("res://content/monsters/ice_warrior/resolve/resolve_icon.tres")

func on_apply(_creature:AbstractCreature, _instance:ActiveStatusEffect) -> void:
	pass


func on_remove(_creature:AbstractCreature, _instance:ActiveStatusEffect) -> void:
	pass


func on_turn(
	_creature:AbstractCreature = null,
	_instance:ActiveStatusEffect = null
) -> void:
	pass


func modify_attack_damage(damage:int, _instance:ActiveStatusEffect) -> int:
	return damage


func modify_incoming_damage(damage:int, _instance:ActiveStatusEffect) -> int:
	return damage


func on_attacked(_attacker:AbstractEntity, _instance:ActiveStatusEffect):
	pass

func on_damaged(_attacker: AbstractEntity, _damaged_entity: AbstractEntity, _instance: ActiveStatusEffect):
	pass

func can_execute_action(
	_action:Action, 
	_instance:ActiveStatusEffect = null
) -> bool:
	return true


func on_card_played(
		_instance:ActiveStatusEffect, 
		_card:CardInstance, 
		_resolver:ActionResolver):
	pass


func on_projectile_fired(
		_projectile:Projectile,
		_source:AbstractCreature,
		_instance:ActiveStatusEffect = null,
):
	pass

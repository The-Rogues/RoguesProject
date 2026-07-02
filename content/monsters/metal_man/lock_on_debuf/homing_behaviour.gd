extends StatusEffectBehaviour
class_name LockOnStatusEffectBehaviour

func on_stack(
	instance:ActiveStatusEffect, 
	_other:ActiveStatusEffect = null,
	_affected: AbstractCreature = null
) -> void:
	instance.stack += _other.stack

func get_status_name() -> String:
	return "Homing"

func get_description(_instance:ActiveStatusEffect) -> String:
	return "On turn start, a strike position is created under the player. Missiles deal damage equal to stack."

func get_texture() -> Texture2D:
	return load("res://content/monsters/metal_man/lock_on_debuf/homing_icon.tres")

func on_turn(
	_creature:AbstractCreature = null,
	_instance:ActiveStatusEffect = null
) -> void:
	if _creature is PlayerEntity:
		var position: PositionEffectConfig = load("res://content/monsters/metal_man/lock_on_debuf/strike_position_config.tres")
		position.stack = _instance.stack
		_creature.battle_position.add_position_effect(position)


func modify_attack_damage(damage:int, _instance:ActiveStatusEffect) -> int:
	return damage


func modify_incoming_damage(damage:int, _instance:ActiveStatusEffect) -> int:
	return damage


func on_attacked(_attacker, _instance:ActiveStatusEffect):
	pass


func on_damaged(_attacker, _damaged_entity: AbstractEntity, _instance: ActiveStatusEffect):
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

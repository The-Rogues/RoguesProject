extends Node
class_name StatusEffectController

signal effect_added(instance:ActiveStatusEffect)
signal effect_removed(instance:ActiveStatusEffect)
signal effect_changed(instance:ActiveStatusEffect)


@export var affected_creature:AbstractCreature
var active_effects:Array[ActiveStatusEffect]


func get_effect(effect_behaviour:Script) -> ActiveStatusEffect:
	for instance in active_effects:
		if instance.effect.get_script() == effect_behaviour:
			return instance
	
	return null


func add_effect(
	effect:StatusEffectBehaviour, 
	duration:int = -1, 
	stack:int = -1
) -> void:
	# Checking if effect already applied
	var new_instance := ActiveStatusEffect.new(effect, duration, stack)
	var existing_instance:ActiveStatusEffect = get_effect(effect.get_script())
	if existing_instance:
		existing_instance.effect.on_stack(
			existing_instance,
			new_instance
		)
		effect_changed.emit(existing_instance)
	else:
		active_effects.append(new_instance)
		new_instance.effect.on_apply(
			affected_creature,
			new_instance
		)
		
		effect_added.emit(new_instance)


## Removes instance with status effect behaviour. Returns True if removal occured.
func remove_effect(effect_behaviour:Script) -> bool:
	var existing_effect := get_effect(effect_behaviour)
	
	if existing_effect:
		effect_removed.emit(existing_effect)
		active_effects.erase(existing_effect)
		return true
	else:
		return false


func apply_attack_damage_effects(damage:int) -> int:
	var final_damage:int = damage
	
	for instance in active_effects:
		final_damage = instance.effect.modify_attack_damage(
			damage,
			instance
		)
	
	return final_damage


func apply_incoming_damage_effects(damage:int) -> int:
	var final_damage:int = damage
	
	for instance in active_effects:
		final_damage = instance.effect.modify_incoming_damage(
			damage,
			instance
		)
	
	return final_damage


func on_entered_turn() -> void:
	for instance in active_effects:
		instance.effect.on_turn_entered(affected_creature)


func decay_status_effects():
	for instance in active_effects:
		instance.duration -= 1
		
		if instance.duration == 0:
			remove_effect(instance.effect.get_script())
		
		effect_changed.emit(instance)

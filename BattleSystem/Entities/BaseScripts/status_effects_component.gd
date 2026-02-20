extends RefCounted
class_name StatusEffectsComponent
## Status effects manager specialized for the Entity System and battle system
## of this project.
##
## Handles applying, removal, and instantiating icons for inflicted status
## effects on [BattleEntity]. Satus Effects can modify and return processed
## damage from attacks and perform operations on the entity instance and 
## battle manager. Status effects should be connected to a turn tracking signal
## to allow for decay. 

signal status_condition_added
signal status_condition_removed

var entity_instance:BattleEntity
var stutus_display: HBoxContainer
const STATUS_EFFECT_UI = preload("res://BattleSystem/StatusEffects/status_effect_icon.tscn")
var status_effects: Array[StatusEffect] = []


func initialize(
	entity:BattleEntity,
	status_parent:HBoxContainer
) -> void:
	entity_instance = entity
	stutus_display = status_parent


func add_status(effect: StatusEffectData, duration: int = 1, stacks: int = 1) -> void:
	for instance in status_effects:
		if instance.effect == effect:
			if effect.is_stackable:
				instance.stack_count += stacks
				instance.duration += 1
				#instance.duration = max(instance.duration, duration)
			
			for status_icon in stutus_display.get_children():
				status_icon.update_ui()
			return
	var instance = StatusEffect.new(effect, duration, stacks)
	status_effects.append(instance)
	effect.on_apply(entity_instance, instance)
	var icon = STATUS_EFFECT_UI.instantiate() as StatusEffectIcon
	stutus_display.add_child(icon)
	icon.initialize(instance)
	icon.update_ui()
	status_condition_added.emit()


func remove_status(instance: StatusEffect) -> bool:
	instance.effect.on_remove(entity_instance, instance)
	status_effects.erase(instance)
	
	for child in stutus_display.get_children():
		if child.instance == instance:
			child.queue_free()
			status_condition_removed.emit()
			return true
	return false


func has_status(status_id:String) -> bool:
	for instance in status_effects:
		if instance.effect.id == status_id:
			return true
	return false


func find_and_remove_status(status_id:String) -> bool:
	for instance in status_effects:
		if instance.effect.id == status_id:
			remove_status(instance)
			return true
	return false


func apply_attack_effects(base_damage: int) -> int:
	var amount:int = base_damage
	for instance in status_effects:
		amount = instance.effect.modify_outgoing_damage(amount, instance)
	return amount


func apply_damage_effects(base_damage: int) -> int:
	var amount:int = base_damage
	for instance in status_effects:
		amount = instance.effect.modify_incoming_damage(amount, instance)
	return amount


func decay_status_effects() -> void:
	for instance in status_effects.duplicate():
		instance.effect.on_turn_start(entity_instance, instance)
		instance.duration -= 1
		if instance.duration <= 0:
			remove_status(instance)
	for status_icon in stutus_display.get_children():
		status_icon.update_ui()

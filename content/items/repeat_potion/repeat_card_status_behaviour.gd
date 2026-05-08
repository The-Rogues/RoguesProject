extends StatusEffectBehaviour
class_name RepeatCardStatusEffect

var owner

func on_stack(
	instance:ActiveStatusEffect, 
	_other:ActiveStatusEffect = null,
	_affected: AbstractCreature = null
) -> void:
	instance.stack += 1


func on_apply(_creature:AbstractCreature, _instance:ActiveStatusEffect) -> void:
	owner = _creature


func get_status_name() -> String:
	return "Repeat Card"


func get_description(_instance:ActiveStatusEffect) -> String:
	return "Next Card is played twice"


func get_texture() -> Texture2D:
	return load("res://content/items/repeat_potion/repeat_potion_texture.tres")


func on_card_played(
		_instance:ActiveStatusEffect, 
		_card:CardInstance, 
		_resolver:ActionResolver):
	
	for i in range(0, _instance.stack):
		_resolver.process_actions(_card.data.play_actions, owner)
	
	effect_ended.emit()

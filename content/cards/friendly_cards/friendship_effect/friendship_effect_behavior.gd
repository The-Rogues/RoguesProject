extends StatusEffectBehaviour
class_name FriendshipEffect


func on_stack(
	instance:ActiveStatusEffect, 
	_other:ActiveStatusEffect = null,
	_affected: AbstractCreature = null
) -> void:
	instance.stack += _other.stack
	instance.duration = -1


func get_status_name() -> String:
	return "Friendship"


func get_description(_instance:ActiveStatusEffect) -> String:
	var calc_threshold: int = 0
	if _instance.stack * 0.03 > 1.0:
		calc_threshold = 100
	else:
		calc_threshold = (_instance.stack * 0.03) * 100
	return "When this enemy's HP falls bellow [color=red]" + str(calc_threshold) + "[/color] percent, they immediatley flee combat. Increases by [color=#43A047]3[/color] percent for each stack of [color=orange]friendship[/color]."

func get_texture() -> Texture2D:
	return load("res://content/cards/friendly_cards/friendship_effect/friendship_icon.tres")

func on_apply(_creature:AbstractCreature, _instance:ActiveStatusEffect) -> void:
	if ((_creature.health.value * 1.0) / _creature.health.max_value) <= (_instance.stack * 0.03):
		_creature.health.kill()

func on_damaged(_attacker: AbstractEntity, _damaged_entity: AbstractEntity, _instance: ActiveStatusEffect):
	if ((_damaged_entity.health.value * 1.0) / _damaged_entity.health.max_value) <= (_instance.stack * 0.03):
		_damaged_entity.health.kill()

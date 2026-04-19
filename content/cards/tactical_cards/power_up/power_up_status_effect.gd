extends StatusEffectBehaviour
class_name PowerUpStatusEffect


func on_stack(
	instance:ActiveStatusEffect, 
	_other:ActiveStatusEffect = null
) -> void:
	instance.stack += _other.stack


func get_status_name() -> String:
	return "Power-up"


func get_description(instance:ActiveStatusEffect) -> String:
	return "Increase Projectile Damage by " + str(instance.stack) + " once." 


func get_texture() -> Texture2D:
	return load("res://content/cards/tactical_cards/power_up/power_up_texture.tres")


func on_projectile_fired(
		_projectile:Projectile,
		_source:AbstractCreature,
		_instance:ActiveStatusEffect = null,
):
	_projectile.damage += _instance.stack
	effect_ended.emit(self)

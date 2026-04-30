extends StatusEffectBehaviour
class_name GemEffect


func on_stack(
	instance:ActiveStatusEffect, 
	_other:ActiveStatusEffect = null
) -> void:
	var run = GlobalSessionManager.run_progress
	if run:
		for i in range(0, _other.stack):
			if randf() < 0.25:
				run.player_data.set_gold(run.player_data.gold + 1)
	instance.stack += _other.stack
	instance.duration = -1


func get_status_name() -> String:
	return "Gem"


func get_description(_instance:ActiveStatusEffect) -> String:
	return "You have " + str(_instance.stack) + " gems. Whenever you gain a gem, you have a 25 percent chance to gain a gold too."


func get_texture() -> Texture2D:
	return load("res://content/cards/greedy_cards/assets/gem.png")

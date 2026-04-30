extends MiniEventResult
class_name ChangeHealthEventResult

@export var change_reason:String = ""
# If >= 0 → modifies max health
# If < 0 → do not change max health
@export var max_health_delta: int = -1

# Positive = heal, Negative = damage
@export var amount: int = 0


func resolve():
	var run = GlobalSessionManager.run_progress
	if not run:
		return
	
	var player = run.player_data
	
	var current_max = player.max_health
	var current_hp = player.current_health
	
	# Handle max health change
	if max_health_delta >= 0:
		current_max += max_health_delta
	
	# Apply heal/damage
	current_hp += amount
	
	# Clamp health
	current_hp = clamp(current_hp, 0, current_max)
	
	player.set_health(current_hp, current_max)


func get_result_text() -> String:
	var parts: Array[String] = []
	
	# Heal or damage text
	if amount > 0:
		parts.append(change_reason + "You recover %d health" % amount)
	elif amount < 0:
		parts.append(change_reason + "You take %d damage" % abs(amount))
	
	# Max health change text
	if max_health_delta > 0:
		parts.append(change_reason + "Your max health increases by %d" % max_health_delta)
	
	if parts.is_empty():
		return "Nothing happened."
	
	return ". ".join(parts) + "."

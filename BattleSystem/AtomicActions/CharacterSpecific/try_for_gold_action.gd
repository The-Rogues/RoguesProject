extends AtomicAction
class_name TryForGoldAction
## AtomicAction that uses RNG to determine if player recieves gold or a
## different [AtomicAction] is queued instead

## Controls the minimum amount of gold the player will receive
@export_range(1, 999)
var minimum_gold: int = 1:
	set(value):
		if value > maximum_gold:
			push_warning("minimum_gold cannot be greater than maximum_gold")
			return # Reject change
		minimum_gold = value
## Controls the maximum amount of gold the player will receive
@export_range(2, 999)
var maximum_gold: int = 2:
	set(value):
		if value < minimum_gold:
			push_warning("maximum_gold cannot be less than minimum_gold")
			return # Reject change
		maximum_gold = value
## Controls how likely the player is to recieve gold with higher values being
## closer to 100%
@export_range(0, 1) var chance:float
## Sets an action to queue if failing to get gold
@export var consequence_action:AtomicAction


func execute(action_context:ActionContext):
	if randf() <= chance:
		var gold_amount:int = randi_range(minimum_gold, maximum_gold)
		GlobalSessionManager.add_gold(gold_amount)
		await action_context.user.get_tree().create_timer(0.15).timeout
	else:
		if !consequence_action:
			return
		action_context.action_queue.enqueue(consequence_action, action_context)

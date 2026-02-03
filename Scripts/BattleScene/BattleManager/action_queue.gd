extends RefCounted
class_name ActionQueue
# Stores and executes actions non-concurrently

signal processed_all_actions

# Helper class that exists
class QueuedAction extends RefCounted:
	var action: AtomicAction
	var battle_info: BattleActionInfo
	func _init(new_action: AtomicAction, new_battle_info: BattleActionInfo):
		action = new_action
		battle_info = new_battle_info
	func execute() -> void:
		await action.execute(battle_info)

var queue: Array[QueuedAction] = []
var processing_action:bool = false

# Adds action and associated info to the queue and tries to execute it
func enqueue(action: AtomicAction, battle_info: BattleActionInfo):
	# Creates new action to be executed soon
	
	queue.append(QueuedAction.new(action, battle_info))
	_check_action_queue()

func _check_action_queue():
	
	if processing_action or queue.is_empty():
		if queue.is_empty():
			processed_all_actions.emit()
		return
	_execute_queued_action()

func _execute_queued_action():
	
	processing_action = true
	
	var queued_action = queue.pop_front()
	if queued_action.action != null:
		
		# Waits until function finishes executing
		await queued_action.execute()
	processing_action = false
	_check_action_queue()

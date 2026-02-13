# ==========================================================
# Author: Fabian 
# Description:
#   Intended to schedules and executes passed atomic actions 
#   and action context from the Battle manager.
#
# ==========================================================

extends RefCounted
class_name ActionQueue

signal processed_all_actions

# Local helper class to store an executable queued action
class QueuedAction extends RefCounted:
	# The action to be performed (damage, heal, move, add card)
	var action: AtomicAction
	var action_context: ActionContext
	# Constructor
	func _init(new_action: AtomicAction, new_action_context: ActionContext):
		action = new_action
		action_context = new_action_context
	
	func execute() -> void:
		await action.execute(action_context)

var queue: Array[QueuedAction] = []
var processing_action:bool = false

# Adds action and associated info to the queue and tries to execute it
func enqueue(action: AtomicAction, action_context: ActionContext):
	# Queues new action to be executed
	queue.append(QueuedAction.new(action, action_context))
	_check_action_queue()

func _check_action_queue():
	if processing_action or queue.is_empty():
		if queue.is_empty():
			processed_all_actions.emit()
		return
	
	#_execute_queued_action()
	_try_start_processing()

func _execute_queued_action():
	processing_action = true
	
	var queued_action = queue.pop_front()
	# In case of a missing action in combat move from
	# developer mistake
	if queued_action.action != null:
		# Waits action finishes executing
		await queued_action.execute()
	
	processing_action = false
	_check_action_queue()

func _try_start_processing() -> void:
	if processing_action:
		return
	if queue.is_empty():
		processed_all_actions.emit()
		return

	processing_action = true
	call_deferred("_process_queue")

func _process_queue() -> void:
	while not queue.is_empty():
		var queued_action: QueuedAction = queue.pop_front() as QueuedAction
		if queued_action != null and queued_action.action != null:
			await queued_action.execute()

	processing_action = false
	processed_all_actions.emit()

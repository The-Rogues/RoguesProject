# ==========================================================
# Author: Fabian 
# Description:
#   Intended to schedules and executes passed atomic actions 
#   and action context from the Battle manager.
#
# ==========================================================

extends RefCounted
class_name ActionQueue

signal action_processed(action:Action)
signal processed_all_actions

var queue: Array[QueuedAction] = []
var processing_action:bool = false

# Adds action and associated info to the queue and tries to execute it
func enqueue(
		action: Action, 
		context: BattleContext,
		user: AbstractEntity,
		recalculate: bool = false
		):
	# Queues new action to be executed
	
	queue.append(QueuedAction.new(action, context, user, recalculate))
	_check_action_queue()


func interrupt_enqueue(
		action: Action, 
		context: BattleContext,
		user: AbstractEntity
):
	# Queues new action to be executed
	queue.push_front(QueuedAction.new(action, context, user))
	_check_action_queue()


func _check_action_queue():
	if processing_action or queue.is_empty():
		if queue.is_empty():
			processed_all_actions.emit()
			print("=== QUEUE EMPTY SAVE - drawn_cards: ", 
				Engine.get_main_loop().current_scene.player.cards.drawn_cards.size() 
				if Engine.get_main_loop().current_scene is BattleScene else "not battle scene")
			_save_after_action()
		return
	
	_execute_queued_action()


func _execute_queued_action():
	processing_action = true
	
	var queued_action = queue.pop_front()
	# In case of a missing action in combat move from
	# developer mistake
	if queued_action.action != null:
		# Waits action finishes executing
		await queued_action.execute()
		action_processed.emit(queued_action.action)
	
	# Fletcher - Recalculate attack targeting if the action is the last in a
	#            user's sequence.
	if queued_action.recalculate_targeting:
		queued_action.context.creature_manager.update_attack_targeting()
		queued_action.context.battle_field.update_preferences(
			queued_action.context.get_player()
		)
	
	processing_action = false
	_check_action_queue()

func _save_after_action() -> void:
	var scene = Engine.get_main_loop().current_scene
	if scene is BattleScene:
		scene.save_battle_state()

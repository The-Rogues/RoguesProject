extends RefCounted
class_name ActionResolver

var action_queue:ActionQueue
var battle_context:BattleContext


func _init(context:BattleContext) -> void:
	battle_context = context
	action_queue = ActionQueue.new()


func resolve_targeting(target_option:int, user:AbstractEntity):
	var resolved_targeting:Array[AbstractEntity]
	
	match target_option:
		0: # Self
			resolved_targeting.append(user)
		1: # Player
			var player := battle_context.creature_manager.player
			
			if user is MonsterEntity:
				var battle_pos := player.movement_controller.find_nearest_object_position_by_role(
					ObjectData.Role.DECOY
				)
				if battle_pos:
					resolved_targeting.append(battle_pos.get_object())
				else:
					if player.battle_position.has_object():
						resolved_targeting.append(player.battle_position.get_object())
					else:
						resolved_targeting.append(player)
			else:
				resolved_targeting.append(player)
		2: # Enemy
			if user is PlayerEntity:
				var player := battle_context.creature_manager.player
				var target:AbstractEntity = null
				if player.battle_position.has_object():
					target = player.battle_position.get_object()
				else:
					target = player.data.personality.choose_enemy_target(
							battle_context.creature_manager.enemies
					)
				
				resolved_targeting.append(target)
			else:
				resolved_targeting.append(
						battle_context.creature_manager.enemies.pick_random())
		3:
			resolved_targeting.append_array(
					battle_context.creature_manager.enemies)
	
	return resolved_targeting


func process_actions(actions:Array[Action], user:AbstractEntity):
	for action in actions:
		if action is TargetedAction:
			action.resolved_targets = resolve_targeting(
					action.target_option,
					user)
		
		if user is AbstractCreature:
			if !user.effects.can_use_action(action):
				continue
		
		action_queue.enqueue(
			action,
			battle_context,
			user
		)

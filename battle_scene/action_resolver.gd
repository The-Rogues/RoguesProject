extends RefCounted
class_name ActionResolver

var action_queue:ActionQueue
var battle_context:BattleContext

func _init(context:BattleContext) -> void:
	battle_context = context
	action_queue = ActionQueue.new()


func resolve_targeting(in_action:TargetedAction, user:AbstractEntity):
	var target_option: int = in_action.target_option
	var resolved_targeting:Array[AbstractEntity]
	
	match target_option:
		0: # Self
			resolved_targeting.append(user)
		1: # Player
			var player := battle_context.creature_manager.player
			
			if user is MonsterEntity:
				var battle_pos := player.movement_controller.find_decoy_position()
				if battle_pos:
					resolved_targeting.append(battle_pos.get_object())
				else:
					resolved_targeting.append(player)
			else:
				resolved_targeting.append(player)
		2: # Enemy
			if user is PlayerEntity:
				var player := battle_context.creature_manager.player
				var target:AbstractEntity = null
				if player.battle_position.has_object() && !in_action.ignore_foreground:
					target = player.battle_position.get_object()
				else:
					
					var filtered_enemies: Array[MonsterEntity]
					if in_action is FilteredTargetedAction:
						filtered_enemies = filter_enemies(in_action)
					else:
						filtered_enemies = battle_context.creature_manager.enemies
					
					target = player.data.personality.choose_enemy_target(
						filtered_enemies,
						player.offensive_trait.weight_value,
						player.defensive_trait.weight_value,
						player.strategic_trait.weight_value
					)
				
				resolved_targeting.append(target)
			else:
				resolved_targeting.append(
						battle_context.creature_manager.enemies.pick_random())
		3:
			var filtered_enemies: Array[AbstractEntity] = []
			var player := battle_context.creature_manager.player
			if player.battle_position.has_object() && !in_action.ignore_foreground:
				filtered_enemies.append(player.battle_position.get_object())
			elif in_action is FilteredTargetedAction:
				filtered_enemies.append_array(
					filter_enemies(in_action)
				)
			else:
				filtered_enemies.append_array(
					battle_context.creature_manager.enemies
				)
			
			resolved_targeting.append_array(
				filtered_enemies
			)
	
	return resolved_targeting

func filter_enemies(in_action: FilteredTargetedAction) -> Array[MonsterEntity]:
	var filtered_enemies: Array[MonsterEntity] = battle_context.creature_manager.enemies.duplicate()
	if in_action.filter_type == FilteredTargetedAction.FilterType.HP_PCT:
		for i in range(filtered_enemies.size() - 1, -1, -1):
			var enemy_pct: float = (filtered_enemies[i].health.value * 1.0) / (filtered_enemies[i].health.max_value * 1.0)
			if in_action.filter_value < enemy_pct:
				filtered_enemies.remove_at(i)
	elif in_action.filter_type == FilteredTargetedAction.FilterType.HP_THRESHOLD:
		for i in range(filtered_enemies.size() - 1, -1, -1):
			if int(in_action.filter_value) < filtered_enemies[i].health.value:
				filtered_enemies.remove_at(i)
	elif in_action.filter_type == FilteredTargetedAction.FilterType.MAX_HP_THRESHOLD:
		for i in range(filtered_enemies.size() - 1, -1, -1):
			if int(in_action.filter_value) < filtered_enemies[i].health.max_value:
				filtered_enemies.remove_at(i)
	elif in_action.filter_type == FilteredTargetedAction.FilterType.MOST_HP:
		var most_hp_value: int = 0
		for i in range(0, filtered_enemies.size()):
			if filtered_enemies[i].health.value > most_hp_value:
				most_hp_value = filtered_enemies[i].health.value
		for i in range(filtered_enemies.size() - 1, -1, -1):
			if filtered_enemies[i].health.value != most_hp_value:
				filtered_enemies.remove_at(i)
	elif in_action.filter_type == FilteredTargetedAction.FilterType.UNDAMAGED:
		for i in range(filtered_enemies.size() - 1, -1, -1):
			if filtered_enemies[i].health.max_value != filtered_enemies[i].health.value:
				filtered_enemies.remove_at(i)
	elif in_action.filter_type == FilteredTargetedAction.FilterType.FRIENDSHIP:
		var friendship_behavior: StatusEffectBehaviour = load("res://content/cards/friendly_cards/friendship_effect/friendship_behavior.tres")
		for i in range(filtered_enemies.size() - 1, -1, -1):
			var has_effect: bool = false
			for j in range(0, filtered_enemies[i].effects.active_effects.size()):
				if filtered_enemies[i].effects.active_effects[j].effect == friendship_behavior:
					has_effect = true
					break
			if !has_effect:
				filtered_enemies.remove_at(i)
	return filtered_enemies

func process_actions(actions:Array[Action], user:AbstractEntity):
	for i in range(0, actions.size()):
		if actions[i] is TargetedAction:
			actions[i].resolved_targets = resolve_targeting(
					actions[i],
					user)
		
		if user is AbstractCreature:
			if !user.effects.can_use_action(actions[i]):
				continue
		
		var recalculate_targeting: bool = true
		if i < (actions.size() - 1):
			recalculate_targeting = false
		if user is ObjectEntity:
			user = null
		action_queue.enqueue(
			actions[i],
			battle_context,
			user,
			recalculate_targeting
		)

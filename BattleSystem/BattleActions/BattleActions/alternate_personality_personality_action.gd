extends BattleAction
class_name AlternatePersonalityAction

@export var personality_trait:TraitData
@export var default_action:BattleAction
@export var alternate_action:BattleAction

func _execute(battle_instance:BattleManager, action_user:BattleEntity):
	var character_data := battle_instance.player_entity.entity_data as CharacterData
	
	if character_data.has_trait(personality_trait):
		battle_instance.action_queue.enqueue(
		alternate_action,
		battle_instance,
		action_user
		)
	else:
		battle_instance.action_queue.enqueue(
				default_action,
				battle_instance,
				action_user
			)

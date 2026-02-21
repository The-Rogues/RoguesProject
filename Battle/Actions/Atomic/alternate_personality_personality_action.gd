extends BattleAction
class_name AlternatePersonalityAction

@export var personality_trait:PersonalityTrait
@export var default_action:BattleAction
@export var alternate_action:BattleAction

func _execute(battle_instance:BattleManager, action_user:BattleEntity):
	if battle_instance.character_personality.has_trait(personality_trait.id):
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

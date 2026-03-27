extends BattleTurnEvent
class_name TherapyPlushEvent


func initialize(
		new_battle_instance:BattleManager, 
		user:BattleEntity = null
) -> void:
	super(new_battle_instance, user)
	new_battle_instance.player_personality = GlobalSessionManager.run_progress.personality_data.duplicate(true)
	new_battle_instance.player_personality.updated_traits.emit(new_battle_instance.player_personality)
	event_ended.emit(self)

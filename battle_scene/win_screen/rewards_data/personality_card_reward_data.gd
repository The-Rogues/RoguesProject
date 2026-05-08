extends BattleRewardData
class_name PersonalityCardRewardData


func get_reward() -> void:
	var run = GlobalSessionManager.run_progress
	var loot_pool:Array[CardData] = []
	if run:
		var personality = run.player_data.personality
		loot_pool.append_array(personality.offensive_trait.card_loot_pool)
		loot_pool.append_array(personality.defensive_trait.card_loot_pool)
		loot_pool.append_array(personality.strategic_trait.card_loot_pool)
		loot_pool.shuffle()
		
		loot_pool.resize(3)
		GlobalSessionInterface.open_card_picker(loot_pool, true)

extends Action
class_name PermaStatModAction

@export var trait_category:PersonalityTrait.TraitCategory
@export_range(-10, 10) var weight:int = 1


func execute(_context:BattleContext = null, _user:AbstractEntity = null):
	var player:PlayerEntity = _context.get_player()
	
	match trait_category:
		PersonalityTrait.TraitCategory.OFFENSIVE:
			GlobalSessionManager.run_progress.player_data.personality.set_trait_weight(
				"OFFENSIVE",
				GlobalSessionManager.run_progress.player_data.personality.offensive_weight + weight
			)
			player.offensive_trait.set_weight(
				player.offensive_trait.weight_value + weight
			)
		PersonalityTrait.TraitCategory.DEFENSIVE:
			GlobalSessionManager.run_progress.player_data.personality.set_trait_weight(
				"DEFENSIVE",
				GlobalSessionManager.run_progress.player_data.personality.defensive_weight + weight
			)
			player.defensive_trait.set_weight(
				player.defensive_trait.weight_value + weight
			)
		PersonalityTrait.TraitCategory.STRATEGIC:
			GlobalSessionManager.run_progress.player_data.personality.set_trait_weight(
				"STRATEGIC",
				GlobalSessionManager.run_progress.player_data.personality.strategic_weight + weight
			)
			player.strategic_trait.set_weight(
				player.strategic_trait.weight_value + weight
			)
	await _context.creature_manager.get_tree().create_timer(0.15).timeout

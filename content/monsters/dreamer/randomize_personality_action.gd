extends Action
class_name RandomizePersonalityAction

func execute(_context:BattleContext = null, _user:AbstractEntity = null):
	var new_traits: Array[int]
	new_traits.append(randi_range(0, 3))
	new_traits.append(randi_range(4, 7))
	new_traits.append(randi_range(8, 11))
	if new_traits.has(0):
		var new_trait: PersonalityTrait = load("res://content/personality_traits/brutish.tres")
		_context.get_player().offensive_trait.set_trait(
			new_trait
		)
		GlobalSessionManager.run_progress.player_data.personality.offensive_trait_override = new_trait
	if new_traits.has(1):
		var new_trait: PersonalityTrait = load("res://content/personality_traits/merciful.tres")
		_context.get_player().offensive_trait.set_trait(
			new_trait
		)
		GlobalSessionManager.run_progress.player_data.personality.offensive_trait_override = new_trait
	if new_traits.has(2):
		var new_trait: PersonalityTrait = load("res://content/personality_traits/vengeful.tres")
		_context.get_player().offensive_trait.set_trait(
			new_trait
		)
		GlobalSessionManager.run_progress.player_data.personality.offensive_trait_override = new_trait
	if new_traits.has(3):
		var new_trait: PersonalityTrait = load("res://content/personality_traits/tactical.tres")
		_context.get_player().offensive_trait.set_trait(
			new_trait
		)
		GlobalSessionManager.run_progress.player_data.personality.offensive_trait_override = new_trait
	if new_traits.has(4):
		var new_trait: PersonalityTrait = load("res://content/personality_traits/stoic.tres")
		_context.get_player().defensive_trait.set_trait(
			new_trait
		)
		GlobalSessionManager.run_progress.player_data.personality.defensive_trait_override = new_trait
	if new_traits.has(5):
		var new_trait: PersonalityTrait = load("res://content/personality_traits/naive.tres")
		_context.get_player().defensive_trait.set_trait(
			new_trait
		)
		GlobalSessionManager.run_progress.player_data.personality.defensive_trait_override = new_trait
	if new_traits.has(6):
		var new_trait: PersonalityTrait = load("res://content/personality_traits/skittish.tres")
		_context.get_player().defensive_trait.set_trait(
			new_trait
		)
		GlobalSessionManager.run_progress.player_data.personality.defensive_trait_override = new_trait
	if new_traits.has(7):
		var new_trait: PersonalityTrait = load("res://content/personality_traits/crafty.tres")
		_context.get_player().defensive_trait.set_trait(
			new_trait
		)
		GlobalSessionManager.run_progress.player_data.personality.defensive_trait_override = new_trait
	if new_traits.has(8):
		var new_trait: PersonalityTrait = load("res://content/personality_traits/friendly.tres")
		_context.get_player().strategic_trait.set_trait(
			new_trait
		)
		GlobalSessionManager.run_progress.player_data.personality.strategic_trait_override = new_trait
	if new_traits.has(9):
		var new_trait: PersonalityTrait = load("res://content/personality_traits/laidback.tres")
		_context.get_player().strategic_trait.set_trait(
			new_trait
		)
		GlobalSessionManager.run_progress.player_data.personality.strategic_trait_override = new_trait
	if new_traits.has(10):
		var new_trait: PersonalityTrait = load("res://content/personality_traits/valorous.tres")
		_context.get_player().strategic_trait.set_trait(
			new_trait
		)
		GlobalSessionManager.run_progress.player_data.personality.strategic_trait_override = new_trait
	if new_traits.has(11):
		var new_trait: PersonalityTrait = load("res://content/personality_traits/greedy.tres")
		_context.get_player().strategic_trait.set_trait(
			new_trait
		)
		GlobalSessionManager.run_progress.player_data.personality.strategic_trait_override = new_trait
	_context.get_player().offensive_trait.set_weight(randi_range(1, 10))
	_context.get_player().defensive_trait.set_weight(randi_range(1, 10))
	_context.get_player().strategic_trait.set_weight(randi_range(1, 10))

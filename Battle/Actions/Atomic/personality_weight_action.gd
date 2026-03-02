extends BattleAction
class_name  PersonalityWeightAction

enum Trait {OFFENSIVE, DEFENSIVE, STRATEGIC}
@export var _trait:Trait
@export var set_to_exact:bool = false
@export var change:int = 0

func _execute(battle_instance:BattleManager, _action_user:BattleEntity = null):
	match _trait:
		Trait.OFFENSIVE:
			battle_instance.player_personality.modify_offense(change, set_to_exact)
		Trait.DEFENSIVE:
			battle_instance.player_personality.modify_defense(change, set_to_exact)
		Trait.STRATEGIC:
			battle_instance.player_personality.modify_strategy(change, set_to_exact)

extends BattleAction
class_name  PersonalityWeightAction

enum Trait {OFFENSIVE, DEFENSIVE, STRATEGIC}
@export var _trait:Trait
@export var set_to_exact:bool = false
@export var change:int = 0

func _execute(battle_instance:BattleManager, action_user:BattleEntity):
	match _trait:
		Trait.OFFENSIVE:
			battle_instance.character_personality.modify_offense(change, set_to_exact)
		Trait.DEFENSIVE:
			battle_instance.character_personality.modify_defense(change, set_to_exact)
		Trait.STRATEGIC:
			battle_instance.character_personality.modify_strategy(change, set_to_exact)

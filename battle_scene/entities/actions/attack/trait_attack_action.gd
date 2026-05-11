extends AttackAction
class_name TraitAttackAction

enum TraitCategory {OFFENSIVE, DEFENSIVE, STRATEGIC}

@export var category: TraitCategory


func execute(_context: BattleContext = null, _user: AbstractEntity = null):
	var _trait = get_trait(_context.get_player())
	
	if _trait == null:
		return
	
	amount = _trait.weight_value
	super(_context, _user)


func get_trait(player: PlayerEntity) -> Trait:
	match category:
		TraitCategory.OFFENSIVE:
			return player.offensive_trait
		TraitCategory.DEFENSIVE:
			return player.defensive_trait
		TraitCategory.STRATEGIC:
			return player.strategic_trait
	
	return null

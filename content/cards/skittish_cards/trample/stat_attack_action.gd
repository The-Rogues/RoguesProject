extends AttackAction
class_name StatAttackAction

enum Category {OFFENSE, DEFENSE, STRATEGY}
@export var trait_category:Category

func execute(_context:BattleContext = null, _user:AbstractEntity = null):
	amount = _get_stat_value(_context)
	
	super(_context, _user)


func _get_stat_value(context:BattleContext):
	match trait_category:
		Category.OFFENSE:
			return context.get_player().offensive_trait.weight_value
		Category.DEFENSE:
			return context.get_player().defensive_trait.weight_value
		Category.STRATEGY:
			return context.get_player().strategic_trait.weight_value
	return 0

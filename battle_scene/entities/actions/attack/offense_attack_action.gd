extends AttackAction
class_name OffenseAttackAction


func execute(_context:BattleContext = null, _user:AbstractEntity = null):
	amount = _context.player.offensive_trait.weight_value
	
	super(_context, _user)

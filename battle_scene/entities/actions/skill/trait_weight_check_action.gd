extends Action
class_name TraitWeightCheckAction


enum TraitCategory {OFFENSIVE, DEFENSIVE, STRATEGIC}
@export var category:TraitCategory
@export_range(1, 10) var threshold:int = 1
@export var lower:bool = false
@export var success_action:Action


func execute(_context:BattleContext = null, _user:AbstractEntity = null):
	var _trait:Trait = get_trait(_context.get_player())
	
	if threshold_met(_trait):
		if success_action is TargetedAction:
			success_action.resolved_targets = _context.resolve_targeting.call(
					success_action, _user)
		
		success_action.execute(_context, _user)


func get_trait(player:PlayerEntity) -> Trait:
	match category:
		TraitCategory.OFFENSIVE:
			return player.offensive_trait
		TraitCategory.DEFENSIVE:
			return player.defensive_trait
		TraitCategory.STRATEGIC:
			return player.strategic_trait
	
	# Impossible
	return null


func threshold_met(_trait:Trait) -> bool:
	if lower:
		return _trait.weight_value <= threshold
	else:
		return _trait.weight_value >= threshold

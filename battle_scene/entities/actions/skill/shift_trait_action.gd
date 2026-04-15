extends Action
class_name ShiftTraitAction

enum OperationType { SET, ADD, SUBTRACT }

@export var operation:OperationType
@export var trait_category:PersonalityTrait.TraitCategory
@export_range(1, 10) var weight:int = 1


func execute(_context:BattleContext = null, _user:AbstractEntity = null):
	var player:PlayerEntity = _context.get_player()
	
	match trait_category:
		PersonalityTrait.TraitCategory.OFFENSIVE:
			player.offensive_trait.set_weight(
				_calculate_weight(player.offensive_trait.weight_value)
			)
		PersonalityTrait.TraitCategory.DEFENSIVE:
			player.defensive_trait.set_weight(
				_calculate_weight(player.defensive_trait.weight_value)
			)
		PersonalityTrait.TraitCategory.STRATEGIC:
			player.strategic_trait.set_weight(
				_calculate_weight(player.strategic_trait.weight_value)
			)
	await _context.creature_manager.get_tree().create_timer(0.15).timeout


func _calculate_weight(current_weight:int) -> int:
	match operation:
		OperationType.SET:
			return weight
		OperationType.ADD:
			return current_weight + weight
		OperationType.SUBTRACT:
			return current_weight - weight
		_:
			return 1

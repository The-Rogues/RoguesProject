@abstract
extends TargetedAction
class_name FilteredTargetedAction

enum FilterType {HP_PCT, HP_THRESHOLD, MAX_HP_THRESHOLD}
@export var filter_type: FilterType

@export var filter_value: float

@abstract
func execute(_context:BattleContext = null, _user:AbstractEntity = null)

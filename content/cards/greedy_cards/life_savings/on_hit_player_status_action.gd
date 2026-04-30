extends Action
class_name OnHitPlayerStatusAction

@export var effect:StatusEffectConfig

func execute(_context:BattleContext = null, _user:AbstractEntity = null):
		_context.get_player().apply_status_effect(effect, true)

extends FilteredTargetedAction
class_name FilteredApplyStatusAction

@export var effect:StatusEffectConfig

func execute(_context:BattleContext = null, _user:AbstractEntity = null):
	var apply_status_action: ApplyStatusAction = ApplyStatusAction.new()
	apply_status_action.effect = effect
	apply_status_action.target_option = target_option
	apply_status_action.ignore_foreground = ignore_foreground
	apply_status_action.resolved_targets = resolved_targets
	await apply_status_action.execute(_context, _user)

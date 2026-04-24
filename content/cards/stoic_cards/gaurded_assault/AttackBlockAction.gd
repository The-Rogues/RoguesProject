extends BlockAction
class_name AttackBlockAction

@export_range(0, 99) var base_damage:int
@export_range(1, 99) var hits:int = 1

func execute(_context:BattleContext = null, _user:AbstractEntity = null):
	if resolved_targets.size() != 1:
		return
	
	if _user is not AbstractCreature:
		return
	
	var start_HP: int = resolved_targets[0].health.value
	
	var damage_action: AttackAction = AttackAction.new()
	damage_action.base_damage = base_damage
	damage_action.hits = hits
	damage_action.resolved_targets = resolved_targets
	damage_action.ignore_foreground = ignore_foreground
	damage_action.target_option = target_option
	await damage_action.execute(_context, _user)
	
	if is_instance_valid(resolved_targets[0]):
		amount = start_HP - resolved_targets[0].health.value
		resolved_targets[0] = _user
	else:
		amount = start_HP
		resolved_targets[0] = _user
	super(_context, _user)

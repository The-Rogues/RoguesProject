extends TargetedBattleAction
class_name AttackAction
## An action that deals damage to targeted entities with configurable damage,
## repeating hits, and potential side effects.
##
## Use as a component in an instance of a [BattleMove]

## The base damage that the attack will deal.
@export_range(0, 999) var base_damage:int = 6

@export_group("Repeat")
## Times the target will be damaged
@export_range(1, 99) var hits:int = 1
enum RepeatTargetMode {
	## Same entities will be hit on repeat
	LOCK_TARGETS, 
	## Different entities may be hit on repeat
	REROLL_TARGETS 
}
## Sets if the same or different targets are hit when attack is repeated
@export var repeat_mode:RepeatTargetMode = RepeatTargetMode.LOCK_TARGETS

@export_group("Damage Sampling")
## Enum used for replacing base damage with a different stat
enum SampleFrom {
	## Uses only base damage.
	NONE,
	## Replaces base damage with weight of character's offensive trait.
	OFFENSIVE_WEIGHT,
	## Replaces base damage with weight of character's defensive trait.
	DEFENSIVE_WEIGHT,
	## Replaces base damage with weight of character's strategic trait.
	STRATEGIC_WEIGHT,
	## Replaces base damage with user's current block value.
	USER_DEFENSE,
	## Replaces base damage with user's current parry value.
	USER_PARRY,
	## Replaces base damage with the total damage the user took last turn.
	LAST_DAMAGE_TAKEN,
}
@export var sample_from:SampleFrom = SampleFrom.NONE

@export_group("Status Effects")
@export var status_effects:Array[StatusEffectAction]

func _execute(battle_instance:BattleManager, _action_user:BattleEntity = null):
	var locked_targets:Array[BattleEntity] = []
	
	if repeat_mode == RepeatTargetMode.LOCK_TARGETS:
		locked_targets = _resolve_target(battle_instance, _action_user)
	
	for hit in hits:
		var targets = locked_targets if repeat_mode == RepeatTargetMode.LOCK_TARGETS \
			else _resolve_target(battle_instance, _action_user)
		
		_apply_hit(battle_instance, _action_user, targets)

func _apply_hit(
	battle_instance:BattleManager,
	_action_user:BattleEntity,
	targets:Array[BattleEntity]
):
	var damage = _calculate_damage(battle_instance, _action_user)
	var battle_object = battle_instance.battle_field.get_object()
	
	for target in targets:
		# Object interception
		if _apply_object_intercept(battle_object, damage, _action_user):
			await battle_instance.action_delay()
			continue
		
		# Deal damage
		target.take_damage(damage, _action_user)
		
		await battle_instance.action_delay()
		
		# Apply status effects PER HIT
		_enqueue_status_effects(
			battle_instance,
			_action_user,
			target
		)


func _calculate_damage(
	battle_instance:BattleManager,
	_action_user:BattleEntity
) -> int:
	var damage:int = base_damage
	damage += _sample_damage(battle_instance, _action_user)
	
	if _action_user:
		damage = _action_user.get_attack_damage(damage)
	
	var battle_object = battle_instance.battle_field.get_object()
	if battle_object:
		damage *= battle_object.data.damage_amplifier
	
	return max(damage, 0)


func _sample_damage(
	battle_instance:BattleManager,
	_action_user:BattleEntity
) -> int:
	match sample_from:
		SampleFrom.OFFENSIVE_WEIGHT:
			return battle_instance.character_personality.offensive_weight
		SampleFrom.DEFENSIVE_WEIGHT:
			return battle_instance.character_personality.defensive_weight
		SampleFrom.STRATEGIC_WEIGHT:
			return battle_instance.character_personality.strategic_weight
		SampleFrom.USER_DEFENSE:
			return _action_user.defense.current_defense
		SampleFrom.USER_PARRY:
			return _action_user.parry.current_parry
		SampleFrom.LAST_DAMAGE_TAKEN:
			return _action_user.damage_taken
		_:
			return 0


func _apply_object_intercept(
	battle_object:ObjectEntity,
	damage:int,
	_action_user:BattleEntity
) -> bool:
	if not battle_object:
		return false
	
	match battle_object.data.attack_filter:
		ObjectEntityData.AttackFilter.BLOCK:
			return true
		ObjectEntityData.AttackFilter.INTERCEPT:
			battle_object.take_damage(damage, _action_user)
			return true
	
	return false


func _enqueue_status_effects(
	battle_instance:BattleManager,
	_action_user:BattleEntity,
	_target:BattleEntity
):
	for status in status_effects:
		var action:StatusEffectAction = status.duplicate(true)
		# Overrides targeting of status action to target same entity
		action.target = TargetType.INHERITED
		action.inherited_targeting = [_target]
		
		battle_instance.action_queue.enqueue(
			action,
			battle_instance,
			_action_user
		)


func _damage_delay(battle_instance:BattleManager):
	# Delay is different so that if multiple entities are targeted, they play
	# damage animations in unison vs sequentially.
	if targeting.size() == 1:
		await battle_instance.action_delay()
	else:
		await battle_instance.get_tree().create_timer(0.05).timeout

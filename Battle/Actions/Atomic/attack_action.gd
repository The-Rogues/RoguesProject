extends TargetedBattleAction
class_name AttackAction
## An action that deals damage to targeted entities with configurable damage,
## repeating hits, and optional secondary effects.
##
## Use as a component in an instance of a [BattleMove]

## The base damage that the attack will deal.
@export_range(0, 999) var base_damage:int = 6

## Times the attack will be repeated. 1 = Hit Once.
@export_range(1, 99) var hits:int = 1

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
	USER_BLOCK,
	## Replaces base damage with user's current parry value.
	USER_PARRY,
	## Replaces base damage with the total damage the user took last turn.
	LAST_DAMAGE_TAKEN,
}
## Set to include a different stat to contribute to damage calculation. Ex.
## Damage = base_damage + user_block.
@export var sample_from:SampleFrom = SampleFrom.NONE

## An action that will be performed on the same target after an attack. Applied
## once. Ideal for single target attacks where you wish to apply a status effect
## on the target after dealing damage.
@export var secondary_action:TargetedBattleAction

func _execute(battle_instance:BattleManager, _action_user:BattleEntity = null):
	super(battle_instance, _action_user)
	
	for hit in hits:
		_apply_hit(battle_instance, _action_user, targets)
	
	for target in targets:
		_enqueue_secondary_action(
				battle_instance, 
				_action_user,
				target,
				secondary_action
		)


func _apply_hit(
	battle_instance:BattleManager,
	action_user:BattleEntity,
	_targets:Array[BattleEntity]
):
	var damage = _calculate_damage(battle_instance, action_user)
	var battle_object = battle_instance.battle_field.get_object()
	
	for target in _targets:
		# Object interception
		if _object_intercepts(battle_object, damage, action_user):
			await battle_instance.action_delay()
			continue
		
		# Deal damage
		target.take_damage(damage, action_user)
		
		await battle_instance.action_delay()


func _object_intercepts(
	battle_object:ObjectEntity,
	damage:int,
	action_user:BattleEntity
) -> bool:
	if not battle_object:
		return false
	
	match battle_object.data.attack_filter:
		ObjectEntityData.AttackFilter.BLOCK:
			return true
		ObjectEntityData.AttackFilter.INTERCEPT:
			battle_object.take_damage(damage, action_user)
			return true
	
	return false


func _calculate_damage(
	battle_instance:BattleManager,
	action_user:BattleEntity
) -> int:
	var damage:int = base_damage
	damage += _sample_damage(battle_instance, action_user)
	
	# If attacker is a BattleEntity modify damage output
	if action_user:
		damage = action_user.get_attack_damage(damage)
	
	var battle_object = battle_instance.battle_field.get_object()
	if battle_object:
		damage *= battle_object.data.damage_amplifier
	
	return max(damage, 0)


func _sample_damage(
	battle_instance:BattleManager,
	action_user:BattleEntity
) -> int:
	match sample_from:
		SampleFrom.OFFENSIVE_WEIGHT:
			return battle_instance.character_personality.offensive_weight + base_damage
		SampleFrom.DEFENSIVE_WEIGHT:
			return battle_instance.character_personality.defensive_weight + base_damage
		SampleFrom.STRATEGIC_WEIGHT:
			return battle_instance.character_personality.strategic_weight + base_damage
		SampleFrom.USER_BLOCK:
			return action_user.defense.current_defense + base_damage
		SampleFrom.USER_PARRY:
			return action_user.parry.current_parry + base_damage
		SampleFrom.LAST_DAMAGE_TAKEN:
			return action_user.damage_taken + base_damage
		_:
			return base_damage


func _enqueue_secondary_action(
	battle_instance:BattleManager,
	action_user:BattleEntity,
	_targets:BattleEntity,
	targeted_action:TargetedBattleAction
):
	if !targeted_action:
		return
	
	var action:TargetedBattleAction = targeted_action.duplicate(true)
	# Overrides targeting of targeted action to target same entity
	action.targeting = TargetingOption.INHERITED
	action.inherited_targeting = [_targets]
	
	battle_instance.action_queue.enqueue(
		action,
		battle_instance,
		action_user
	)


func _damage_delay(battle_instance:BattleManager):
	# Delay is different so that if multiple entities are targeted, they play
	# damage animations in unison vs sequentially.
	if targets.size() == 1:
		await battle_instance.action_delay()
	else:
		await battle_instance.get_tree().create_timer(0.05).timeout

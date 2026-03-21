extends TargetedBattleAction
class_name SkillAction

enum SkillEffect {
	BLOCK,
	PARRY,
	HEAL,
	ENERGY,
	GOLD,
	REPAIR_OBJECT,
}

@export var effect:SkillEffect

# -----------------------------
# Shared numeric payload
# -----------------------------
@export_range(-999, 999) var amount:int = 6
@export var bonus_random:int = 0
@export var reset_value:bool = false
@export_group("Amount Sampling")
enum SampleFrom {
	NONE,
	OFFENSIVE_WEIGHT,
	DEFENSIVE_WEIGHT,
	STRATEGIC_WEIGHT,
}
@export var sample_from:SampleFrom = SampleFrom.NONE
@export_group("Objects")
@export var repair_object_id:String
@export var object_data:ObjectEntityData

func _execute(battle_instance:BattleManager, _action_user:BattleEntity = null):
	#super(battle_instance, _action_user)
	if targets[0] is ObjectEntity:
		return
	
	match effect:
		SkillEffect.BLOCK:
			_apply_to_targets(battle_instance, _action_user, _apply_block)
		SkillEffect.PARRY:
			_apply_to_targets(battle_instance, _action_user, _apply_parry)
		SkillEffect.HEAL:
			_apply_to_targets(battle_instance, _action_user, _apply_heal)
		SkillEffect.ENERGY:
			battle_instance.energy_counter.add_energy(
				_calculate_amount(battle_instance, _action_user)
			)
		SkillEffect.GOLD:
			GlobalSessionManager.increase_gold(
				_calculate_amount(battle_instance, _action_user)
			)
		SkillEffect.REPAIR_OBJECT:
			var object:ObjectEntity = battle_instance.battle_field.get_object()
			if object:
				object.heal(_calculate_amount(battle_instance, _action_user))


func _calculate_amount(
	battle_instance:BattleManager,
	_action_user:BattleEntity
) -> int:
	var value := amount
	
	match sample_from:
		SampleFrom.OFFENSIVE_WEIGHT:
			value += battle_instance.player_personality.offensive_weight
		SampleFrom.DEFENSIVE_WEIGHT:
			value += battle_instance.player_personality.defensive_weight
		SampleFrom.STRATEGIC_WEIGHT:
			value += battle_instance.player_personality.strategic_weight
		SampleFrom.NONE:
			return amount

	value += randi_range(0, bonus_random)
	return value

func _apply_block(target:BattleEntity, value:int):
	
	if reset_value:
		target.defense.set_to_zero()
	else:
		target.defense.add_defense(value)

func _apply_parry(target:BattleEntity, value:int):
	
	if reset_value:
		target.parry.set_to_zero()
	else:
		target.parry.add_parry(value)

func _apply_heal(target:BattleEntity, value:int):
	if reset_value:
		target._health.set_to_zero()
	else:
		target.heal(value)

func _apply_to_targets(
	battle_instance:BattleManager,
	action_user:BattleEntity,
	apply_func:Callable
):
	var value:int = _calculate_amount(battle_instance, action_user)
	
	for target in targets:
		print("calling")
		apply_func.call(target, value)
		await battle_instance.action_delay()

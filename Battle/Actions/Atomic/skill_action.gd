extends TargetedBattleAction
class_name SkillAction

enum SkillEffect {
	BLOCK,
	PARRY,
	HEAL,
	ENERGY,
	GOLD,
}

@export var effect:SkillEffect

# -----------------------------
# Shared numeric payload
# -----------------------------
@export_range(-999, 999) var amount:int = 6
@export var bonus_random:int = 0

func _execute(battle_instance:BattleManager, _action_user:BattleEntity = null):
	match effect:
		SkillEffect.BLOCK:
			_apply_to_targets(battle_instance, _action_user, _apply_block)
		SkillEffect.PARRY:
			_apply_to_targets(battle_instance, _action_user, _apply_parry)
		SkillEffect.HEAL:
			_apply_to_targets(battle_instance, _action_user, _apply_heal)
		SkillEffect.ENERGY:
			battle_instance.energy_counter.add_energy(amount)
		SkillEffect.GOLD:
			_apply_gold()

func _apply_block(target:BattleEntity):
	target.defense.add_defense(amount + randi_range(0, bonus_random))

func _apply_parry(target:BattleEntity):
	target.parry.add_parry(amount + randi_range(0, bonus_random))

func _apply_heal(target:BattleEntity):
	target.heal(amount + randi_range(0, bonus_random))

func _apply_gold():
	GlobalSessionManager.increase_gold(amount + randi_range(0, bonus_random))

func _apply_to_targets(
	battle_instance:BattleManager,
	action_user:BattleEntity,
	apply_func:Callable
):
	targeting = _resolve_target(battle_instance, action_user)
	
	for target in targeting:
		apply_func.call(target)
		await battle_instance.action_delay()

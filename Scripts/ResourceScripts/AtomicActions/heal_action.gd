extends AtomicAction
class_name HealAction

@export var heal_amount:int = 0

func execute(battle_info:BattleActionInfo):
	for target in battle_info.targets:
		target.heal(heal_amount)
		await  target.entity_animator.animation_finished
		#await battle_info.animation_bus.play_hit(target)

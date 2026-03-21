extends BattleAction
class_name RatAttackAction

@export var rat_damage:int = 4

func _execute(battle_instance:BattleManager, _action_user:BattleEntity = null):
	var rat_event = battle_instance.battle_events.get_event(
			RatBattleEvent,
			_action_user
	)
	
	if rat_event == null:
		return
	
	var attack_action = AttackAction.new()
	attack_action.base_damage = rat_damage
	attack_action.targeting = TargetedBattleAction.TargetingOption.ENEMY
	
	for rat:Rat in rat_event.rats:
		battle_instance.action_queue.enqueue(
			attack_action,
			battle_instance,
			_action_user
		)
		
		rat.play_attack()

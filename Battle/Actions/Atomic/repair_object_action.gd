extends BattleAction
class_name RepairObjectAction

@export var amount:int

func _execute(battle_instance:BattleManager, action_user:BattleEntity):
	var object = battle_instance.battle_field.get_object()
	
	if object:
		object.heal(amount)

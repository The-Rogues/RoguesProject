extends BattleTurnEvent
class_name FalseCoinageEvent

var stack:int = 20

func initialize(
		new_battle_instance:BattleManager, 
		user:BattleEntity = null
) -> void:
	super(new_battle_instance, user)
	
	GlobalSessionManager.item_used.connect(_on_item_used)


func on_stack():
	stack += 20


func _on_item_used(item:ItemData):
	GlobalSessionManager.increase_gold(stack)

extends BattleTurnEvent
class_name FalseCoinageEvent

func initialize(
		new_battle_instance:BattleManager, 
		user:BattleEntity = null
) -> void:
	super(new_battle_instance, user)
	
	GlobalSessionManager.item_used.connect(_on_item_used)


func _on_item_used(item:ItemData):
	GlobalSessionManager.increase_gold(item.shop_price)

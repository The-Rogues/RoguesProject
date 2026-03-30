extends BattleTurnEvent
class_name RandomCostEvent


func initialize(
		new_battle_instance:BattleManager, 
		user:BattleEntity = null
) -> void:
	super(new_battle_instance, user)
	new_battle_instance.battle_card_manager.card_instance_drawn.connect(
		_on_card_instance_drawn
	)


func _on_card_instance_drawn(instance:CardInstance):
	instance.cost = randi_range(0, 5)
	instance.updated.emit()

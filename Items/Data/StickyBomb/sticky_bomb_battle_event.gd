extends BattleTurnEvent
class_name StickyBombEvent

const effect = preload("res://Items/Data/StickyBomb/sticky_bomb_status.tres")

func initialize(
		new_battle_instance:BattleManager, 
		user:BattleEntity = null
) -> void:
	super(new_battle_instance, user)
	
	for enemy in battle_instance.enemies:
		enemy.attacked.connect(_on_enemy_attacked)


func _on_enemy_attacked(entity:BattleEntity, attacker:Entity):
	if attacker == associated_entity:
		entity.status_conditions.add_status(effect, 4, 40)
		event_ended.emit(self)

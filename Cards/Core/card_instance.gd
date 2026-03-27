extends RefCounted
class_name CardInstance

signal updated(instance:CardInstance)

var cost:int
var data:CardData
var battle_instance:BattleManager
var player:BattleEntity

func _init(
	card_data:CardData,
	battle:BattleManager,
	player:BattleEntity
) -> void:
	data = card_data
	cost = card_data.energy_cost
	self.player = player
	player.status_conditions.changed.connect(_on_status_changed)


func _on_status_changed():
	updated.emit()


func get_stack_value(
) -> int:
	match data.move.actions[0]:
		AttackAction:
			return data.move.actions[0].get_stack_value(battle_instance, player)
		SkillAction:
			return data.move.actions[0].get_stack_value(battle_instance, player)
		ProjectileAction:
			return data.move.actions[0].get_stack_value(battle_instance, player)
		StatusEffectAction:
			return data.move.actions[0].get_stack_value(battle_instance, player)
		_:
			return -1

extends RefCounted
class_name BattleContext
# Given to Action Data in order to create and queue actions

var creature_manager:CreatureManager
var battle_field:BattleField
var reward_handler:BattleRewardsHandler
var resolve_targeting:Callable
var add_power:Callable

func _init(
	_creature_manager:CreatureManager,
	_battle_field_handler:BattleField,
	_reward_handler:BattleRewardsHandler,
) -> void:
	
	creature_manager = _creature_manager
	battle_field = _battle_field_handler
	reward_handler = _reward_handler


func get_player() -> PlayerEntity:
	return creature_manager.player

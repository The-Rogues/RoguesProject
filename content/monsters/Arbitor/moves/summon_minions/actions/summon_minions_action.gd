#author: Andy
extends Action
class_name SummonMinionsAction

@export var minion_data: MonsterData
@export_range(1, 3) var summon_count:int = 1
@export var choose_intent_on_spawn: bool = true


func execute(_context:BattleContext = null, _user:AbstractEntity = null):
	if _context == null:
		return
	
	if minion_data == null:
		return
	
	for i in range(summon_count):
		_context.creature_manager.spawn_enemy(
			minion_data,
			-1,
			choose_intent_on_spawn
		)

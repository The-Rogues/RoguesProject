extends Action
class_name SpawnEnemyAction

@export var monster_data:MonsterData
@export_range(1, 2) var spawn_count:int = 1
##If -1, will be max health
@export var starting_health:int = -1
@export var status:StatusEffectConfig


func execute(_context:BattleContext = null, _user:AbstractEntity = null):
	for i in range(0, spawn_count):
		_context.creature_manager.spawn_enemy(
				monster_data, 
				starting_health, 
				false,
				status)
	await _context.creature_manager.get_tree().create_timer(0.15).timeout

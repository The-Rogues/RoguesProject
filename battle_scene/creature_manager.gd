extends Node2D
class_name CreatureManager

signal player_defeated
signal enemy_defeated(monster:MonsterEntity)
signal all_enemies_defeated
signal enemy_spawned(monster:MonsterEntity)

@export var template_enemy:PackedScene
@export var spawn_parent:Node2D
var enemies:Array[MonsterEntity]
var player:PlayerEntity

const ENEMY_SPACING = 0.10
#const ENEMY_Y_POSITION = 0.5

func initialize(_player:PlayerEntity, _enemies:Array[MonsterData]):
	player = _player
	player.defeated.connect(_on_creature_defeated)
	
	for data in _enemies:
		spawn_enemy(data)


func spawn_enemy(data:MonsterData, starting_health:int = -1):
	var monster:MonsterEntity = template_enemy.instantiate()
	spawn_parent.add_child(monster)
	monster.global_position = spawn_parent.global_position
	enemies.append(monster)
	monster.initialize(data)
	
	if starting_health > 0:
		monster.health.initialize(
			starting_health,
			starting_health
		)
	
	enemy_spawned.emit(monster)
	
	monster.defeated.connect(_on_creature_defeated)
	
	_position_enemies()


func _position_enemies():
	if enemies.is_empty():
		return
	
	var viewport_size = get_viewport_rect().size
	var center_x = viewport_size.x / 2.0
	var y = spawn_parent.global_position.y
	
	var spacing = viewport_size.x * ENEMY_SPACING
	var count = enemies.size()
	var total_width = (count - 1) * spacing
	var start_x = center_x - total_width / 2.0
	
	if enemies.size() == 1:
		enemies[0].global_position = Vector2(center_x, y)
		return
	
	for i in range(0, enemies.size()):
		var y_pos = y + ((i % 2) * 10 )
		enemies[i].global_position = Vector2(start_x + i * spacing, y_pos)


func _on_creature_defeated(creature:AbstractCreature):
	if creature is PlayerEntity:
		player_defeated.emit()
	elif creature is MonsterEntity:
		enemy_defeated.emit(creature)
		enemies.erase(creature)
		
		if enemies.is_empty():
			all_enemies_defeated.emit()

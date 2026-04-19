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

const ENEMY_SPACING = 0.15
#const ENEMY_Y_POSITION = 0.5

func initialize(_player:PlayerEntity, _enemies:Array[MonsterData]):
	player = _player
	player.defeated.connect(_on_creature_defeated)
	
	for data in _enemies:
		spawn_enemy(data, -1, false)


func spawn_enemy(data:MonsterData, starting_health:int = -1, choose_intent:bool = false):
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
	
	if choose_intent:
		monster.choose_intent()


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
		
		creature.queue_free()

func update_attack_targeting() -> void:
	reset_attack_targeting()
	apply_healthiest()
	apply_weakest()
	apply_dangerous()
	apply_intelegent()
	apply_imbued()

func apply_healthiest() -> void:
	var highest_health: int = enemies[0].health.value
	for i in range(0, enemies.size()):
		if enemies[i].health.value > highest_health:
			highest_health = enemies[i].health.value
	for i in range(0, enemies.size()):
		if enemies[i].health.value == highest_health:
			enemies[i].updated_targeting.append(
				MonsterData.AttackTargetingCategory.HEALTHIEST
			)

func apply_weakest() -> void:
	var lowest_health: int = enemies[0].health.value
	for i in range(1, enemies.size()):
		if enemies[i].health.value < lowest_health:
			lowest_health = enemies[i].health.value
	for i in range(0, enemies.size()):
		if enemies[i].health.value == lowest_health:
			enemies[i].updated_targeting.append(
				MonsterData.AttackTargetingCategory.WEAKEST
			)

func apply_dangerous() -> void:
	for i in range(0, enemies.size()):
		if enemies[i].move_sequence == null:
			continue
		if enemies[i].move_sequence.moves[enemies[i].move_index].primary_action is DamageAction:
			enemies[i].updated_targeting.append(
				MonsterData.AttackTargetingCategory.DANGEROUS
			)

func apply_intelegent() -> void:
	for i in range(0, enemies.size()):
		if enemies[i].move_sequence == null:
			continue
		if enemies[i].move_sequence.moves[enemies[i].move_index].primary_action is not DamageAction:
			enemies[i].updated_targeting.append(
				MonsterData.AttackTargetingCategory.INTELEGENT
			)

func apply_imbued() -> void:
	for i in range(0, enemies.size()):
		if enemies[i].effects.active_effects.size() > 0:
			enemies[i].updated_targeting.append(
				MonsterData.AttackTargetingCategory.IMBUED
			)

func reset_attack_targeting() -> void:
	for i in range(0, enemies.size()):
		for j in range(enemies[i].updated_targeting.size() - 1, -1, -1):
			if enemies[i].updated_targeting[j] == MonsterData.AttackTargetingCategory.HEALTHIEST:
				enemies[i].updated_targeting.remove_at(j)
			elif enemies[i].updated_targeting[j] == MonsterData.AttackTargetingCategory.WEAKEST:
				enemies[i].updated_targeting.remove_at(j)
			elif enemies[i].updated_targeting[j] == MonsterData.AttackTargetingCategory.DANGEROUS:
				enemies[i].updated_targeting.remove_at(j)
			elif enemies[i].updated_targeting[j] == MonsterData.AttackTargetingCategory.INTELEGENT:
				enemies[i].updated_targeting.remove_at(j)
			elif enemies[i].updated_targeting[j] == MonsterData.AttackTargetingCategory.IMBUED:
				enemies[i].updated_targeting.remove_at(j)

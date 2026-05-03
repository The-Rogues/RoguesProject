extends Node2D
class_name CreatureManager

signal player_defeated
signal enemy_defeated(monster:MonsterEntity)
signal all_enemies_defeated
signal enemy_spawned(monster:MonsterEntity)

@export var template_enemy:PackedScene
@export var spawn_parent:Node2D

var enemy_objects:Array[ObjectEntity] = []
var enemies:Array[MonsterEntity]
var player:PlayerEntity

const ENEMY_SPACING = 0.15
#const ENEMY_Y_POSITION = 0.5

var show_preferences: bool = false

func initialize(_player:PlayerEntity, _enemies:Array[MonsterData]):
	player = _player
	player.defeated.connect(_on_creature_defeated)
	
	for data in _enemies:
		spawn_enemy(data, -1, false)


func spawn_enemy(
		data:MonsterData, 
		starting_health:int = -1, 
		choose_intent:bool = false,
		status_effect:StatusEffectConfig = null):
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
	
	if status_effect:
		monster.apply_status_effect(status_effect)


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


func add_object_enemy(object:ObjectEntity):
	if object.data.is_enemy:
		enemy_objects.append(object)
		object.destroyed.connect(
			func(_object):
				enemy_objects.erase(_object)
				check_enemy_defeat_condition())


func _on_creature_defeated(creature:AbstractCreature):
	if creature is PlayerEntity:
		player_defeated.emit()
	elif creature is MonsterEntity:
		enemy_defeated.emit(creature)
		enemies.erase(creature)
		
		check_enemy_defeat_condition()
		
		creature.queue_free()


func check_enemy_defeat_condition():
	if enemies.is_empty() and enemy_objects.is_empty():
			all_enemies_defeated.emit()

func toggle_preferences():
	for i in range(0, enemies.size()):
		enemies[i].stat_display.toggle_preferences()

func update_attack_targeting() -> void:
	reset_attack_targeting()
	apply_healthiest()
	apply_weakest()
	apply_dangerous()
	apply_intelegent()
	apply_imbued()
	update_preference_displays()

func update_preference_displays():
	var display_order: Array[int] = player.data.personality.create_trait_order(
		player.offensive_trait.weight_value,
		player.defensive_trait.weight_value,
		player.strategic_trait.weight_value
	)
	for i in range(0, enemies.size()):
		enemies[i].stat_display.preference_container.clear_icons()
		enemies[i].stat_display.preference_container.visible = show_preferences
		enemies[i].stat_display.status_effect_container.visible = !show_preferences
		for j in range(0, display_order.size()):
			var curr_trait: Trait
			match display_order[j]:
				0:
					curr_trait = player.offensive_trait
				1:
					curr_trait = player.defensive_trait
				2:
					curr_trait = player.strategic_trait
			if enemies[i].updated_targeting.has(curr_trait.data.enemy_targeting_preference):
				enemies[i].stat_display.preference_container.add_icon(
					curr_trait.data.display_texture
				)

func apply_healthiest() -> void:
	if enemies.size() == 0:
		return
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
	if enemies.size() == 0:
		return
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

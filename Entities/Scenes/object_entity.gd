extends Entity
class_name ObjectEntity

@onready var context_panel: ContextPanel = $UI/ContextPanel

const ATTACK_PROJECTILE = preload(
		"res://Entities/Scenes/AttackProjectile/attack_projectile.tscn"
)

func initialize(entity_data:EntityData, starting_health:int = -1):
	super(entity_data, starting_health)
	health_bar.visible = false
	
	context_panel.set_context(entity_data.description)


# -------------------------------------------------
# Damage & Health functions
# -------------------------------------------------
# Makes the entity lose health and emits relevent signals
# Override in children to add animation logic
func take_damage(amount:float, attacker:BattleEntity = null):
	if is_defeated:
		return
	
	if attacker != null:
		last_attacker = attacker
	
	if data.attack_filter == ObjectEntityData.AttackFilter.BLOCK or \
			data.attack_filter == ObjectEntityData.AttackFilter.INTERCEPT:
		_health.take_damage(amount)
		health_bar.visible = true
	
	damaged.emit(amount)
	damage_particles.emitting = true
	animation_player.stop()
	animation_player.play("entity/damage")
	await animation_player.animation_finished
	animation_player.play("entity/RESET")


func heal(amount:float):
	super(amount)
	if _health.current_health == _health.max_health:
		health_bar.visible = false
	animation_player.play("entity/RESET")

func projectile_delay():
	await get_tree().create_timer(0.15).timeout


func _on_new_turn_started():
	super()
	if !data:
		return
	
	if data.fire_projectile:
		for i in range(0, data.projectile_count):
			var projectile: AttackProjectile = ATTACK_PROJECTILE.instantiate()
			add_child(projectile)
			
			projectile.configure(
				self,
				data.projectile_texture,
				data.speed,
				data.impact_damage,
				data.face_direction
			)
			var direction = Vector2(0, -1)
			# Only allow upward deviation
			var min_angle = -data.direction_range * PI
			var max_angle = 0.0
			
			var angle_offset:float = randf_range(min_angle, max_angle)
			direction = direction.rotated(angle_offset)
			
			projectile.spawn_and_launch(global_position, direction)
			await projectile_delay()

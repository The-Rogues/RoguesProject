extends Area2D
class_name AttackProjectile

signal destroyed

enum HitEffect {
	NONE,
	BLOCK,
	PARRY,
	STATUS,
}

enum DamageTarget {PLAYER, ENEMY}
@export var effect:HitEffect
@export var damages:DamageTarget
@export var effect_amount:int
@export var status:StatusEffectData
@export var stack:int
@export var duration:int
@export var speed: float = 500.0
@export var timer: Timer
@export var sprite_2d: Sprite2D
@export var damage:int
@export var face_direction:bool
#@export var impact_effect:SkillAction
const POOF_PARTICLE = preload("res://General/Effects/Particles/poof.tscn")
var active:bool = false
var velocity: Vector2 = Vector2.ZERO
var projectile_owner

const FLOATING_NUMBERS = preload(
		"res://General/UI/DamageNumbers/floating_numbers.tscn"
)


func _physics_process(delta):
	if !active:
		return
	# Move the projectile based on its velocity
	global_position += velocity * delta

# -------------------------------------------------
# Initialization
# -------------------------------------------------
func initialize():
	pass


func configure(
	new_owner:Node2D,
	replacement_texture:Texture2D,
	new_speed:float,
	new_damage:int,
	new_face_direction:bool,
):
	projectile_owner = new_owner
	sprite_2d.texture = replacement_texture
	speed = new_speed
	damage = new_damage
	if new_face_direction:
		face_direction = true

func display_floating_numbers(text:String, parent):
	var new_pop_text = FLOATING_NUMBERS.instantiate()
	parent.add_child(new_pop_text)
	
	new_pop_text.initialize(text, Color.DIM_GRAY)

func spawn_and_launch(spawn_position:Vector2, direction: Vector2):
	# Set the initial velocity when the projectile is created
	global_position = spawn_position
	sprite_2d.visible = true
	velocity = direction * speed
	if face_direction:
		sprite_2d.rotation = direction.angle()-80
	active = true

func _on_body_entered(body):
	var entity = body.get_parent()
	if entity is not BattleEntity and entity is not ObjectEntity:
		return
	
	var collision_projectile_owner = body.get_parent()
	
	if collision_projectile_owner.is_defeated:
		return
	
	if collision_projectile_owner != projectile_owner:
		if collision_projectile_owner is ObjectEntity:
			if collision_projectile_owner.data.attack_filter != ObjectEntityData.AttackFilter.IGNORE:
				collision_projectile_owner.take_damage(damage)
				destroyed.emit()
		else:
			if not body.get_parent().ignore_projectiles:
				body.get_parent().take_damage(damage)
				match effect:
					HitEffect.NONE:
						pass
					HitEffect.BLOCK:
						_apply_block(body.get_parent())
					HitEffect.PARRY:
						_apply_parry(body.get_parent())
					HitEffect.STATUS:
						_apply_status(body.get_parent())
				destroyed.emit()
				
			else:
				display_floating_numbers("Miss...", body.get_parent())
				return
	else:
		return
	
	active = false
	sprite_2d.visible = false
	await spawn_particles(global_position)
	queue_free() # Remove the projectile upon collision


func _apply_block(target:BattleEntity):
	target.defense.add_defense(effect_amount)

func _apply_parry(target:BattleEntity):
	target.parry.add_parry(effect_amount)

func _apply_status(target:BattleEntity):
	target.status_conditions.add_status(status, duration, stack)

func _on_timer_timeout():
	# Remove the projectile after a set time to prevent it from traveling forever
	destroyed.emit()
	queue_free()

func spawn_particles(position:Vector2):
	var particles:CPUParticles2D = POOF_PARTICLE.instantiate()
	get_parent().add_child(particles)
	particles.global_position = position
	particles.emitting = true
	await particles.finished
	particles.queue_free()

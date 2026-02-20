extends Node2D
class_name ObjectEntity

signal destroyed(object_entity:ObjectEntity)
signal damaged(amount:int)
signal repaired(amount:int)
signal updated_entity_data
signal entered_new_turn

const LUANCH_BODY = preload("res://GeneralAssets/Nodes/LaunchBody/launch_spin_body.tscn")

# Source of the Entities display, stats, and behaviour information
@export var data:ObjectEntityData
@export var force_initialization:bool = false
@export var enable_launchbody_collisons:bool = true

@onready var sprite_2d: Sprite2D = $Sprite2D
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var context_panel: ContextPanel = $UI/ContextPanel

@onready var damage_numbers: DamageNumbers = $UI/NumbersSpawner
@onready var health_bar: HealthBar = $UI/Display/HealthBar
@onready var ui_dissapear_timer: Timer = $UI/UIDissapearTimer

@onready var damage_particles: CPUParticles2D = $DamageParticles

@onready var bounce_collision: CollisionShape2D = $BounceBox/CollisionShape2D
@onready var hurtbox_collision: CollisionShape2D = $Hurtbox/CollisionShape2D


var _health:HealthComponent
var last_attacker:BattleEntity = null
var is_defeated:bool = false

# -------------------------------------------------
# Initializing & deleting game session
# -------------------------------------------------
func _ready() -> void:
	if !enable_launchbody_collisons:
		bounce_collision.disabled = true
		hurtbox_collision.disabled = true
	
	if force_initialization:
		initialize(data)

# Updates data and display of entity
func initialize(object_data:ObjectEntityData, starting_health:int = -1):
	# If no new entity data was passed, initialize with passed data from export
	# Ensures resource for entity_data is unique to this instance
	data = object_data
	
	if starting_health > -1:
		_health = HealthComponent.new(starting_health)
	else:
		_health = HealthComponent.new(object_data.max_health)
	
	context_panel.set_context(object_data.get_description())
	#damage_numbers.initialize(self)
	damaged.connect(damage_numbers.display_damage_numbers)
	repaired.connect(damage_numbers.display_heal_numbers)
	health_bar.initialize(_health)
	
	health_bar.visible = false
	
	updated_entity_data.emit()
	_health.reached_zero.connect(_on_destroyed)


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
	animation_player.play("battle_object/damage")
	await animation_player.animation_finished
	animation_player.play("battle_object/idle")


func heal(amount:float):
	if is_defeated:
		return
	
	_health.heal(amount)
	repaired.emit(amount)
	if _health.current_health == _health.max_health:
		health_bar.visible = false
	
	animation_player.stop()
	animation_player.play("battle_object/heal")
	await animation_player.animation_finished
	animation_player.play("battle_object/idle")


# Will trigger _on_destroyed logic via signal from initialize
# Use to force defeat
func destroy():
	_health.set_to_zero()

# -------------------------------------------------
# Event functions
# -------------------------------------------------
func _on_destroyed():
	if is_defeated:
		return
	
	is_defeated = true
	
	# Turns off colissions when entity is defeated
	bounce_collision.disabled = true
	hurtbox_collision.disabled = true
	
	animation_player.stop()
	animation_player.play("entity/defeat")
	await animation_player.animation_finished
	destroyed.emit(self)
	
	ui_dissapear_timer.start()
	sprite_2d.visible = false
	damage_particles.emitting = true
	
	if data.launch_when_defeated:
		var launch_body:LaunchBody = LUANCH_BODY.instantiate()
		add_child(launch_body)
		launch_body.initialize(
			data.launch_speed,
			data.bounce_count,
			data.launch_impact_damage,
			data.display_texture
		)
		var direction:Vector2 = Vector2(0, -1)
		if last_attacker != null:
			if last_attacker.global_position.y < global_position.y:
				direction = Vector2(0, 1)
		launch_body.launch(direction)


func _on_new_turn_started():
	if is_defeated:
		return
	
	entered_new_turn.emit()

# Called when an physics body in layer 1 hits this entity's hurtbox collider
# Intended for detecting collisions with launch body
# Won't work if collision is disabled
func _on_hurtbox_body_entered(body: Node2D) -> void:
	if is_defeated:
		return
	
	if body is LaunchBody:
		take_damage(body.impact_force)

func _on_started_moving():
	animation_player.stop()
	animation_player.play("battle_object/march")


func _on_arrived():
	animation_player.play("battle_object/idle")

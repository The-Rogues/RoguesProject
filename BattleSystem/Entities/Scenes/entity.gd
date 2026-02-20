# Author: Fabian

# Used as a base class for BattleEntities (Player, Enemies), 
# and ObjectEntities (Walls, Chests, Interactables)
# All classes that inherit this should be designed as a template to all
# possible varients. Unique behaviours should come from entity_data behaviours
# that connect to signals in this class to trigger their logic

extends Node2D
class_name Entity
## A base class for damagable entities that appear in battles
##
## Initialized with entity data to set health

signal defeated(entity:Entity)
signal healed(amount:int)
signal damaged(amount:int)
signal updated_entity_data
signal entered_new_turn

const LUANCH_BODY = preload("res://GeneralAssets/Nodes/LaunchBody/launch_spin_body.tscn")

# Source of the Entities display, stats, and behaviour information
@export var data:EntityData
@export var force_initialization:bool = false
@export var enable_launchbody_collisons:bool = true

@onready var sprite_2d: Sprite2D = $SpriteRoot/Sprite2D
@onready var animation_player:AnimationPlayer = $EntityAnimator

@onready var damage_numbers: DamageNumbers = $UI/Display/DamageNumbers
@onready var health_bar: HealthBar = $UI/Display/HealthBar
@onready var name_label: Label = $UI/Display/NameLabel
@onready var ui_dissapear_timer: Timer = $UI/UIDissapearTimer

@onready var damage_particles: CPUParticles2D = $DamageParticles

@onready var bounce_collision: CollisionShape2D = $BounceBox/CollisionShape2D
@onready var hurtbox_collision: CollisionShape2D = $Hurtbox/CollisionShape2D

var _health:HealthComponent
var last_attacker:Entity = null
var is_defeated:bool = false
var can_heal:bool = true
var can_take_damage:bool = false

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
func initialize(entity_data:EntityData, starting_health:int = -1):
	# If no new entity data was passed, initialize with passed data from export
	# Ensures resource for entity_data is unique to this instance
	data = entity_data
	#animation_player.add_animation_library(
			#"entity",
			#entity_data.animation_library
	#)
	
	if starting_health > -1:
		_health = HealthComponent.new(starting_health)
	else:
		_health = HealthComponent.new(entity_data.max_health)
	
	if name_label:
		name_label.text = entity_data.name
	damage_numbers.initialize(self)
	health_bar.initialize(_health)
	
	updated_entity_data.emit()
	_health.reached_zero.connect(_on_defeated)

# -------------------------------------------------
# Damage & Health functions
# -------------------------------------------------
# Makes the entity lose health and emits relevent signals
# Override in children to add animation logic
func take_damage(amount:float, attacker:Entity = null):
	if is_defeated:
		return
	
	if attacker != null:
		last_attacker = attacker
	
	if can_take_damage:
		_health.take_damage(amount)
		damaged.emit(amount)
	else:
		damaged.emit(0)
	
	damage_particles.emitting = true
	animation_player.stop()
	animation_player.play("entity/damage")
	await animation_player.animation_finished
	animation_player.play("entity/idle")


# Makes the entity gains health and emits relevent signals
# Override in children to add animation logic
func heal(amount:float):
	if is_defeated:
		return
	
	if can_heal:
		_health.heal(amount)
		healed.emit(amount)
	else:
		healed.emit(0)
	
	animation_player.stop()
	animation_player.play("entity/heal")
	await animation_player.animation_finished
	animation_player.play("entity/idle")


# Will trigger _on_defeated logic via signal from initialize
# Use to force defeat
func kill():
	_health.set_to_zero()

# -------------------------------------------------
# Event functions
# -------------------------------------------------
func _on_defeated():
	if is_defeated:
		return
	
	is_defeated = true
	
	# Turns off colissions when entity is defeated
	bounce_collision.disabled = true
	hurtbox_collision.disabled = true
	
	animation_player.stop()
	animation_player.play("entity/defeat")
	await animation_player.animation_finished
	defeated.emit(self)
	
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

# Author: Fabian

# Used as a base class for BattleEntities (Player, Enemies), 
# and ObjectEntities (Walls, Chests, Interactables)
# All classes that inherit this should be designed as a template to all
# possible varients. Unique behaviours should come from entity_data behaviours
# that connect to signals in this class to trigger their logic

# Must be implemented as a child class
@abstract
extends Node2D
class_name Entity

signal defeated(entity:Entity)
signal healed(amount:int)
signal damaged(amount:int)
signal updated_entity_data

# Source of the Entities display, stats, and behaviour information
@export var entity_data:EntityData
# A reference to the sprite used to display this entity
@export var entity_sprite:Sprite2D
# A reference to the parent of all the entitiy's UI elements
@export var ui_display:Control
# A reference to the health bar for this entity
@export var health_bar:HealthBar
@export var ui_dissapear_timer:Timer
# Toggle to have entity_data change the entity object rather then wait
# for another script to call it's initializer
@export var debug_force_initialization:bool = false
@export var enable_launchbody_collisons:bool = true
# Collision detection for launch bodys
@onready var bounce_collision: CollisionShape2D = $BounceBox/CollisionShape2D
@onready var hurtbox_collision: CollisionShape2D = $Hurtbox/CollisionShape2D


# Use to store last entity that attacked this entity
var last_attacker:Entity = null
# Used as an event checker, do not change usage
var is_defeated:bool = false

func _ready() -> void:
	if !enable_launchbody_collisons:
		bounce_collision.disabled = true
		hurtbox_collision.disabled = true
	
	if debug_force_initialization:
		initialize(entity_data)
	
	ui_dissapear_timer.timeout.connect(_on_ui_dissapear_timeout)

# Updates data and display of entity
func initialize(new_entity_data:EntityData):
	# If no new entity data was passed, initialize with passed data from export
	# Ensures resource for entity_data is unique to this instance
	entity_data = new_entity_data.duplicate(true)
	#print("setting ", entity_data.name, " to ", entity_data.health_points)
	entity_data.health = Stat.new(entity_data.health_points, 0, 0, true)
	
	updated_entity_data.emit()
	# Sets health value depending on health stat configuration
	entity_data.health.initialize()
	# Allows behaviour scripts to connect to signals from this class
	# Use behaviours for unique functionality when it comes to entity status change events
	for behaviour in entity_data.behaviours:
		behaviour.initialize(self)
	# Connect signal to check when entity is at 0 health
	entity_data.health.min_reached.connect(_on_defeated)
	# Check makes health bar optional
	if health_bar:
		# Configures healthbar to max bounds of health stat values
		health_bar.initialize(entity_data.health)
	# Check makes sprite changes optional
	if entity_sprite:
		entity_sprite.texture = entity_data.display_texture

# Makes the entity lose health and emits relevent signals
# Override in children to add animation logic
func take_damage(amount:float, attacker:Entity = null):
	entity_data.health.reduce(amount)
	
	if is_defeated:
		return
	
	if attacker != null:
		last_attacker = attacker
	
	damaged.emit(amount)

# Makes the entity gains health and emits relevent signals
# Override in children to add animation logic
func heal(amount:float):
	if is_defeated:
		return
	
	entity_data.health.increase(amount)
	healed.emit(amount)

# Called by signal to handle death logic
func _on_defeated():
	if is_defeated:
		return
	is_defeated = true
	
	
	# Turns off colissions when entity is defeated
	bounce_collision.disabled = true
	hurtbox_collision.disabled = true
	
	# Enables to do something else with entity sprites when defeated
	if entity_sprite and !entity_data.wait_to_hide_sprite:
		entity_sprite.visible = false
	
	defeated.emit(self)
	
	# Waits a brief moment before hiding sprite
	if ui_display:
		# TODO: replace with timer node
		ui_dissapear_timer.start()
		hide_ui()

func hide_ui():
	ui_display.visible = false

# Will trigger _on_defeated logic via signal from initialize
# Use to force defeat
func kill():
	entity_data.health.set_to_min()

# Called when an physics body in layer 1 hits this entity's hurtbox collider
# Intended for detecting collisions with launch body
# Won't work if collision is disabled
func _on_hurtbox_body_entered(body: Node2D) -> void:
	if is_defeated:
		return
	
	if body is LaunchBody and entity_data.damaged_by_launchbody:
		print("hit")
		take_damage(6)

func _on_ui_dissapear_timeout():
	hide_ui()

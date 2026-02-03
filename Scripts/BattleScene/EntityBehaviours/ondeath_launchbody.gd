# Author: Fabian

# Creates a LaunchBody ragdoll of an entity that bounces off walls
# other entities, and damages entities

extends EntityBehaviour
class_name OnDeathLaunchBody

# Number of times the entity can hit things before popping
@export var bounces:int = 3
# Multiplies movement speed while bouncing
@export var speed:float = 400
var entity_sprite:Sprite2D
var direction:Vector2 = Vector2(0, 0)
# Reference to LaunchBody Node
const LAUNCH_BODY = preload("res://Nodes/Effects/launched_entity.tscn")

func initialize(new_entity:Entity):
	super(new_entity)
	entity_sprite = new_entity.entity_sprite
	entity_instance.defeated.connect(_on_entity_defeated)

func _on_entity_defeated(entity:Entity):
	entity.entity_sprite.visible = false
	var launch_body:LaunchBody = LAUNCH_BODY.instantiate()
	launch_body.bounce_count = bounces
	launch_body.speed = speed
	
	if entity_instance.last_attacker:
		if entity_instance.last_attacker.entity_data is EnemyData:
			direction.y = 1
		else:
			direction.y = -1
	else:
		direction.y = -1
	
	entity.add_child(launch_body)
	launch_body.spawn_and_launch(entity_sprite.texture, direction)

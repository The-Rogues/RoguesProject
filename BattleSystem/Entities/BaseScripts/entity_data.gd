extends Resource
class_name EntityData
## Resource that defines immutable information about an entity in battles
## 
## Intended to be used as a creatable asset in the file system
## to define new entities that are passed in the initialaztion of
## [Entity] classes.

# Texture that Entity class will display
@export var display_texture:Texture2D = preload("res://Testing/donkey.tres")
# Name of the entity (David, Skeleton, Chest, etc)
@export var id:String = "new_entity"
@export var name:String = "New Entity"
@export_multiline var description:String = "An unkown entity"
# Uses a Stat resource to allow for configurable stat behaviour
@export var max_health:int = 100
@export_group("Launch Body")
@export var launch_when_defeated:bool = false
@export_range(1, 10) var bounce_count:int = 3
@export var launch_impact_damage:int = 6
@export var launch_speed:int = 450

# Stores behaviour scripts that connect to signals in Entity to execute logic
#@export var behaviours:Array[EntityBehaviour]
func get_description():
	return name + "\n" + description

# Author: Fabian

# Used to store entity info that is read by Entity class to 
# configure its data and display

# Must be implemented using a child class
@abstract
extends Resource
class_name EntityData

# Texture that Entity class will display
@export var display_texture:Texture2D
# Name of the entity (David, Skeleton, Chest, etc)
@export var name:String
# Uses a Stat resource to allow for configurable stat behaviour
@export var health_points:int = 100
var health:Stat
# Used for special animations like the player's death
@export var wait_to_hide_sprite:bool = false
# Toggle for if the Entity instance will take damage if hit by a launch body
@export var damaged_by_launchbody:bool = true
# Stores behaviour scripts that connect to signals in Entity to execute logic
@export var behaviours:Array[EntityBehaviour]

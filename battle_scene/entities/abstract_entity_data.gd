@abstract
extends Resource
class_name AbstractEntityData

#TODO: Consider replacing with visual scene to allow for unique animations
@export var display_texture:Texture2D
@export var name:String
@export_range(1, 9999) var health:int = 15

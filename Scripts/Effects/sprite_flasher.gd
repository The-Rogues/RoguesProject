extends Node
class_name SpriteFlasher

#signal finished

@export var sprite_2d:Sprite2D
@export var flash_duration:float = 0.30
const flash_material:Material = preload("res://Graphics/Shaders/flash_sprite_material.tres")

func _ready() -> void:
	sprite_2d.material = flash_material

func flash_sprite():
	var mat := sprite_2d.material as ShaderMaterial
	if mat == null:
		return

	# Set initial flash
	mat.set_shader_parameter("flash_value", 0.8)

	# Tween back to 0
	var tween := create_tween()
	tween.tween_method(
		func(value): mat.set_shader_parameter("flash_value", value),
		0.8,
		0.0,
		flash_duration
	).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)

extends Node
class_name SpriteFlasher

#signal finished

@export var sprite: Sprite2D
@export var flash_material: ShaderMaterial

var tween: Tween

func _ready():
	sprite.material = flash_material
	flash_material.set_shader_parameter("flash_amount", 0.0)
	sprite.material = flash_material.duplicate()


func flash(
	color: Color = Color.WHEAT,
	strength:float = 1.0,
	duration:float = 0.08,
	pulses:int = 1
):
	if tween:
		tween.kill()
	
	flash_material.set_shader_parameter("flash_color", color)
	
	tween = create_tween()
	
	for i in pulses:
		tween.tween_property(
			flash_material,
			"shader_parameter/flash_amount",
			strength,
			duration * 0.5
		)
		tween.tween_property(
			flash_material,
			"shader_parameter/flash_amount",
			0.0,
			duration * 0.5
		)

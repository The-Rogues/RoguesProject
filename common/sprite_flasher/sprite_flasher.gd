extends Node
class_name SpriteFlasher

@export var sprite: Sprite2D
@export var flash_material: ShaderMaterial

var tween: Tween

func _ready():
	var mat := flash_material.duplicate()
	sprite.material = mat
	flash_material = mat
	
	flash_material.set_shader_parameter("flash_amount", 0.0)


func flash(
	color: Color = Color.WHITE,
	strength: float = 1.0,
	duration: float = 1.0,
	pulses: int = 1
):
	if tween:
		tween.kill()
	
	flash_material.set_shader_parameter("flash_color", color)
	
	flash_material.set_shader_parameter("flash_amount", 1.0)
	
	tween = create_tween()
	print("1:" ,flash_material.get_shader_parameter("flash_amount"))
	for i in range(pulses):
		tween.tween_property(
			flash_material,
			"shader_parameter/flash_amount",
			strength,
			duration * 0.5
		)
		print("2:", flash_material.get_shader_parameter("flash_amount"))
		tween.tween_property(
			flash_material,
			"shader_parameter/flash_amount",
			0.0,
			duration * 0.5
		)

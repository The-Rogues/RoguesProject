extends Sprite2D
class_name HitFlash

@onready var hit_flash: AnimationPlayer = $HitFlash


func flash():
	hit_flash.play("flash")

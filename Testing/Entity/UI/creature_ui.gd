extends Control

@onready var health_bar: HealthBar = $Elements/HealthBar
@onready var animation_player: AnimationPlayer = $AnimationPlayer


func initialize(object:ObjectEntity):
	health_bar.initialize(object.health)
	
	object.health.died.connect(_on_defeated)


func _on_defeated():
	animation_player.play("dissapear")

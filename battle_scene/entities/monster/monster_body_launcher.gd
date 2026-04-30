extends Node

@export var monster:MonsterEntity
const LAUNCH_BODY = preload("uid://ecd0ruerag5o")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	monster.defeated.connect(func(s):
		var body:LaunchBody = LAUNCH_BODY.instantiate()
		monster.get_parent().add_child(body)
		body.global_position = monster.global_position
		body.global_position.y -= 16
		body.initialize(400, 4, 0, monster.data.display_texture)
		body.launch(Vector2(randf_range(-1, 1), 1))
		)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

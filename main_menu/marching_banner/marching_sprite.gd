extends Node2D

@onready var timer: Timer = $Timer
@onready var march_delay: Timer = $MarchDelay
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var sprite_2d: Sprite2D = $Sprite2D

var start_pos: Vector2
var marching := false

@export var delay: float = 0.0
@export var animation_delay_time: float = 2.0
@export var textures: Array[Texture2D]

const SPEED := 50

func _ready() -> void:
	sprite_2d.texture = textures.pick_random()
	start_pos = global_position

	# Wait before activating unit
	march_delay.start(delay)
	await march_delay.timeout

	# Loop reset timer
	timer.timeout.connect(func():
		global_position = start_pos
		sprite_2d.texture = textures.pick_random()
		timer.start()
	)

	timer.start()
	marching = true

	if animation_delay_time > 0:
		await get_tree().create_timer(animation_delay_time).timeout

	animation_player.play("march")


func _process(delta: float) -> void:
	if marching:
		position.x -= SPEED * delta

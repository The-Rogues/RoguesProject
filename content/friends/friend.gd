extends Node2D
class_name Friend

@export var wander_area_center:Node2D
@onready var wait_timer: Timer = $WaitTimer
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var sprite_2d: Sprite2D = $Sprite2D
@onready var projectile_launcher: ProjectileLauncher = $ProjectileLauncher
@onready var action_wait_timer: Timer = $ActionWaitTimer
var behaviour:FriendBehaviour
var player_owner:PlayerEntity
var eventual_parent:Node

func initialize(
			_behaviour:FriendBehaviour, 
			_context:BattleContext,
			_owner:PlayerEntity):
	behaviour = _behaviour.duplicate()
	reparent(_owner, true)
	player_owner = _owner
	wander_area_center = _owner
	sprite_2d.texture = _behaviour.get_friend_texture()
	behaviour.initialize(_context, _owner, self)
	move_to(_owner.global_position)
	eventual_parent = _owner.get_parent()
	
	player_owner.health.died.connect(
		func(): reparent(eventual_parent, true))


func play_attack():
	animation_player.play("attack")
	await animation_player.animation_finished
	animation_player.play("RESET")


func move_to(new_position:Vector2):
	# Tween is a script that changes a passed property over time
	# Tweens finish when the passed paramater reaches a specified value
	var tween = get_tree().create_tween()
	animation_player.play("walk")
	# Interpolate entity position to new position in half a second
	tween.tween_property(self, "global_position", new_position, 0.8)
	# Waits until entity is at new position
	await tween.finished
	animation_player.play("RESET")
	wait_timer.start(randf_range(2, 3.5))


func _on_control_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.is_pressed():
			pass
			#print("clicked")
	pass # Replace with function body.


func _on_wait_timer_timeout() -> void:
	var random_position = wander_area_center.global_position
	random_position = Vector2(
			random_position.x + randf_range(-60, 60),
			random_position.y + randf_range(8, 15)
	)
	move_to(random_position)
	pass # Replace with function body.


func wait_random_time():
	action_wait_timer.start(randf_range(0.1, 0.5))
	await action_wait_timer.timeout

extends Button

signal selected(selected_texture:Texture2D)

@onready var sprite: TextureRect = $Control/Sprite
@onready var animation_player: AnimationPlayer = $AnimationPlayer


func _on_button_up() -> void:
	selected.emit(sprite.texture)
	


func _on_mouse_entered() -> void:
	animation_player.play("hover")
	pass # Replace with function body.


func _on_toggled(toggled_on: bool) -> void:
	if toggled_on:
		animation_player.play("select")
		await animation_player.animation_finished
		animation_player.play("selected")
	else:
		animation_player.play("RESET")
	pass # Replace with function body.

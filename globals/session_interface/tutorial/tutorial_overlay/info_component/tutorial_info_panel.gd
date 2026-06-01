extends Control
class_name TutorialInfoPanel

@onready var header_label: Label = %EventHeader
@onready var image_container: TextureRect = %DisplayImage
@onready var body_label: Label = %EventTextLabel
@onready var continue_button: Button = %ContinueButton

@onready var content_vbox: VBoxContainer = $MarginContainer/VBoxContainer

func initialize(
	header_text: String,
	display_image: Texture2D,
	body_text: String,
	container_scale: Vector2
) -> void:
	scale = container_scale
	header_label.text = header_text
	body_label.text = body_text
	if !display_image:
		content_vbox.add_theme_constant_override("separation", 10 + image_container.custom_minimum_size.y / 2)
		image_container.visible = false
	else:
		image_container.texture = display_image

func connect_to_button(in_call: Callable):
	continue_button.button_up.connect(in_call)

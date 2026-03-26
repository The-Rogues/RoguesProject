extends Control

@onready var slf_dash: Control = $ContentContainer/Dashboard
@onready var slf_content: Control = $ContentContainer/ComponentContent
@onready var slf_container: VBoxContainer = $ContentContainer

## Called when the node enters the scene tree for the first time.
#func _ready() -> void:
	#init_component(
		#load("res://Map/map_module/map_assets/battle.png"),
		#"Intent: Attack",
		#"This is the content that lies within my box.",
		#200,
		#6,
		#Color(1.0, 0.173, 0.0, 1.0),
		#Color(1.0, 0.353, 0.216, 1.0),
		#Color(0.729, 0.125, 0.0, 1.0)
	#)

func init_component(
	in_image: CompressedTexture2D,
	in_title: String,
	in_description: String,
	in_width: int,
	in_margin: int,
	in_col_1: Color,
	in_col_2: Color,
	in_col_3: Color,
) -> void:
	
	slf_container.add_theme_constant_override("separation", 0)
	
	slf_dash.init_dash(
		in_image,
		in_title,
		in_width,
		in_margin,
		in_col_1,
		in_col_2,
		in_col_3,
	)
	
	slf_content.init_content(
		in_description,
		in_width,
		in_margin,
		in_col_3,
	)
	
	slf_dash.add_callback(
		func(is_pressed):
			if is_pressed:
				slf_content.show_content()
				custom_minimum_size.y = slf_dash.get_height() + slf_content.get_height()
			else:
				slf_content.hide_content()
				custom_minimum_size.y = slf_dash.get_height()
	)
	
	custom_minimum_size.y = slf_dash.get_height()

func collapse() -> void:
	slf_content.hide_content()
	slf_dash.dash_expand.button_pressed = false
	custom_minimum_size.y = slf_dash.get_height()

func expand() -> void:
	slf_content.show_content()
	slf_dash.dash_expand.button_pressed = true
	custom_minimum_size.y = slf_dash.get_height() + slf_content.get_height()

func reset_child_callbacks() -> void:
	for connection in slf_dash.dash_expand.pressed.get_connections():
		slf_dash.dash_expand.pressed.disconnect(connection.callable)
	
	slf_dash.add_callback(
		func(is_pressed):
			if is_pressed:
				slf_content.show_content()
				custom_minimum_size.y = slf_dash.get_height() + slf_content.get_height()
			else:
				slf_content.hide_content()
				custom_minimum_size.y = slf_dash.get_height()
	)

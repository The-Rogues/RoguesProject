extends Control

@onready var dash_container: HBoxContainer = $DashContainer
@onready var dash_background: ColorRect = $DashBackground

@onready var dash_expand: Button

func init_dash(
	in_image: CompressedTexture2D,
	in_title: String,
	in_width: int,
	in_margin: int,
	bg_col: Color,
	button_col_1: Color,
	button_col_2: Color
) -> void:
	size = Vector2(in_width, in_width * 0.2)
	custom_minimum_size = Vector2(in_width, in_width * 0.2)
	z_index = 0
	
	dash_container.size = Vector2(in_width, in_width * 0.2)
	dash_container.custom_minimum_size = Vector2(in_width, in_width * 0.2)
	dash_container.add_theme_constant_override("separation", 0)
	dash_container.z_index = 0
	
	dash_background.size = Vector2(in_width, in_width * 0.2)
	dash_background.custom_minimum_size = Vector2(in_width, in_width * 0.2)
	dash_background.z_index = 0
	dash_background.mouse_filter = Control.MOUSE_FILTER_IGNORE
	dash_background.color = bg_col
	
	#-------------------------------------------------------------------
	var image_container: MarginContainer = MarginContainer.new()
	image_container.size = Vector2(in_width * 0.2, in_width * 0.2)
	image_container.custom_minimum_size = Vector2(in_width * 0.2, in_width * 0.2)
	image_container.z_index = 1
	
	image_container.add_theme_constant_override("margin_left", in_margin)
	image_container.add_theme_constant_override("margin_right", in_margin / 2)
	image_container.add_theme_constant_override("margin_top", in_margin)
	image_container.add_theme_constant_override("margin_bottom", in_margin)
	
	var image_rect: TextureRect = TextureRect.new()
	image_rect.texture = in_image
	
	image_container.add_child(image_rect)
	dash_container.add_child(image_container)
	
	#-------------------------------------------------------------------
	var title_container: MarginContainer = MarginContainer.new()
	title_container.size = Vector2(in_width * 0.6, in_width * 0.2)
	title_container.custom_minimum_size = Vector2(in_width * 0.6, in_width * 0.2)
	title_container.z_index = 1
	
	title_container.add_theme_constant_override("margin_left", in_margin / 2)
	title_container.add_theme_constant_override("margin_right", in_margin / 2)
	title_container.add_theme_constant_override("margin_top", in_margin)
	title_container.add_theme_constant_override("margin_bottom", in_margin)
	
	var title_lbl: Label = Label.new()
	title_lbl.add_theme_font_override("font", load("res://General/Fonts/dungeon-mode.ttf"))
	title_lbl.add_theme_font_size_override("font_size", (in_width * 0.2) / 3.5)
	title_lbl.text = in_title
	title_lbl.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	title_lbl.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	title_lbl.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	
	title_container.add_child(title_lbl)
	dash_container.add_child(title_container)
	
	#-------------------------------------------------------------------
	var button_container: MarginContainer = MarginContainer.new()
	button_container.size = Vector2(in_width * 0.2, in_width * 0.2)
	button_container.custom_minimum_size = Vector2(in_width * 0.2, in_width * 0.2)
	button_container.z_index = 1
	
	button_container.add_theme_constant_override("margin_left", in_margin / 2)
	button_container.add_theme_constant_override("margin_right", in_margin)
	button_container.add_theme_constant_override("margin_top", in_margin)
	button_container.add_theme_constant_override("margin_bottom", in_margin)
	
	dash_expand = Button.new()
	dash_expand.text = "..."
	dash_expand.add_theme_font_override("font", load("res://General/Fonts/dungeon-mode.ttf"))
	dash_expand.add_theme_font_size_override("font_size", (in_width * 0.2) / 5)
	dash_expand.toggle_mode = true
	
	var style := StyleBoxFlat.new()
	style.bg_color = button_col_1
	
	var style_2 := StyleBoxFlat.new()
	style_2.bg_color = button_col_2
	
	dash_expand.add_theme_stylebox_override("normal", style)
	dash_expand.add_theme_stylebox_override("hover", style)
	dash_expand.add_theme_stylebox_override("pressed", style_2)
	dash_expand.add_theme_stylebox_override("hover_pressed", style_2)
	
	button_container.add_child(dash_expand)
	dash_container.add_child(button_container)

func add_callback(in_call: Callable) -> void:
	dash_expand.pressed.connect(
		func():
			in_call.call(dash_expand.button_pressed)
	)

func get_height() -> int:
	return dash_container.custom_minimum_size.y

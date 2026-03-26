extends Control

@onready var slf_bg: ColorRect = $ContentBackground
@onready var slf_container: MarginContainer = $ContentContainer
@onready var slf_label: Label = $ContentContainer/ContentLabel

var content_margin: int

func init_content(
	in_content: String,
	in_width: int,
	in_margin: int,
	bg_col: Color
) -> void:
	
	content_margin = in_margin
	
	size = Vector2(in_width, 0)
	custom_minimum_size = Vector2(in_width, 0)
	z_index = 0
	
	slf_bg.size = Vector2(in_width, 0)
	slf_bg.custom_minimum_size = Vector2(in_width, 0)
	slf_bg.z_index = 0
	slf_bg.mouse_filter = Control.MOUSE_FILTER_IGNORE
	slf_bg.color = bg_col
	slf_bg.visible = false
	
	slf_container.size = Vector2(in_width, 0)
	slf_container.custom_minimum_size = Vector2(in_width, 0)
	slf_container.z_index = 0
	
	slf_container.add_theme_constant_override("margin_left", in_margin)
	slf_container.add_theme_constant_override("margin_right", in_margin)
	slf_container.add_theme_constant_override("margin_top", in_margin)
	slf_container.add_theme_constant_override("margin_bottom", in_margin)
	slf_container.visible = false
	
	slf_label.custom_minimum_size = Vector2(in_width, 0)
	slf_label.z_index = 1
	slf_label.add_theme_font_override("font", load("res://General/Fonts/dungeon-mode.ttf"))
	slf_label.add_theme_font_size_override("font_size", (in_width * 0.2) / 4)
	slf_label.text = in_content
	print(in_content)
	slf_label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	slf_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_LEFT
	slf_label.vertical_alignment = VERTICAL_ALIGNMENT_TOP

func show_content() -> void:
	
	size.y = slf_label.get_minimum_size().y + 2 * content_margin
	custom_minimum_size.y = slf_label.get_minimum_size().y + 2 * content_margin
	
	slf_bg.size.y = slf_label.get_minimum_size().y + 2 * content_margin
	slf_bg.custom_minimum_size.y = slf_label.get_minimum_size().y + 2 * content_margin
	slf_bg.visible = true
	
	slf_container.size.y = slf_label.get_minimum_size().y + 2 * content_margin
	slf_container.custom_minimum_size.y = slf_label.get_minimum_size().y + 2 * content_margin
	slf_container.visible = true

func hide_content() -> void:
	size.y = 0
	custom_minimum_size.y = 0
	
	slf_bg.size.y = 0
	slf_bg.custom_minimum_size.y = 0
	slf_bg.visible = false
	
	slf_container.size.y = 0
	slf_container.custom_minimum_size.y = 0
	slf_container.visible = false

func get_height() -> int:
	return slf_label.get_minimum_size().y + 2 * content_margin

extends Control
class_name CardUI

signal clicked(card: CardUI)
signal hovered(card: CardUI, is_hovering: bool)

@export var card_data: CardData
@export var force_initialization := false

@onready var energy_label: Label = $PanelContainer/EnergyLabel
@onready var name_label: Label = $CardUI/MarginContainer/VBoxContainer/Panel/NameLabel
@onready var description_label: Label = $CardUI/MarginContainer/VBoxContainer/VBoxContainer/DescriptionLabel
@onready var card_ui: PanelContainer = $CardUI

var base_scale: Vector2
var hover_scale := 0.08
var in_play_area := false


func _ready() -> void:
	base_scale = scale
	if force_initialization and card_data:
		set_card_data(card_data)


func set_card_data(data: CardData) -> void:
	card_data = data
	energy_label.text = str(data.energy_cost)
	name_label.text = data.move.name
	description_label.text = data.move.description


func _gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
			clicked.emit(self)


func blow_up(active: bool) -> void:
	if active:
		#top_level = true
		scale = base_scale * (1.0 + hover_scale)
	else:
		#top_level = false
		scale = base_scale


func show_border(show:bool):
	var unique_stylebox = StyleBoxFlat.new()
	unique_stylebox = card_ui.get_theme_stylebox("panel").duplicate(true)
	
	
	if show:
		# Change the border widths (example values)
		unique_stylebox.border_width_left = 4
		unique_stylebox.border_width_top = 4
		unique_stylebox.border_width_right = 4
		unique_stylebox.border_width_bottom = 4
	else:
		unique_stylebox.border_width_left = 0
		unique_stylebox.border_width_top = 0
		unique_stylebox.border_width_right = 0
		unique_stylebox.border_width_bottom = 0
	card_ui.add_theme_stylebox_override("panel", unique_stylebox)


func _on_mouse_entered() -> void:
	hovered.emit(self, true)


func _on_mouse_exited() -> void:
	hovered.emit(self, false)


func _on_area_2d_area_entered(_area: Area2D) -> void:
	in_play_area = true
	show_border(true)


func _on_area_2d_area_exited(_area: Area2D) -> void:
	in_play_area = false
	show_border(false)

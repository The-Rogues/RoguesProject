extends Control
class_name CardUI

signal clicked(card: CardUI)
signal hovered(card: CardUI, is_hovering: bool)

@export var card_data: CardData
@export var force_initialization := false

@onready var energy_label: Label = $PanelContainer/EnergyLabel
@onready var name_label: Label = $CardUI/MarginContainer/VBoxContainer/Panel/NameLabel
@onready var description_label: Label = $CardUI/MarginContainer/VBoxContainer/VBoxContainer/DescriptionLabel

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


func _on_mouse_entered() -> void:
	hovered.emit(self, true)


func _on_mouse_exited() -> void:
	hovered.emit(self, false)


func _on_area_2d_area_entered(_area: Area2D) -> void:
	in_play_area = true


func _on_area_2d_area_exited(_area: Area2D) -> void:
	in_play_area = false

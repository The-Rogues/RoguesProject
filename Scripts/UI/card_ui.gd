extends Control
class_name CardUI

# Reads card data and updates UI elements to reflect information

signal clicked(card:CardUI)
signal released(card:CardUI)
signal hovered(card:CardUI, is_hovering:bool)

@onready var energy_label: Label = $CardUI/MarginContainer/VBoxContainer/EnergyLabel
@onready var name_label: Label = $CardUI/MarginContainer/VBoxContainer/NameLabel
@onready var description_label: Label = $CardUI/MarginContainer/VBoxContainer/VBoxContainer/DescriptionLabel

@export var card_data:CardData
@export var starting_scale:Vector2
@export var hover_blow_up_amount:float = 0.05
var in_play_area:bool = false
var card_owner:CardHand

func _ready() -> void:
	starting_scale = scale
	
	if card_data:
		set_card_data(card_data)

func return_card_to_hand():
	if card_owner:
		card_owner.add_card(self)

func set_card_owner(card_hand:CardHand):
	card_owner = card_hand

func set_card_data(new_card_data:CardData):
	if energy_label == null:
		energy_label = $CardUI/MarginContainer/VBoxContainer/EnergyLabel
		name_label = $CardUI/MarginContainer/VBoxContainer/NameLabel
		description_label = $CardUI/MarginContainer/VBoxContainer/VBoxContainer/DescriptionLabel
	
	card_data = new_card_data
	energy_label.text = str(card_data.energy_cost)
	name_label.text = card_data.name
	description_label.text = card_data.description

func _on_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.is_pressed():
			clicked.emit(self)
		elif event.button_index == MOUSE_BUTTON_LEFT and event.is_released():
			released.emit(self)
	pass # Replace with function body.

# Used to have card be highlighted when hovered over by mouse
func blow_up(value:bool):
	if value:
		top_level = true
		#z_index = 100
		var new_scale = Vector2(starting_scale.x + hover_blow_up_amount, starting_scale.y + hover_blow_up_amount)
		scale = new_scale
	else:
		top_level = false
		#z_index = 0
		scale = starting_scale

func _on_mouse_entered() -> void:
	hovered.emit(self, true)
	pass # Replace with function body.

func _on_mouse_exited() -> void:
	hovered.emit(self, false)
	pass # Replace with function body.


func _on_area_2d_area_entered(area: Area2D) -> void:
	in_play_area = true
	pass # Replace with function body.


func _on_area_2d_area_exited(area: Area2D) -> void:
	in_play_area = false
	pass # Replace with function body.

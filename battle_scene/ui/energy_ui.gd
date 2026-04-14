extends Control
class_name EnergyUI

@onready var energy_label: Label = $Container/EnergyLabel
@onready var container: Panel = $Container
@onready var floating_text: FloatingTextSpawner = $FloatingText

var active_color:Color
@export var inactive_color:Color



func initialize(energy:Energy):
	active_color = container.self_modulate
	energy.energy_changed.connect(_on_energy_changed)


func _on_energy_changed(current:int, max:int):
	energy_label.text = str(current) + "/" + str(max)
	
	if current == 0:
		container.self_modulate = inactive_color
		floating_text.create("Out of Energy")
	else:
		container.self_modulate = active_color

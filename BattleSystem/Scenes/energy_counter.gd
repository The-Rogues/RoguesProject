extends PanelContainer
class_name EnergyCounter

@export_range(0, 10) var energy_default:int = 3
var energy:int
@onready var label: Label = $Label

func _ready() -> void:
	reset_energy()

func initialize(energy_amount:int):
	energy_default = energy_amount
	reset_energy()

func reset_energy():
	energy = energy_default
	label.text = str(energy) + "/" + str(energy_default)

func can_play_card(card_data:CardData):
	if !card_data:
		return
	
	if card_data.energy_cost <= energy:
		return true
	return false

func spend_energy(energy_cost:int):
	energy = max(0, energy - energy_cost)
	label.text = str(energy) + "/" + str(energy_default)

func add_energy(energy_amount:int):
	energy = min(10, energy + energy_amount)
	label.text = str(energy) + "/" + str(energy_default)

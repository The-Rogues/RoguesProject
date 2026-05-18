extends Control
class_name RandomPersonalitySlot

signal random_trait_bought

@onready var cost_label: Label = $VBoxContainer3/Container/VBoxContainer/CostLabel
@onready var buy_button: Button = $VBoxContainer3/ChangeButton


var price: int = 10


func _ready() -> void:
	buy_button.pressed.connect(
		_on_buy_button_pressed
	)


func initialize(_price: int) -> void:
	price = _price

	cost_label.text = str(price) + " G"

	buy_button.text = "Random Trait"


func _on_buy_button_pressed() -> void:
	random_trait_bought.emit()

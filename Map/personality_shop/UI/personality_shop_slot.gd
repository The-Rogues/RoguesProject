extends Control
class_name PersonalityShopSlot

signal trait_selected(slot, p_trait: PersonalityTrait)
signal weight_selected(slot, weight: int)

@onready var cost_label: Label = $VBoxContainer3/Container/VBoxContainer/CostLabel
@onready var trait_display: TraitDisplay = $VBoxContainer3/Container/VBoxContainer/TextureRect/TraitDisplay
@onready var up_button: Button = $VBoxContainer3/Container/VBoxContainer2/Up
@onready var down_button: Button = $VBoxContainer3/Container/VBoxContainer2/Down
@onready var change_button: Button = $VBoxContainer3/ChangeButton
@onready var change_option: OptionButton = $VBoxContainer3/OptionButton

var current_trait: PersonalityTrait = null
var offered_traits: Array[PersonalityTrait] = []
var current_index: int = -1
var price: int = 10
var viewing_current: bool = true
var current_weight: int = 1
var original_weight: int = 1
var weight_change_amount: int = 0
var change_index: int = 0 # 0 = Change Trait, 1 = Change Weight


func _ready() -> void:
	up_button.pressed.connect(_on_up_pressed)
	down_button.pressed.connect(_on_down_pressed)
	change_button.pressed.connect(_on_change_button_pressed)
	change_option.item_selected.connect(_on_change_option_button_pressed)


func initialize(
	_current_trait: PersonalityTrait,
	_offered_traits: Array[PersonalityTrait],
	_current_weight: int,
	_price: int = 10
) -> void:
	current_trait = _current_trait
	offered_traits = _offered_traits
	current_weight = _current_weight
	original_weight = _current_weight
	weight_change_amount = 0
	price = _price

	current_index = -1
	viewing_current = true
	change_index = 0

	cost_label.text = "0 G"
	change_button.disabled = true
	change_button.text = "Current"

	up_button.disabled = false
	down_button.disabled = false

	change_option.select(0)

	_show_trait(current_trait, current_weight)


func _show_trait(p_trait: PersonalityTrait, weight: int) -> void:
	if p_trait == null:
		return

	trait_display.update_trait_label(p_trait)
	trait_display.update_weight_label(weight)


func update_current(p_trait: PersonalityTrait, weight: int = -1) -> void:
	current_trait = p_trait

	if weight != -1:
		current_weight = weight
		original_weight = weight
	else:
		original_weight = current_weight

	weight_change_amount = 0
	current_index = -1
	viewing_current = true
	change_index = 0

	up_button.disabled = false
	down_button.disabled = false

	cost_label.text = "0 G"
	change_button.disabled = true
	change_button.text = "Current"
	change_option.select(0)

	_show_trait(current_trait, current_weight)


func _on_up_pressed() -> void:
	if change_index == 0:
		_trait_up()
	else:
		_weight_up()


func _on_down_pressed() -> void:
	if change_index == 0:
		_trait_down()
	else:
		_weight_down()


func _trait_up() -> void:
	if offered_traits.is_empty():
		return

	if viewing_current:
		current_index = offered_traits.size() - 1
		viewing_current = false
	else:
		current_index -= 1

		if current_index < 0:
			viewing_current = true
			current_index = -1
			cost_label.text = "0 G"
			change_button.disabled = true
			change_button.text = "Current"
			_show_trait(current_trait, current_weight)
			return

	cost_label.text = str(price) + " G"
	change_button.disabled = false
	change_button.text = "Change Trait"
	_show_trait(offered_traits[current_index], current_weight)


func _trait_down() -> void:
	if offered_traits.is_empty():
		return

	if viewing_current:
		current_index = 0
		viewing_current = false
	else:
		current_index += 1

		if current_index >= offered_traits.size():
			viewing_current = true
			current_index = -1
			cost_label.text = "0 G"
			change_button.disabled = true
			change_button.text = "Current"
			_show_trait(current_trait, current_weight)
			return

	cost_label.text = str(price) + " G"
	change_button.disabled = false
	change_button.text = "Change Trait"
	_show_trait(offered_traits[current_index], current_weight)


func _weight_up() -> void:
	if weight_change_amount != 0:
		return

	if original_weight >= 10:
		return

	weight_change_amount = 1
	current_weight = original_weight + weight_change_amount

	cost_label.text = str(price) + " G"
	change_button.disabled = false
	change_button.text = "Buy +1 Weight"

	up_button.disabled = true
	down_button.disabled = true

	_show_trait(current_trait, current_weight)


func _weight_down() -> void:
	if weight_change_amount != 0:
		return

	if original_weight <= 1:
		return

	weight_change_amount = -1
	current_weight = original_weight + weight_change_amount

	cost_label.text = str(price) + " G"
	change_button.disabled = false
	change_button.text = "Buy -1 Weight"

	up_button.disabled = true
	down_button.disabled = true

	_show_trait(current_trait, current_weight)


func _on_change_button_pressed() -> void:
	if change_index == 0:
		if viewing_current or current_index < 0:
			return

		trait_selected.emit(self, offered_traits[current_index])
	else:
		if weight_change_amount == 0:
			return

		weight_selected.emit(self, current_weight)


func _on_change_option_button_pressed(index: int) -> void:
	change_index = index

	weight_change_amount = 0
	current_weight = original_weight

	up_button.disabled = false
	down_button.disabled = false

	if change_index == 0:
		viewing_current = true
		current_index = -1
		cost_label.text = "0 G"
		change_button.disabled = true
		change_button.text = "Current"
		_show_trait(current_trait, current_weight)
	else:
		viewing_current = true
		current_index = -1
		cost_label.text = "0 G"
		change_button.disabled = true
		change_button.text = "Choose +1 or -1"
		_show_trait(current_trait, current_weight)

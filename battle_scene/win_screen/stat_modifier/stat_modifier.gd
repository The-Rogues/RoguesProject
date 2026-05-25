extends Control

@onready var offensive_trait_name_label: Label = %OffensiveTraitNameLabel
@onready var offense_button: Button = %OffenseButton
@onready var offensive_trait_icon: TextureRect = %OffensiveTraitIcon
@onready var offense_stat_label: Label = %OffenseStatLabel

@onready var defensive_trait_name_label: Label = %DefensiveTraitNameLabel
@onready var defense_button: Button = %DefenseButton
@onready var defensive_trait_icon: TextureRect = %DefensiveTraitIcon
@onready var defensive_stat_label: Label = %DefensiveStatLabel

@onready var strategic_trait_name_label: Label = %StrategicTraitNameLabel
@onready var strategy_button: Button = %StrategyButton
@onready var strategic_trait_icon: TextureRect = %StrategicTraitIcon
@onready var strategic_stat_label: Label = %StrategicStatLabel

@onready var increase_button: Button = %IncreaseButton
@onready var decrease_button: Button = %DecreaseButton

var personality: PersonalityData

enum TraitType {
	NONE,
	OFFENSIVE,
	DEFENSIVE,
	STRATEGIC
}

var selected_trait: TraitType = TraitType.NONE


#==============================================================================
# Initialization & Setup
#==============================================================================

func initialize():
	var run := GlobalSessionManager.run_progress

	if run:
		personality = run.player_data.personality

		_setup_trait(
			offensive_trait_icon,
			offensive_trait_name_label,
			offense_stat_label,
			personality.offensive_trait,
			personality.offensive_weight
		)

		_setup_trait(
			defensive_trait_icon,
			defensive_trait_name_label,
			defensive_stat_label,
			personality.defensive_trait,
			personality.defensive_weight
		)

		_setup_trait(
			strategic_trait_icon,
			strategic_trait_name_label,
			strategic_stat_label,
			personality.strategic_trait,
			personality.strategic_weight
		)

	increase_button.disabled = true
	decrease_button.disabled = true

	defense_button.disabled = false
	offense_button.disabled = false
	strategy_button.disabled = false


#==============================================================================
# Button Callbacks
#==============================================================================

func _on_offense_button_up() -> void:
	if personality:
		selected_trait = TraitType.OFFENSIVE
		_update_mod_buttons()


func _on_defense_button_button_up() -> void:
	if personality:
		selected_trait = TraitType.DEFENSIVE
		_update_mod_buttons()


func _on_strategy_button_button_up() -> void:
	if personality:
		selected_trait = TraitType.STRATEGIC
		_update_mod_buttons()


func _on_increase_button_button_up() -> void:
	_modify_selected_trait_stat(1)


func _on_decrease_button_button_up() -> void:
	_modify_selected_trait_stat(-1)


#==============================================================================
# Trait Modification
#==============================================================================

func _modify_selected_trait_stat(amount: int):
	if selected_trait == TraitType.NONE or !personality:
		return

	match selected_trait:
		TraitType.OFFENSIVE:
			personality.set_trait_weight(
				"OFFENSIVE",
				personality.offensive_weight + amount
			)

		TraitType.DEFENSIVE:
			personality.set_trait_weight(
				"DEFENSIVE",
				personality.defensive_weight + amount
			)

		TraitType.STRATEGIC:
			personality.set_trait_weight(
				"STRATEGIC",
				personality.strategic_weight + amount
			)

	_refresh_trait_stats()
	_update_mod_buttons()

	_end_trait_selection()


#==============================================================================
# Helper Functions
#==============================================================================

func _setup_trait(
	trait_icon: TextureRect,
	trait_name_label: Label,
	trait_stat_label: Label,
	trait_data: PersonalityTrait,
	trait_weight: int
):
	trait_icon.texture = trait_data.display_texture
	trait_name_label.text = trait_data.name
	trait_stat_label.text = str(trait_weight)


func _refresh_trait_stats():
	offense_stat_label.text = str(personality.offensive_weight)
	defensive_stat_label.text = str(personality.defensive_weight)
	strategic_stat_label.text = str(personality.strategic_weight)


func _update_mod_buttons():
	if selected_trait == TraitType.NONE or !personality:
		return

	match selected_trait:
		TraitType.OFFENSIVE:
			decrease_button.disabled = personality.offensive_weight <= 1
			increase_button.disabled = personality.offensive_weight >= 10

		TraitType.DEFENSIVE:
			decrease_button.disabled = personality.defensive_weight <= 1
			increase_button.disabled = personality.defensive_weight >= 10

		TraitType.STRATEGIC:
			decrease_button.disabled = personality.strategic_weight <= 1
			increase_button.disabled = personality.strategic_weight >= 10


func _end_trait_selection():
	_reset_trait_selection()

	await get_tree().create_timer(2).timeout

	visible = false


func _reset_trait_selection():
	offense_button.disabled = true
	offense_button.button_pressed = false

	defense_button.disabled = true
	defense_button.button_pressed = false

	strategy_button.disabled = true
	strategy_button.button_pressed = false

	increase_button.disabled = true
	decrease_button.disabled = true

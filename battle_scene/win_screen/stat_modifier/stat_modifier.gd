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
@onready var stragic_trait_icon: TextureRect = %StragicTraitIcon
@onready var strategic_stat_label: Label = %StrategicStatLabel
@onready var increase_button: Button = %IncreaseButton
@onready var decrease_button: Button = %DecreaseButton
var personality:PersonalityData
var selected_trait:String = ""

func initialize():
	var run = GlobalSessionManager.run_progress
	
	if run:
		personality = run.player_data.personality
		
		offensive_trait_name_label.text = personality.offensive_trait.name
		offense_stat_label.text = str(personality.offensive_weight)
		offensive_trait_icon.texture = personality.offensive_trait.display_texture
		
		defensive_trait_name_label.text = personality.defensive_trait.name
		defensive_stat_label.text = str(personality.defensive_weight)
		defensive_trait_icon.texture = personality.defensive_trait.display_texture
		
		strategic_trait_name_label.text = personality.strategic_trait.name
		strategic_stat_label.text = str(personality.strategic_weight)
		stragic_trait_icon.texture = personality.strategic_trait.display_texture
	
	increase_button.disabled = true
	decrease_button.disabled = true
	defense_button.disabled = false
	offense_button.disabled = false
	strategy_button.disabled = false


func enable_modifier_buttons():
	increase_button.disabled = false
	decrease_button.disabled = false


func disable_buttons():
	increase_button.disabled = true
	decrease_button.disabled = true
	defense_button.disabled = true
	offense_button.disabled = true
	strategy_button.disabled = true
	

func _on_offense_button_up() -> void:
	if personality:
		selected_trait = "OFFENSIVE"
	enable_modifier_buttons()
	
	pass # Replace with function body.


func _on_defense_button_button_up() -> void:
	if personality:
		selected_trait = "DEFENSIVE"
	enable_modifier_buttons()
	pass # Replace with function body.


func _on_strategy_button_button_up() -> void:
	if personality:
		selected_trait = "STRATEGIC"
	enable_modifier_buttons()
	pass # Replace with function body.


func _on_increase_button_button_up() -> void:
	modify_stat(true)
	pass # Replace with function body.


func _on_decrease_button_button_up() -> void:
	modify_stat(false)
	pass # Replace with function body.


func modify_stat(increasing:bool):
	var mod:int = 0
	if increasing:
		mod = 1
	else:
		mod = -1
	
	if selected_trait == "OFFENSIVE":
		personality.set_trait_weight(
				selected_trait, 
				personality.offensive_weight + mod)
	elif selected_trait == "DEFENSIVE":
		personality.set_trait_weight(
				selected_trait, 
				personality.defensive_weight + mod)
	elif selected_trait == "STRATEGIC":
		personality.set_trait_weight(
				selected_trait, 
				personality.strategic_weight + mod)
	
	disable_buttons()
	await get_tree().create_timer(2).timeout
	visible = false

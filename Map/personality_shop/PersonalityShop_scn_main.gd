extends Control

# Personality change elements.
@onready var slf_lbl_1: Label = $change_lbl_1
@onready var slf_button_1: Button = $change_button_1
@onready var slf_lbl_2: Label = $change_lbl_2
@onready var slf_button_2: Button = $change_button_2

# Stat buttons
@onready var slf_offense_add = $offense_add
@onready var slf_offense_rem = $offense_remove
@onready var slf_defense_add = $defense_add
@onready var slf_defense_rem = $defense_remove
@onready var slf_strategic_add = $strategic_add
@onready var slf_strategic_rem = $strategic_remove

# Main Label
@onready var slf_main_lbl = $main_label


var first_change_trait: PersonalityTrait
var first_change_target: int
var second_change_trait: PersonalityTrait
var second_change_target: int

var brute_trait: Resource = preload("res://PersonalitySystem/PersonalityTraits/Offensive/Brute/brute_offensive_trait.tres")
var merciful_trait: Resource = preload("res://PersonalitySystem/PersonalityTraits/Offensive/Merciful/merciful_offensive_trait.tres")
var tactical_trait: Resource = preload("res://PersonalitySystem/PersonalityTraits/Offensive/Merciful/merciful_offensive_trait.tres")
var fickle_trait: Resource = preload("res://PersonalitySystem/PersonalityTraits/Defensive/Fickle/fickle_defensive_trait.tres")
var naive_trait: Resource = preload("res://PersonalitySystem/PersonalityTraits/Defensive/Naive/naive_defensive_trait.tres")
var stoic_trait: Resource = preload("res://PersonalitySystem/PersonalityTraits/Defensive/Stoic/stoic_defensive_trait.tres")
var crafty_trait: Resource = preload("res://PersonalitySystem/PersonalityTraits/Strategic/Crafty/crafty_trait_data.tres")
var greedy_trait: Resource = preload("res://PersonalitySystem/PersonalityTraits/Strategic/Greedy/greedy_strategic_trait.tres")
var laidback_trait: Resource = preload("res://PersonalitySystem/PersonalityTraits/Strategic/Laidback/laidback_strategic_trait.tres")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var personality_types: Array[int] = [0, 1, 2]
	var offensive_trait_optns: Array[int] = [0, 1, 2]
	var defensive_trait_optns: Array[int] = [0, 1, 2]
	var strategic_trait_optns: Array[int] = [0, 1, 2]
	var rand_num: float = randf()
	if rand_num < (1.0/3.0):
		personality_types.remove_at(0)
	elif rand_num < (1.0/3.0) * 2:
		personality_types.remove_at(1)
	else:
		personality_types.remove_at(2)
	
	if GlobalSessionManager.run_progress.personality_data.offensive_trait == brute_trait:
		offensive_trait_optns.remove_at(0)
	elif GlobalSessionManager.run_progress.personality_data.offensive_trait == merciful_trait:
		offensive_trait_optns.remove_at(1)
	else:
		offensive_trait_optns.remove_at(2)
		
	if GlobalSessionManager.run_progress.personality_data.defensive_trait == fickle_trait:
		defensive_trait_optns.remove_at(0)
	elif GlobalSessionManager.run_progress.personality_data.defensive_trait == naive_trait:
		defensive_trait_optns.remove_at(1)
	else:
		defensive_trait_optns.remove_at(2)
		
	if GlobalSessionManager.run_progress.personality_data.strategic_trait == crafty_trait:
		strategic_trait_optns.remove_at(0)
	elif GlobalSessionManager.run_progress.personality_data.strategic_trait == greedy_trait:
		strategic_trait_optns.remove_at(1)
	else:
		strategic_trait_optns.remove_at(2)
	
	var rand_num_i: int = randi_range(0, 1)
	offensive_trait_optns.remove_at(rand_num_i)
	
	rand_num_i = randi_range(0, 1)
	defensive_trait_optns.remove_at(rand_num_i)
	
	rand_num_i = randi_range(0, 1)
	strategic_trait_optns.remove_at(rand_num_i)
	
	if personality_types[0] == 0:
		slf_lbl_1.text = "Offensive Personality Change\n(100 Gold)"
		first_change_target = 0
		if offensive_trait_optns[0] == 0:
			first_change_trait = brute_trait
			slf_button_1.text = "Change to \"Brute\""
		elif offensive_trait_optns[0] == 1:
			first_change_trait = merciful_trait
			slf_button_1.text = "Change to \"Merciful\""
		else:
			first_change_trait = tactical_trait
			slf_button_1.text = "Change to \"Tactical\""
	elif personality_types[0] == 1:
		slf_lbl_1.text = "Defensive Personality Change\n(100 Gold)"
		first_change_target = 1
		if defensive_trait_optns[0] == 0:
			first_change_trait = fickle_trait
			slf_button_1.text = "Change to \"Fickle\""
		elif defensive_trait_optns[0] == 1:
			first_change_trait = naive_trait
			slf_button_1.text = "Change to \"Naive\""
		else:
			first_change_trait = stoic_trait
			slf_button_1.text = "Change to \"Stoic\""
	
	if personality_types[1] == 1:
		slf_lbl_2.text = "Defensive Personality Change\n(100 Gold)"
		second_change_target = 1
		if defensive_trait_optns[0] == 0:
			second_change_trait = fickle_trait
			slf_button_2.text = "Change to \"Fickle\""
		elif defensive_trait_optns[0] == 1:
			second_change_trait = naive_trait
			slf_button_2.text = "Change to \"Naive\""
		else:
			second_change_trait = stoic_trait
			slf_button_2.text = "Change to \"Stoic\""
	elif personality_types[1] == 2:
		slf_lbl_2.text = "Strategic Personality Change\n(100 Gold)"
		second_change_target = 2
		if strategic_trait_optns[0] == 0:
			second_change_trait = crafty_trait
			slf_button_2.text = "Change to \"Crafty\""
		elif strategic_trait_optns[0] == 1:
			second_change_trait = greedy_trait
			slf_button_2.text = "Change to \"Greedy\""
		else:
			second_change_trait = laidback_trait
			slf_button_2.text = "Change to \"Laidback\""
	
	reload_main_label()
	adjust_button_states()

func reload_main_label() -> void:
	var lbl_text: String = "Player Stats:\n\n"
	lbl_text += "Gold: " + str(GlobalSessionManager.run_progress.gold) + "\n\n"
	lbl_text += "Offense: " + GlobalSessionManager.run_progress.personality_data.offensive_trait.name + " (" + str(GlobalSessionManager.run_progress.personality_data.offensive_weight) + ")\n\n"
	lbl_text += "Defense: " + GlobalSessionManager.run_progress.personality_data.defensive_trait.name + " (" + str(GlobalSessionManager.run_progress.personality_data.defensive_weight) + ")\n\n"
	lbl_text += "Strategy: " + GlobalSessionManager.run_progress.personality_data.strategic_trait.name + " (" + str(GlobalSessionManager.run_progress.personality_data.strategic_weight) + ")\n\n"
	slf_main_lbl.text = lbl_text

func adjust_button_states() -> void:
	if GlobalSessionManager.run_progress.gold < 50:
		slf_offense_add.disabled = true
		slf_offense_rem.disabled = true
		slf_defense_add.disabled = true
		slf_defense_rem.disabled = true
		slf_strategic_add.disabled = true
		slf_strategic_rem.disabled = true
		slf_button_1.disabled = true
		slf_button_2.disabled = true
	elif GlobalSessionManager.run_progress.gold < 100:
		slf_button_1.disabled = true
		slf_button_2.disabled = true

func _on_offense_add_pressed() -> void:
	GlobalSessionManager.change_offensive_trait(
		GlobalSessionManager.run_progress.personality_data.offensive_trait,
		clamp(GlobalSessionManager.run_progress.personality_data.offensive_weight + 1, 1, 10)
	)
	slf_offense_add.disabled = true
	slf_offense_rem.disabled = true
	GlobalSessionManager.decrease_gold(50)
	reload_main_label()
	adjust_button_states()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _on_offense_remove_pressed() -> void:
	GlobalSessionManager.change_offensive_trait(
		GlobalSessionManager.run_progress.personality_data.offensive_trait,
		clamp(GlobalSessionManager.run_progress.personality_data.offensive_weight - 1, 1, 10)
	)
	slf_offense_rem.disabled = true
	slf_offense_add.disabled = true
	GlobalSessionManager.decrease_gold(50)
	reload_main_label()
	adjust_button_states()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _on_defense_add_pressed() -> void:
	GlobalSessionManager.change_defensive_trait(
		GlobalSessionManager.run_progress.personality_data.defensive_trait,
		clamp(GlobalSessionManager.run_progress.personality_data.defensive_weight + 1, 1, 10)
	)
	slf_defense_add.disabled = true
	slf_defense_rem.disabled = true
	GlobalSessionManager.decrease_gold(50)
	reload_main_label()
	adjust_button_states()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _on_defense_remove_pressed() -> void:
	GlobalSessionManager.change_defensive_trait(
		GlobalSessionManager.run_progress.personality_data.defensive_trait,
		clamp(GlobalSessionManager.run_progress.personality_data.defensive_weight - 1, 1, 10)
	)
	slf_defense_rem.disabled = true
	slf_defense_add.disabled = true
	GlobalSessionManager.decrease_gold(50)
	reload_main_label()
	adjust_button_states()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _on_strategic_add_pressed() -> void:
	GlobalSessionManager.change_strategic_trait(
		GlobalSessionManager.run_progress.personality_data.strategic_trait,
		clamp(GlobalSessionManager.run_progress.personality_data.strategic_weight + 1, 1, 10)
	)
	slf_strategic_add.disabled = true
	slf_strategic_rem.disabled = true
	GlobalSessionManager.decrease_gold(50)
	reload_main_label()
	adjust_button_states()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _on_strategic_remove_pressed() -> void:
	GlobalSessionManager.change_strategic_trait(
		GlobalSessionManager.run_progress.personality_data.strategic_trait,
		clamp(GlobalSessionManager.run_progress.personality_data.strategic_weight - 1, 1, 10)
	)
	slf_strategic_rem.disabled = true
	slf_strategic_add.disabled = true
	GlobalSessionManager.decrease_gold(50)
	reload_main_label()
	adjust_button_states()

func _on_first_trait_changed() -> void:
	if first_change_target == 0:
		GlobalSessionManager.change_offensive_trait(
			first_change_trait
		)
	else:
		GlobalSessionManager.change_defensive_trait(
			first_change_trait
		)
	slf_button_1.disabled = true
	GlobalSessionManager.decrease_gold(100)
	reload_main_label()
	adjust_button_states()

func _on_second_trait_changed() -> void:
	if second_change_target == 1:
		GlobalSessionManager.change_defensive_trait(
			second_change_trait
		)
	else:
		GlobalSessionManager.change_strategic_trait(
			second_change_trait
		)
	slf_button_2.disabled = true
	GlobalSessionManager.decrease_gold(100)
	reload_main_label()
	adjust_button_states()

func _on_leave_button_pressed() -> void:
	GlobalSessionManager.complete_current_room()
	GlobalSceneLoader.load_scene(GlobalSceneLoader.MAP_SCENE_PATH)

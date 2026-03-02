extends Control
class_name AICharacterGenerator

@export var character_sprite_varients:Array[Texture2D]
@export var name_field:TextEdit
@export var description_field:TextEdit
@onready var create: SelectButton = $Menu1/Create
@onready var menu_1: VBoxContainer = $Menu1
@onready var menu_2: VBoxContainer = $Menu2


func _ready() -> void:
	create.set_disabled(true)

func _on_field_changed() -> void:
	if name_field.text.length() > 0 and description_field.text.length() > 0:
		create.set_disabled(false)
	else:
		create.set_disabled(true)
	pass # Replace with function body.


func build_character_prompt() -> String:
	var char_name := name_field.text.strip_edges()
	var char_desc := description_field.text.strip_edges()
	
	return (
		"You are %s (%s), entering a deadly fate-changing tower.\n\n" +\
		"Return ONLY valid minified JSON:\n" +\
		"{\"backstory\":\"\",\"t1\":0,\"t2\":0,\"t3\":0,\"w1\":1,\"w2\":1,\"w3\":1}\n\n" +\
		"Rules:\n" +\
		"backstory ≤100 chars, vivid motive or mindset for entering.\n" +\
		"t1 offense: 0=brute,1=tactical,2=merciful\n" +\
		"t2 defense: 0=fickle,1=stoic,2=naive\n" +\
		"t3 strategy: 0=greedy,1=laidback,2=crafty\n" +\
		"w1-3 integers 1–10 = importance of t1-3.\n" + \
		"No extra keys. No extra text."
	) % [char_name, char_desc]


func validate_character_json(raw_text: String) -> Dictionary:
	var result := {
		"backstory": "",
		"t1": 0,
		"t2": 0,
		"t3": 0,
		"w1": 1,
		"w2": 1,
		"w3": 1
	}
	
	var json := JSON.new()
	var err := json.parse(raw_text)
	
	if err != OK:
		return result # fallback defaults
	
	var data = json.data
	if typeof(data) != TYPE_DICTIONARY:
		return result
	
	# --- backstory ---
	if data.has("backstory") and typeof(data.backstory) == TYPE_STRING:
		result.backstory = data.backstory.substr(0, 100)
	
	# --- traits ---
	result.t1 = clampi(int(data.get("t1", 0)), 0, 2)
	result.t2 = clampi(int(data.get("t2", 0)), 0, 2)
	result.t3 = clampi(int(data.get("t3", 0)), 0, 2)
	
	# --- weights ---
	result.w1 = clampi(int(data.get("w1", 1)), 1, 10)
	result.w2 = clampi(int(data.get("w2", 1)), 1, 10)
	result.w3 = clampi(int(data.get("w3", 1)), 1, 10)
	
	return result


func get_offensive(trait_id:int) -> OffensiveTrait:
	if trait_id == 0:
		return load("res://PersonalitySystem/PersonalityTraits/Offensive/Brute/brute_offensive_trait.tres")
	if trait_id == 1:
		return load("res://PersonalitySystem/PersonalityTraits/Offensive/Tactical/tactical_trait_data.tres")
	return load("res://PersonalitySystem/PersonalityTraits/Offensive/Merciful/merciful_offensive_trait.tres")

func get_defensive(trait_id:int) -> DefensiveTrait:
	if trait_id == 0:
		return load("res://PersonalitySystem/PersonalityTraits/Defensive/Fickle/fickle_defensive_trait.tres")
	if trait_id == 1:
		return load("res://PersonalitySystem/PersonalityTraits/Defensive/Stoic/stoic_defensive_trait.tres")
	return load("res://PersonalitySystem/PersonalityTraits/Defensive/Naive/naive_defensive_trait.tres")


func get_strategic(trait_id:int) -> StrategicTrait:
	if trait_id == 0:
		return load("res://PersonalitySystem/PersonalityTraits/Strategic/Greedy/greedy_strategic_trait.tres")
	if trait_id == 1:
		return load("res://PersonalitySystem/PersonalityTraits/Strategic/Laidback/laidback_strategic_trait.tres")
	return load("res://PersonalitySystem/PersonalityTraits/Strategic/Crafty/crafty_trait_data.tres")


func _on_create_clicked() -> void:
	menu_1.visible = false
	menu_2.visible = true
	pass


func _initialize_character_from_json(info: Dictionary) -> void:
	var offensive_trait: PersonalityTrait = get_offensive(info.t1)
	var defensive_trait: PersonalityTrait = get_defensive(info.t2)
	var strategic_trait: PersonalityTrait = get_strategic(info.t3)
	
	var personality_data: PersonalityData = PersonalityData.new()
	personality_data.initialize(
		offensive_trait,
		defensive_trait,
		strategic_trait,
		info.w1, # offense weight
		info.w2, # defense weight
		info.w3  # strategy weight
	)
	
	GlobalSessionManager.initialize_new_run(
		character_sprite_varients.pick_random(),
		name_field.text,
		info.backstory,
		personality_data,
		personality_data.get_starting_deck()
	)
	
	GlobalSceneLoader.load_scene(GlobalSceneLoader.MAP_SCENE_PATH)
	pass

func _on_return_clicked() -> void:
	GlobalSceneLoader.load_scene(GlobalSceneLoader.MAIN_MENU_PATH)
	pass # Replace with function body.


func _on_cancel_clicked() -> void:
	menu_1.visible = true
	menu_2.visible = false
	pass # Replace with function body.

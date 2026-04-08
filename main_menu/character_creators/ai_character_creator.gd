extends Control
class_name AICharacterGenerator
## Processes text input fields for character name and description and prompts
## NobodyWho to return a formatted response that can be parsed to initialize
## a new character. Resulting character is shown using character_results.
##
## After character is initialized, the player can start a new run from this scene.

## Character textures used in character generation. One is picked randomly from
## this array. Assign in Inspector.
## TODO: Might the player be able to choose their own character's texture?
@export var character_sprite_varients:Array[Texture2D]

## Menu 1 is the first menu visible when the scene is loaded. In this menu, the
## the player inputs necessary information to generate a character with
@onready var menu_1: Control = $Menu1
@onready var name_field: TextEdit = $Menu1/CharacterInfoFields/NameField/Name
@onready var description_field: TextEdit = $Menu1/CharacterInfoFields/DescriptionField/Description
@onready var create_button: SelectButton = $Menu1/CharacterInfoFields/Create
## Menu 2 is not a menu technically, but a loading screen. Player can abort
## character generation if it is taking too long from this screen
@onready var menu_2: Control = $Menu2
## The last menu shown to the player, following the processing of character
## information.
@onready var character_results: CharacterScreen = $CharacterResult

@onready var chat: NobodyWhoChat = NobodyWhoChat.new()
@onready var model: NobodyWhoModel = NobodyWhoModel.new()

# Fletcher - Added
const SYSTEM_PROMPT: String = """
You are a structured content generator.
"""

# Fletcher - Added
const RESPONSE_GRAMMAR: String = """
root ::= "{\"backstory:\":\"" string ",\"t1\":" threeoption ",\"t2\":" threeoption ",\"t3\":" threeoption ",\"w1\":" tenoption ",\"w2\":" tenoption ",\"w3\":" tenoption "}"
string ::= char*
char ::= [a-z] | [A-Z] | " " | "."
threeoption ::= [0-2]
tenoption ::= [1-9] | 10
"""

func _ready() -> void:
	
	# Fletcher - Added
	model.model_path = "res://AI/Models/Qwen3-4B-Instruct-2507-Q4_K_M.gguf"
	chat.model_node = model
	chat.set_sampler_preset_grammar(RESPONSE_GRAMMAR)
	chat.system_prompt = SYSTEM_PROMPT
	chat.start_worker()
	
	## Player cannot create a new character without first inputting a name and
	## description of character
	create_button.set_disabled(true)


# -------------------------------------------------
# AI Prompting
# -------------------------------------------------
## Return prompt to AI with character name and description parsed. Assumes 
## fields for name and description are fillled
func _build_character_prompt() -> String:
	var char_name:String = name_field.text.strip_edges()
	var char_desc:String = description_field.text.strip_edges()
	
	return (
		"You are " + str(char_name) + "(" + str(char_desc) +\
		")), entering a deadly fate-changing tower.\n\n" +\
		"Return ONLY valid minified JSON:\n" +\
		"{\"backstory\":\"\",\"t1\":0,\"t2\":0,\"t3\":0,\"w1\":1,\"w2\":1,\"w3\":1}\n\n" +\
		"Rules:\n" +\
		"backstory ≤100 chars, vivid motive or mindset for entering.\n" +\
		"t1 offense: 0=brute,1=tactical,2=merciful\n" +\
		"t2 defense: 0=fickle,1=stoic,2=naive\n" +\
		"t3 strategy: 0=greedy,1=laidback,2=crafty\n" +\
		"w1-3 integers 1–10 = importance of t1-3.\n" + \
		"No extra keys. No extra text."
	)


## Tries to convert a string into character info dictionary to use in initializing
## a player character
func _validate_character_string(raw_text: String) -> Dictionary:
	var result:Dictionary = {
		"backstory": "Has an unkown past",
		"t1": 0,
		"t2": 0,
		"t3": 0,
		"w1": 1,
		"w2": 1,
		"w3": 1,
	}
	
	var json := JSON.new()
	var err := json.parse(raw_text)
	
	if err != OK:
		return result
	
	var data = json.data
	if typeof(data) != TYPE_DICTIONARY:
		return result
	
	# --- backstory ---
	if data.has("backstory") and typeof(data.backstory) == TYPE_STRING:
		result["backstory"] = data.backstory.substr(0, 100)
	
	# --- traits ---
	# Trait IDs currently limited to value between 0 - 2
	result["t1"] = clampi( int( data.get( "t1", 0 ) ), 0, 2 )
	result["t2"] = clampi( int( data.get( "t2", 0 ) ), 0, 2 )
	result["t3"] = clampi( int( data.get( "t3", 0 ) ), 0, 2 )
	
	# --- weights ---
	# Trait weights currently limited to value between 1 - 10
	result["w1"] = clampi( int( data.get( "w1", 1 ) ), 1, 10 )
	result["w2"] = clampi( int( data.get( "w2", 1 ) ), 1, 10 )
	result["w3"] = clampi( int( data.get( "w3", 1 ) ), 1, 10 )
	
	return result

# -------------------------------------------------
# Character Building
# -------------------------------------------------
## Given a valid dictionary with character info (ideally from the function above)
## Initialize a new character personality and run of the game.
func _initialize_character_from_json(info: Dictionary) -> void:
	var offensive_trait: PersonalityTrait = get_offensive(info["t1"])
	var defensive_trait: PersonalityTrait = get_defensive(info["t2"])
	var strategic_trait: PersonalityTrait = get_strategic(info["t3"])
	
	var personality_data: PersonalityData = PersonalityData.new(
		offensive_trait,
		defensive_trait,
		strategic_trait,
		"OFFENSIVE"
	)
	#personality_data.initialize(
	#	offensive_trait,
	#	defensive_trait,
	#	strategic_trait,
	#	info["w1"], # offense weight
	#	info["w2"], # defense weight
	#	info["w3"]  # strategy weight
	#)
	
	var data := PlayerInitializationData.new(
			name_field.text,
			info["backstory"],
			character_sprite_varients.pick_random(),
			personality_data,
			personality_data.get_starting_deck()
	)
	GlobalSessionManager.initialize(data)

# -------------------------------------------------
# Character Building Helper Functions
# -------------------------------------------------
# TODO: Look into alternatives to hardcoding trait paths. Otherwise these functions
# can probably be simplified

func get_offensive(trait_id:int) -> PersonalityTrait:
	if trait_id == 0:
		return load("res://PersonalitySystem/PersonalityTraits/Offensive/Brute/brute_offensive_trait.tres")
	if trait_id == 1:
		return load("res://PersonalitySystem/PersonalityTraits/Offensive/Tactical/tactical_offensive_trait_data.tres")
	return load("res://PersonalitySystem/PersonalityTraits/Offensive/Merciful/merciful_offensive_trait.tres")


func get_defensive(trait_id:int) -> PersonalityTrait:
	if trait_id == 0:
		return load("res://PersonalitySystem/PersonalityTraits/Defensive/Fickle/fickle_defensive_trait.tres")
	if trait_id == 1:
		return load("res://PersonalitySystem/PersonalityTraits/Defensive/Stoic/stoic_defensive_trait.tres")
	return load("res://PersonalitySystem/PersonalityTraits/Defensive/Naive/naive_defensive_trait.tres")


func get_strategic(trait_id:int) -> PersonalityTrait:
	if trait_id == 0:
		return load("res://PersonalitySystem/PersonalityTraits/Strategic/Greedy/greedy_strategic_trait.tres")
	if trait_id == 1:
		return load("res://PersonalitySystem/PersonalityTraits/Strategic/Laidback/laidback_strategic_trait.tres")
	return load("res://PersonalitySystem/PersonalityTraits/Strategic/Crafty/crafty_trait_data.tres")


# -------------------------------------------------
# Player input events
# -------------------------------------------------
## Called when input field for name and description is updated.
func _on_field_changed() -> void:
	# Enable create character button only if both input fields have text in
	# in them.
	if name_field.text.length() > 0 and description_field.text.length() > 0:
		create_button.set_disabled(false)
	else:
		create_button.set_disabled(true)
	pass # Replace with function body.


## Create character button
func _on_create_clicked() -> void:
	# Show generating character menu
	menu_1.visible = false
	menu_2.visible = true
	# Aritificial wait added for vibes
	await get_tree().create_timer(1).timeout
	
	var prompt:String = _build_character_prompt()
	
	# TODO: Replace with actual response from NobodyWho using prompt from above.
	# Description field text is being used only for testing json parsing.
	# Once the AI is used, click on description field object in the scene and change
	# its text to be empty.
	chat.ask(prompt) # Fletcher - Added
	var ai_response:String = await chat.response_finished # Fletcher - Moddified
	print(ai_response)
	var character_json:Dictionary = _validate_character_string(ai_response)
	_initialize_character_from_json(character_json)
	
	# Making character result visible. In character result display, the player
	# can view their character's information, cards, and start a run.
	character_results.initialize()
	menu_2.visible = false
	character_results.visible = true


# Returns player to main menu if they wish to leave character generator.
func _on_return_clicked() -> void:
	GlobalSceneLoader.load_scene(GlobalSceneLoader.MAIN_MENU_PATH)
	pass # Replace with function body.


# Called in menu 2 if player wants to cancel character generation after clicking
# create.
func _on_cancel_clicked() -> void:
	menu_1.visible = true
	menu_2.visible = false
	# TODO: If feasable, have AI stop processing when this button is clicked
	pass # Replace with function body.

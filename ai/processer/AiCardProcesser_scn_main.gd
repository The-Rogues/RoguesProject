# --AiCardProcessor Scene Main Script--
# Author: Fletcher Green

#------------------------------------------------------------------------------------
# Section: Declarations
#------------------------------------------------------------------------------------

extends Node
class_name AiCardProcesser

# Get the chat and model children of the processor.
@onready var slf_chat: NobodyWhoChat = $Chat
@onready var slf_model: NobodyWhoModel = $Model

# Change the system prompt used by the model here.
const SYSTEM_PROMPT: String = """
### Definitions
- stdatk: Adds a standard ammount of attack damage to an action.
- stddef: Adds a standard ammount of sheild, which blocks enemy damage, to an action.
- dblatk: Adds a small ammount of attack damage to an action. The action's attack damage is split into two strikes.
- atkall: Adds a small ammount of attack damage to an action. The action's attack damage is applied to all enemies.
"""

# Change the grammar used bu the model here. Currently it returns a string of numbers.
const RESPONSE_GRAMMAR: String = """root ::= ([0-9]+" ")+"""

#------------------------------------------------------------------------------------
# Section: Declarations
#------------------------------------------------------------------------------------

# --_ready Function--
# Description: Initilizes the chat and model children of the AiCardProcessor scene.
# Return: Void.
func _ready() -> void:
	#print("here")
	#slf_model.model_path = OS.get_executable_path().get_base_dir() + "/Llama-3.2-3B-Instruct-Q4_K_M.gguf"
	slf_model.model_path = "res://ai/models/Llama-3.2-3B-Instruct-Q4_K_M.gguf"
	slf_chat.model_node = slf_model
	slf_chat.set_sampler_preset_grammar(RESPONSE_GRAMMAR)
	#slf_chat.system_prompt = SYSTEM_PROMPT
	slf_chat.start_worker() # This may be unnecessary. Do further research.

# --process_card Function--
# Description: Processes an AI card given only the character's personality.
# personality: Personality data containing all three of the character's traits and their weights.
# card_data: CardData resource extended with a list of card options.
# Return: CardData resource that the AI card resolves to.
func process_card(personality: PersonalityData, card_data: AiCardData) -> CardData:
	# Replace system prompt with defs of card components.
	slf_chat.system_prompt = generate_sys_prompt(card_data)
	
	# Generate the prompt to send to the AI.
	var prompt_str: String = generate_prompt(personality, card_data)
	
	# Attempt to get a valid response from the AI twice.
	var response_arr: Array[int]
	slf_chat.reset_context() # All context needed is provided by the current prompt.
	slf_chat.ask(prompt_str)
	var response_str: String = await slf_chat.response_finished
	response_arr = parse_response(response_str, card_data)
	
	# Create the card generation callback from within the AiCardData and return its result.
	var card_generator: RefCounted = card_data.gen_callback.new()
	return card_generator.create_card(card_data, response_arr)

# --generate_prompt Function--
# Description: Generates a prompt to send to the AI. The prompt contains the card options, the player's
#              personality traits, and the personality weights.
# personality: Personality data containing all three of the character's traits and their weights.
# card_data: CardData resource extended with a list of card options.
# Return: A string prompt to give to the AI.
func generate_prompt(personality: PersonalityData, card_data: AiCardData) -> String:
	
	# This section lists the general command and the players personality information.
	var ret_val: String = "### Task:\n"
	ret_val += "Your response will be used to create an action by combining the listed components you choose. Personality data is provided and unique dependent results are expected.\n"
	ret_val += "### Personality Data\n"
	ret_val += "- Offensive Personality: " + personality.offensive_trait.name + "\n"
	ret_val += "- Offensive Personality Weight: " + str(personality.offensive_weight) + "\n"
	ret_val += "- Defensive Personality: " + personality.defensive_trait.name + "\n"
	ret_val += "- Defensive Personality Weight: " + str(personality.defensive_weight) + "\n"
	ret_val += "- Strategic Personality: " + personality.strategic_trait.name + "\n"
	ret_val += "- Strategic Personality Weight: " + str(personality.strategic_weight) + "\n"
	#ret_val += "### Base Option\n"
	#ret_val += "{\"energy\":" + str(card_data.default_option.energy_cost) + ","
	#ret_val += "\"component\":\"" + str(CardGenConst.CardGenNames[card_data.default_option.card_option]) + "\"}\n"
	ret_val += "### Options\n"
	
	# For each card option, list its index, energy cost, and identifier.
	for i in range(0, card_data.ai_options.size()):
		ret_val += "- Option " + str(i) + ": "
		ret_val += "{\"energy\":" + str(card_data.ai_options[i].energy_cost) + ","
		ret_val += "\"component\":\"" + str(CardGenConst.CardGenNames[card_data.ai_options[i].card_option]) + "\"}\n"
	
	# Confirm response format at prompt end.
	ret_val += "### Response Format\n"
	ret_val += "Return only a series of numbers separated by spaces. These numbers should corespond to the options provided. There should be no repeated numbers. Return one, two, or three numbers. The total energy cost of the components chosen must be three or less. Two is the standard cost, but three is common too."
	return ret_val

func generate_sys_prompt(card_data: AiCardData) -> String:
	var ret_val: String = "### Definitions\n"
	var option_types: Array[CardGenConst.CardGenEnum] = []
	option_types.append(card_data.default_option.card_option)
	for i in range(0, card_data.ai_options.size()):
		if !option_types.has(card_data.ai_options[i].card_option):
			option_types.append(card_data.ai_options[i].card_option)
	for i in range(0, option_types.size()):
		ret_val += "- " + str(CardGenConst.CardGenNames[option_types[i]]) + ": "
		ret_val += str(CardGenConst.CardGenDefs[option_types[i]]) + "\n"
	return ret_val

# --parse_response Function--
# Description: Parses a string returned by the AI into an array of integers.
# in_str: The string containing the AI's response.
# card_data: CardData resource to confirm AI response validity.
# Return: An integer array version of the AI's response. An empty array if the response was invalid.
func parse_response(in_str: String, card_data: AiCardData) -> Array[int]:
	
	# For each number, find where it ends and get the substring.
	var ret_val: Array[int] = []
	var first_char: int = 0
	for i in range(0, in_str.length()):
		if in_str[i] == " ":
			ret_val.push_back(in_str.substr(first_char, i - first_char).to_int())
			first_char = i + 1
	
	# If there is not a space at the end of the output as there should be, add the skipped number.
	if first_char != in_str.length():
		ret_val.push_back(in_str.substr(first_char).to_int())
	
	# Define variables for testing response validity.
	var option_size: int = card_data.ai_options.size()
	var found_dict: Dictionary[int, bool] = {}
	var total_cost: int = card_data.default_option.energy_cost
	
	# Initialize dictionary for tracking found array indices.
	for i in range(0, card_data.ai_options.size()):
		found_dict[i] = false
	
	# This for loop checks that every index only appears once and counts the
	# eneergy cost of the card.
	for i in range(0, ret_val.size()):
		if ret_val[i] >= card_data.ai_options.size():
			return []
		total_cost += card_data.ai_options[ret_val[i]].energy_cost
		if found_dict[ret_val[i]]:
			return []
		else:
			found_dict[ret_val[i]] = true
		if ret_val[i] >= option_size:
			return []
	
	# Check that the energy cost of the card is valid.
	if total_cost > 4:
		return []
	return ret_val

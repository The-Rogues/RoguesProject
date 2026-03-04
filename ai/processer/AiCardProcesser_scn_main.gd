extends Node
class_name AiCardProcesser

@onready var slf_chat: NobodyWhoChat = $Chat
@onready var slf_model: NobodyWhoModel = $Model

const SYSTEM_PROMPT := """
### Background
You are a structured contnent generator. You are expected to understand the provided definitions. Additional information will be provided within prompts themselves.
### Definitions
- stdatk: Adds a standard ammount of attack damage to an action.
- stddef: Adds a standard ammount of sheild, which blocks enemy damage, to an action.
- dblatk: Adds a small ammount of attack damage to an action. The action's attack damage is split into two strikes.
- atkall: Adds a small ammount of attack damage to an action. The action's attack damage is applied to all enemies.
"""

const RESPONSE_GRAMMAR := """root ::= ([0-9]+" ")+"""

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	slf_model.model_path = "res://ai/models/Qwen3-4B-Instruct-2507-Q4_K_M.gguf"
	slf_chat.model_node = slf_model
	slf_chat.set_sampler_preset_grammar(RESPONSE_GRAMMAR)
	slf_chat.system_prompt = SYSTEM_PROMPT
	slf_chat.start_worker()

func process_card(personality: PersonalityData, card_data: AiCardData) -> CardData:
	var prompt_str: String = generate_prompt(personality, card_data)
	var response_arr: Array[int]
	for i in range(0, 2):
		slf_chat.reset_context()
		slf_chat.ask(prompt_str)
		var response_str: String = await slf_chat.response_finished
		response_arr = parse_response(response_str, card_data)
		print(response_arr)
		if response_arr.size() != 0:
			break
	var card_generator: RefCounted = card_data.gen_callback.new()
	return card_generator.create_card(card_data, response_arr)


func generate_prompt(personality: PersonalityData, card_data: AiCardData) -> String:
	var ret_val: String = "### Task:\n"
	ret_val += "Your response will be used to create an action by combining the listed components you choose. You will make choices based on the character personality data provided. The total energy cost of the components chosen must be four or less, including the mandatory base option.\n"
	ret_val += "### Personality Data\n"
	ret_val += "- Offensive Personality: Brute\n"
	ret_val += "- Offensive Personality Weight: " + str(personality.offensive_weight) + "\n"
	ret_val += "- Defensive Personality: Cautious\n"
	ret_val += "- Defensive Personality Weight: " + str(personality.defensive_weight) + "\n"
	ret_val += "- Strategic Personality: Greedy\n"
	ret_val += "- Strategic Personality Weight: " + str(personality.strategic_weight) + "\n"
	ret_val += "### Base Option\n"
	ret_val += "{\"energy\":" + str(card_data.default_option.energy_cost) + ","
	ret_val += "\"component\":\"" + str(CardGenConst.CardGenMap[card_data.default_option.card_option]) + "\"}\n"
	ret_val += "### Choice Options\n"
	for i in range(0, card_data.ai_options.size()):
		ret_val += "- Option " + str(i) + ": "
		ret_val += "{\"energy\":" + str(card_data.ai_options[i].energy_cost) + ","
		ret_val += "\"component\":\"" + str(CardGenConst.CardGenMap[card_data.ai_options[i].card_option]) + "\"}\n"
	ret_val += "### Response Format\n"
	ret_val += "Return only a series of numbers separated by spaces. These numbers should corespond to the choice options. There should be no repeated numbers. Return one, two, or three numbers."
	return ret_val

func parse_response(in_str: String, card_data: AiCardData) -> Array[int]:
	var ret_val: Array[int] = []
	var first_char: int = 0
	for i in range(0, in_str.length()):
		if in_str[i] == " ":
			ret_val.push_back(in_str.substr(first_char, i - first_char).to_int())
			first_char = i + 1
	
	if first_char != in_str.length():
		ret_val.push_back(in_str.substr(first_char).to_int())
	
	var option_size: int = card_data.ai_options.size()
	var found_dict: Dictionary[int, bool] = {}
	var total_cost: int = card_data.default_option.energy_cost
	for i in range(0, card_data.ai_options.size()):
		found_dict[i] = false
	for i in range(0, ret_val.size()):
		total_cost += card_data.ai_options[ret_val[i]].energy_cost
		if found_dict[ret_val[i]]:
			return []
		else:
			found_dict[ret_val[i]] = true
		if ret_val[i] >= option_size:
			return []
	
	if total_cost > 4:
		return []
	
	return ret_val

# --Inventive Attack Card Generation Script--
# Author: Fletcher Green

extends RefCounted

func create_card(card_data: AiCardData, ai_selection: Array[int]) -> CardData:
	
	# Define variables to assist in combining card components.
	var total_energy: int = 0
	var is_offense: bool = false
	var is_defense: bool = false
	var is_random: bool = false
	var is_error: bool = false
	
	# If invalid input was received, add stats for the safety card.
	if ai_selection.size() == 0:
		is_random = true
		is_error = true
		total_energy += 1
	
	# Loop over the AI's selection and merge the associated components into helper variables.
	for i in range(0, ai_selection.size()):
		
		# Get the action at the specified index and add its energy cost.
		var curr_action: CardGenConst.CardGenEnum = card_data.ai_options[ai_selection[i]].card_option
		total_energy += card_data.ai_options[ai_selection[i]].energy_cost
		
		# Update helper variables based on what the action is.
		if curr_action == CardGenConst.CardGenEnum.stdatk:
			is_offense = true
		elif curr_action == CardGenConst.CardGenEnum.stddef:
			is_defense = true
		elif curr_action == CardGenConst.CardGenEnum.random:
			is_random = true
	
	if total_energy < 0:
		is_error = true
	
	# This is the CardData that will be returned.
	var ret_val: CardData = CardData.new()
	ret_val.energy_cost = total_energy
	ret_val.exhaust_after_play = true
	
	# This is the battle move that will be used with the card data.
	#var ret_move: BattleMove = BattleMove.new()
	
	# Generate the name and description for the card.
	ret_val.name = "Innovative Gadget"
	ret_val.description = "Place"
	if is_error && is_random:
		ret_val.description += " [color=#43A047]2[/color] \"Blast Cannon\" objects randomly."
	elif is_error: 
		ret_val.description += " a \"Blast Cannon\" in the front postion."
	elif is_offense && is_defense && is_random:
		ret_val.description += " [color=#43A047]2[/color] \"Spiked Shield\" objects randomly."
	elif is_offense && is_defense:
		ret_val.description += " a \"Spiked Shield\" in the front postion."
	elif is_offense && is_random:
		ret_val.description += " [color=#43A047]2[/color] \"Acurate Cannon\" objects randomly."
	elif is_offense:
		ret_val.description += " an \"Acurate Cannon\" in the front postion."
	elif is_defense && is_random:
		ret_val.description += " [color=#43A047]2[/color] \"Crafted Wall\" objects randomly."
	else:
		ret_val.description += " a \"Crafted Wall\" in the front postion."
	ret_val.description += " [color=orange]Single use.[/color]"
	
	var target_action: Action
	if is_error && is_random:
		target_action = load("res://ai/ai-cards/inventive_creation/supporting_resources/random_place_blast.tres")
	elif is_error: 
		target_action = load("res://ai/ai-cards/inventive_creation/supporting_resources/place_blast_action.tres")
	elif is_offense && is_defense && is_random:
		target_action = load("res://ai/ai-cards/inventive_creation/supporting_resources/random_place_shield.tres")
	elif is_offense && is_defense:
		target_action = load("res://ai/ai-cards/inventive_creation/supporting_resources/place_shield_action.tres")
	elif is_offense && is_random:
		target_action = load("res://ai/ai-cards/inventive_creation/supporting_resources/random_place_cannon.tres")
	elif is_offense:
		target_action = load("res://ai/ai-cards/inventive_creation/supporting_resources/place_cannon_action.tres")
	elif is_defense && is_random:
		target_action = load("res://ai/ai-cards/inventive_creation/supporting_resources/random_place_wall.tres")
	else:
		target_action = load("res://ai/ai-cards/inventive_creation/supporting_resources/place_wall_action.tres")
	
	if is_random:
		ret_val.play_actions.append(target_action)
	ret_val.play_actions.append(target_action)
	
	# Add the battle move to the card data and return.
	# ret_val.move = ret_move
	return ret_val

# --Inventive Attack Card Generation Script--
# Author: Fletcher Green

extends RefCounted

func create_card(card_data: AiCardData, ai_selection: Array[int]) -> CardData:
	# Define variables to assist in combining card components.
	var total_moves: int = 1
	var total_energy: int = -1
	var bullet_time: bool = false
	var next_energy: bool = false
	
	# If invalid input was received, add stats for the safety card.
	if ai_selection.size() == 0:
		total_moves += 3
		bullet_time = true
		total_energy += 2
	
	# Loop over the AI's selection and merge the associated components into helper variables.
	for i in range(0, ai_selection.size()):
		# Get the action at the specified index and add its energy cost.
		var curr_action: CardGenConst.CardGenEnum = card_data.ai_options[ai_selection[i]].card_option
		total_energy += card_data.ai_options[ai_selection[i]].energy_cost
		
		# Update helper variables based on what the action is.
		if curr_action == CardGenConst.CardGenEnum.moveone:
			total_moves += 1
		elif curr_action == CardGenConst.CardGenEnum.bullettime:
			bullet_time = true
		elif curr_action == CardGenConst.CardGenEnum.nextenergy:
			next_energy = true
	
	if total_energy < 0:
		total_moves += 1
		bullet_time = true
		total_energy = 0
	
	# This is the CardData that will be returned.
	var ret_val: CardData = CardData.new()
	ret_val.type = CardData.Type.ATTACK
	ret_val.category = CardData.Category.TRAITLESS
	ret_val.energy_cost = total_energy
	ret_val.name = "Creative Move"
	
	# This is the battle move that will be used with the card data.
	#var ret_move: BattleMove = BattleMove.new()
	
	# Generate the description for the card.
	if bullet_time:
		if total_moves == 1:
			ret_val.description = "Add [color=#43A047]1[/color] \"Dash\" card to your hand."
		else:
			ret_val.description = "Add [color=#43A047]" + str(total_moves) + "[/color] \"Dash\" cards to your hand."
	else:
		if total_moves == 1:
			ret_val.description = "Move toward prefered object."
		else:
			ret_val.description = "Move [color=#43A047]" + str(total_moves) + "[/color] spaces toward prefered object."
	if next_energy:
		ret_val.description += " Gain [color=#43A047]1[/color] energy next turn."
	
	if bullet_time:
		for i in range(0, total_moves):
			ret_val.play_actions.append(load("res://ai/ai-cards/creative_move/add_dash_action.tres"))
			ret_val.play_actions.append(load("res://ai/ai-cards/creative_move/draw_dash_action.tres"))
	else:
		var pref_move_action: MoveTowardPreferrenceAction = MoveTowardPreferrenceAction.new()
		pref_move_action.num_spaces = total_moves
		ret_val.play_actions.append(pref_move_action)
	if next_energy:
		ret_val.play_actions.append(load("res://ai/ai-cards/creative_move/next_energy_action.tres"))
	
	# Add the battle move to the card data and return.
	# ret_val.move = ret_move
	return ret_val

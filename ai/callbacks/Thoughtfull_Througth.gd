# --Inventive Attack Card Generation Script--
# Author: Fletcher Green

extends RefCounted

func create_card(card_data: AiCardData, ai_selection: Array[int]) -> CardData:
	
	# Define variables to assist in combining card components.
	var total_atk: int = 7
	var total_energy: int = 0
	var add_def: bool = false
	var dbl_atk: bool = false
	var atk_all: bool = false
	
	# If invalid input was received, add stats for the safety card.
	if ai_selection.size() == 0:
		total_atk += 8
		total_energy += 1
	
	# Loop over the AI's selection and merge the associated components into helper variables.
	for i in range(0, ai_selection.size()):
		
		# Get the action at the specified index and add its energy cost.
		var curr_action: CardGenConst.CardGenEnum = card_data.ai_options[ai_selection[i]].card_option
		total_energy += card_data.ai_options[ai_selection[i]].energy_cost
		
		# Update helper variables based on what the action is.
		if curr_action == CardGenConst.CardGenEnum.stdatk:
			total_atk += 6
		elif curr_action == CardGenConst.CardGenEnum.stddef:
			add_def = true
		elif curr_action == CardGenConst.CardGenEnum.dblatk:
			dbl_atk = true
			total_atk += 2
		elif curr_action == CardGenConst.CardGenEnum.atkall:
			atk_all = true
			total_atk += 2
	
	# This is the CardData that will be returned.
	var ret_val: CardData = CardData.new()
	ret_val.energy_cost = total_energy
	
	# This is the battle move that will be used with the card data.
	#var ret_move: BattleMove = BattleMove.new()
	
	# Generate the name and description for the card.
	ret_val.name = "Thoughtfull Throw"
	ret_val.description = "Ranged Attack "
	if dbl_atk && atk_all:
		ret_val.description += "all enemies for " + str(total_atk / 2) + ", twice."
	elif dbl_atk: 
		ret_val.description += "an enemy for " + str(total_atk / 2) + ", twice."
	elif atk_all:
		ret_val.description += "all enemies for " + str(total_atk) + "."
	else:
		ret_val.description += "an enemy for " + str(total_atk) + "."
	if add_def:
		ret_val.description += "Gain 6 block."
	
	# Generate the attack action component of the card.
	var atk_action: AttackAction = AttackAction.new()
	if dbl_atk:
		atk_action.base_damage = total_atk / 2
		atk_action.hits = 2
		atk_action.target_option = TargetedAction.TargetOption.ENEMY
	else:
		atk_action.base_damage = total_atk
		atk_action.hits = 1
		atk_action.target_option = TargetedAction.TargetOption.ENEMY
	if atk_all:
		atk_action.target_option = TargetedAction.TargetOption.ENEMIES
	
	# Add a second action if the defensive option was selected.
	ret_val.play_actions.append(atk_action)
	if add_def:
		var def_action := BlockAction.new()
		def_action.amount = 6
		ret_val.play_actions.append(def_action)
	
	# Add the battle move to the card data and return.
	# ret_val.move = ret_move
	return ret_val

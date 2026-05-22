# --Inventive Attack Card Generation Script--
# Author: Fletcher Green

extends RefCounted
signal generation_error

func create_card(card_data: AiCardData, ai_selection: Array[int]) -> CardData:
	# Define variables to assist in combining card components.
	var total_atk: int = 12
	var total_energy: int = 0
	var add_strength: bool = false
	var dbl_atk: bool = false
	var atk_all: bool = false
	
	# If invalid input was received, add stats for the safety card.
	if ai_selection.size() == 0:
		total_atk += 16
		total_energy += 1
		generation_error.emit()
	
	# Loop over the AI's selection and merge the associated components into helper variables.
	for i in range(0, ai_selection.size()):
		# Get the action at the specified index and add its energy cost.
		var curr_action: CardGenConst.CardGenEnum = card_data.ai_options[ai_selection[i]].card_option
		total_energy += card_data.ai_options[ai_selection[i]].energy_cost
		
		# Update helper variables based on what the action is.
		if curr_action == CardGenConst.CardGenEnum.stdatk:
			total_atk += 12
		elif curr_action == CardGenConst.CardGenEnum.strength:
			add_strength = true
		elif curr_action == CardGenConst.CardGenEnum.dblatk:
			dbl_atk = true
			total_atk += 6
		elif curr_action == CardGenConst.CardGenEnum.atkall:
			atk_all = true
			total_atk += 6
	
	if total_energy < 0:
		total_atk += 16
		total_energy = 0
	
	# This is the CardData that will be returned.
	var ret_val: CardData = CardData.new()
	ret_val.type = CardData.Type.ATTACK
	ret_val.category = CardData.Category.TRAITLESS
	ret_val.energy_cost = total_energy
	ret_val.name = "Inventive Strike"
	
	# This is the battle move that will be used with the card data.
	#var ret_move: BattleMove = BattleMove.new()
	
	# Generate the description for the card.
	ret_val.description = "Attack "
	if dbl_atk && atk_all:
		ret_val.description += "all enemies for [color=red]get_atk" + str(total_atk / 2) + "[/color], twice."
	elif dbl_atk: 
		ret_val.description += "an enemy for [color=red]get_atk" + str(total_atk / 2) + "[/color], twice."
	elif atk_all:
		ret_val.description += "all enemies for [color=red]get_atk" + str(total_atk) + "[/color]."
	else:
		ret_val.description += "an enemy for [color=red]get_atk" + str(total_atk) + "[/color]."
	if add_strength:
		ret_val.description += " Gain [color=#43A047]3[/color] strength."
	
	# Generate the attack action component of the card.
	var atk_action: AttackAction = AttackAction.new()
	atk_action.ignore_foreground = false
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
	if add_strength:
		var strength_action: ApplyStatusAction = load("res://ai/ai-cards/inventive_strike/inventive_strike_strength.tres")
		ret_val.play_actions.append(strength_action)
	
	# Add the battle move to the card data and return.
	# ret_val.move = ret_move
	return ret_val

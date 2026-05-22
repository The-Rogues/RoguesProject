# --Inventive Attack Card Generation Script--
# Author: Fletcher Green

extends RefCounted
signal generation_error

func create_card(card_data: AiCardData, ai_selection: Array[int]) -> CardData:
	# Define variables to assist in combining card components.
	var total_def: int = 8
	var total_energy: int = 0
	var add_toughness: bool = false
	var armor_convert: bool = false
	
	# If invalid input was received, add stats for the safety card.
	if ai_selection.size() == 0:
		total_def += 12
		total_energy += 1
		generation_error.emit()
	
	# Loop over the AI's selection and merge the associated components into helper variables.
	for i in range(0, ai_selection.size()):
		# Get the action at the specified index and add its energy cost.
		var curr_action: CardGenConst.CardGenEnum = card_data.ai_options[ai_selection[i]].card_option
		total_energy += card_data.ai_options[ai_selection[i]].energy_cost
		
		# Update helper variables based on what the action is.
		if curr_action == CardGenConst.CardGenEnum.stddef:
			total_def += 10
		elif curr_action == CardGenConst.CardGenEnum.toughness:
			add_toughness = true
		elif curr_action == CardGenConst.CardGenEnum.armor:
			armor_convert = true
	
	if total_energy < 0:
		total_def += 12
		total_energy = 0
	
	# This is the CardData that will be returned.
	var ret_val: CardData = CardData.new()
	ret_val.type = CardData.Type.SKILL
	ret_val.category = CardData.Category.TRAITLESS
	ret_val.energy_cost = total_energy
	ret_val.name = "Inventive Defend"
	
	if armor_convert:
		total_def /= 3
		if (total_def % 2) == 1:
			total_def += 1
		else:
			total_def += 2
	
	# Generate the description for the card.
	ret_val.description = "Gain "
	if armor_convert && add_toughness:
		ret_val.description += "[color=#43A047]" + str(total_def) + "[/color] [color=orange]armor[/color]. Gain [color=#43A047]2[/color] [color=orange]armored[/color]."
	elif armor_convert: 
		ret_val.description += "[color=#43A047]" + str(total_def) + "[/color] [color=orange]armor[/color]."
	elif add_toughness:
		ret_val.description += "[color=deep_sky_blue]" + str(total_def) + "[/color] block. Gain [color=#43A047]2[/color] [color=orange]armored[/color]."
	else:
		ret_val.description += "[color=deep_sky_blue]" + str(total_def) + "[/color] block."
	
	var first_action: Action
	if armor_convert:
		first_action = ApplyStatusAction.new()
		first_action.effect = StatusEffectConfig.new()
		first_action.effect.behaviour = ArmorEffect.new()
		first_action.effect.stack = total_def
		first_action.effect.duration = -1
		first_action.effect.turn_entered = false
		first_action.target_option = TargetedAction.TargetOption.SELF
		first_action.ignore_foreground = true
	else:
		first_action = BlockAction.new()
		first_action.amount = total_def
		first_action.target_option = TargetedAction.TargetOption.SELF
		first_action.ignore_foreground = true
	
	# Add a second action if the defensive option was selected.
	ret_val.play_actions.append(first_action)
	if add_toughness:
		var toughness_action: ApplyStatusAction = load("res://ai/ai-cards/inventive_defend/inventive_defend_toughness.tres")
		ret_val.play_actions.append(toughness_action)
	
	# Add the battle move to the card data and return.
	# ret_val.move = ret_move
	return ret_val

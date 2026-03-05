extends RefCounted

func create_card(card_data: AiCardData, ai_selection: Array[int]) -> CardData:
	var total_atk: int = 6
	var total_energy: int = 0
	var add_def: bool = false
	var dbl_atk: bool = false
	var atk_all: bool = false
	
	if ai_selection.size() == 0:
		total_atk += 8
		total_energy += 1
	
	for i in range(0, ai_selection.size()):
		var curr_action: CardGenConst.CardGenEnum = card_data.ai_options[ai_selection[i]].card_option
		total_energy += card_data.ai_options[ai_selection[i]].energy_cost
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
	
	var ret_val: CardData = CardData.new()
	ret_val.energy_cost = total_energy
	
	var ret_move: BattleMove = BattleMove.new()
	ret_move.name = "Inventive Strike"
	ret_move.description = "Attack "
	if dbl_atk && atk_all:
		ret_move.description += "all enemies for " + str(total_atk / 2) + ", twice."
	elif dbl_atk: 
		ret_move.description += "an enemy for " + str(total_atk / 2) + ", twice."
	elif atk_all:
		ret_move.description += "all enemies for " + str(total_atk) + "."
	else:
		ret_move.description += "an enemy for " + str(total_atk) + "."
	if add_def:
		ret_move.description += "Gain 6 block."
	
	var atk_action: AttackAction = AttackAction.new()
	
	if dbl_atk:
		atk_action.base_damage = total_atk / 2
		atk_action.hits = 2
		atk_action.targeting = TargetedBattleAction.TargetingOption.ENEMY
	else:
		atk_action.base_damage = total_atk
		atk_action.hits = 1
		atk_action.targeting = TargetedBattleAction.TargetingOption.ENEMY
	
	if atk_all:
		atk_action.targeting = TargetedBattleAction.TargetingOption.ALL_ENEMIES
	
	ret_move.actions.append(atk_action)
	if add_def:
		var def_action: SkillAction = SkillAction.new()
		def_action.effect = SkillAction.SkillEffect.BLOCK
		def_action.amount = 6
		ret_move.actions.append(def_action)
	
	ret_val.move = ret_move
	return ret_val

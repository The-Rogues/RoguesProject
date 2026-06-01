# --Inventive Attack Card Generation Script--
# Author: Fletcher Green

extends RefCounted

func create_card(card_data: AiCardData, ai_selection: Array[int]) -> CardData:
	
	# Define variables to assist in combining card components.
	var total_atk: int = 6
	var total_energy: int = 0
	var total_burn: int = 0
	var atk_all: bool = false
	
	# If invalid input was received, add stats for the safety card.
	if ai_selection.size() == 0:
		atk_all = true
		total_atk += 4
	
	# Loop over the AI's selection and merge the associated components into helper variables.
	for i in range(0, ai_selection.size()):
		
		# Get the action at the specified index and add its energy cost.
		var curr_action: CardGenConst.CardGenEnum = card_data.ai_options[ai_selection[i]].card_option
		total_energy += card_data.ai_options[ai_selection[i]].energy_cost
		
		# Update helper variables based on what the action is.
		if curr_action == CardGenConst.CardGenEnum.stdatk:
			total_atk += 6
		elif curr_action == CardGenConst.CardGenEnum.atkall:
			atk_all = true
			total_atk += 2
		elif curr_action == CardGenConst.CardGenEnum.burn:
			total_burn += 3
	
	if total_energy < 0:
		total_atk += 10
		total_energy = 0
	
	# This is the CardData that will be returned.
	var ret_val: CardData = CardData.new()
	ret_val.energy_cost = total_energy
	
	# This is the battle move that will be used with the card data.
	#var ret_move: BattleMove = BattleMove.new()
	
	# Generate the name and description for the card.
	ret_val.name = "Thoughtful Shot"
	ret_val.description = "Attack"
	if atk_all:
		ret_val.description += " an enemy for [color=#43A047]" + str(total_atk) + "[/color], twice."
	else: 
		ret_val.description += " an enemy for [color=#43A047]" + str(total_atk) + "[/color]."
	
	if total_burn > 0:
		ret_val.description += " Projectiles apply [color=#43A047]" + str(total_burn) + "[/color] [color=orange]burning[/color]."
	
	var fire_proj_action: ProjectileAttackAction = ProjectileAttackAction.new()
	fire_proj_action.projectile_config = ProjectileFireData.new()
	fire_proj_action.projectile_config.projectile_scene = load("res://ai/ai-cards/invent_ranged/thoughtful_shot_projectile.tscn")
	fire_proj_action.projectile_config.impact_damage = total_atk
	fire_proj_action.ignore_foreground = false
	
	if atk_all:
		fire_proj_action.projectile_config.projectile_count = 2
		fire_proj_action.projectile_config.fire_delay = 0.15
	fire_proj_action.target_option = TargetedAction.TargetOption.ENEMY
	
	if total_burn > 0:
		fire_proj_action.projectile_config.impact_status_effect = StatusEffectConfig.new()
		fire_proj_action.projectile_config.impact_status_effect.behaviour = BurningEffect.new()
		fire_proj_action.projectile_config.impact_status_effect.stack = 0
		fire_proj_action.projectile_config.impact_status_effect.duration = total_burn
		fire_proj_action.projectile_config.impact_status_effect.turn_entered = true
	
	ret_val.play_actions.append(fire_proj_action)
	
	# Add the battle move to the card data and return.
	# ret_val.move = ret_move
	ret_val.category = CardData.Category.TRAITLESS
	ret_val.display_texture = load("res://common/art/placeholder/joi3/traitless_texture.tres")
	return ret_val

#author: andy g
# author: andy g
extends AttackAction
class_name JudgmentAction

@export_range(0, 100) var minimum_damage:int = 5
@export_range(0, 100) var damage_per_card:int = 3


func execute(_context:BattleContext = null, _user:AbstractEntity = null):
	var player:PlayerEntity = null
	
	if resolved_targets.size() > 0:
		player = resolved_targets[0] as PlayerEntity
	
	if player:
		base_damage = minimum_damage + (player.cards_played_last_turn * damage_per_card)
	else:
		base_damage = minimum_damage
	
	await super(_context, _user)

#judgement action scales its damage based on how many cards are played during prev turn
# this is intended to punish overly aggresive playstyles
# and make the final boss feel more reactive and strategic

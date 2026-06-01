#author: andy g
extends AttackAction
class_name MirrorAction

@export_range(0, 100) var minimum_damage:int = 5


func execute(_context:BattleContext = null, _user:AbstractEntity = null):
	var player:PlayerEntity = null
	
	for target in resolved_targets:
		if target is PlayerEntity:
			player = target
			break
	
	if player:
		print("Mirroring battle attack damage: ", player.strongest_attack_this_battle)
		base_damage = max(minimum_damage, player.strongest_attack_this_battle)
	else:
		base_damage = minimum_damage
	
	await super(_context, _user)

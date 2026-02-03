extends AtomicAction
class_name BuffAction
enum Amplify_Stat {ATTACK, DEFENSE}
enum Multiplier {X2, X1_5, X1_25}
@export var amplify_stat:Amplify_Stat
@export var multiplier:Multiplier

func execute(battle_info:BattleActionInfo):
	var multiplier_value:float
	var battle_object = battle_info.battle_field.get_object_infront_of_player()
	
	match  multiplier:
		Multiplier.X2:
			multiplier_value = 1.0
			pass
		Multiplier.X1_5:
			multiplier_value = 0.5
			pass
		Multiplier.X1_25:
			multiplier_value = 0.25
			pass
	
	for target in battle_info.targets:
		if battle_object:
			battle_object.take_damage(0, battle_info.user)
			
			if battle_object.blocks_attacker(battle_info.user):
				await battle_object.entity_animator.animation_finished
				return
		
		if amplify_stat == Amplify_Stat.ATTACK:
			target.buff_attack(multiplier_value)
		elif amplify_stat == Amplify_Stat.DEFENSE:
			target.buff_defense(multiplier_value)

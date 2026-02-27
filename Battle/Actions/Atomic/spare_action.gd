extends TargetedBattleAction
class_name SpareAction

@export_range(0, 0.9) var added_chance:float = 0

func _execute(battle_instance:BattleManager, _action_user:BattleEntity = null):
	super(battle_instance, _action_user)
	
	for target in targets:
		var spare_chance = 0.1
		spare_chance = min(1, spare_chance + added_chance)
		if target._health.current_health < 20:
			spare_chance = min(1, spare_chance + 0.3)
		
		if _action_user == battle_instance.player_entity and \
				battle_instance.character_personality.offensive_trait.id == "merciful":
			spare_chance = min(1, spare_chance + 0.1)
		#Todo: Check if target is pacified in emotion system
		
		spare_chance -= target.data.spare_resistence
		
		if randf() <= spare_chance:
			target.spare()

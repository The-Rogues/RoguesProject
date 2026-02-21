extends PersonalityTrait
class_name DefensiveTrait
## Resource that defines traits for [Personality] class, it's behavioural
## properties, and display information
##
## Intended to be used as a creatable asset in the file system that is
## assigned to the personality trait member values of [Personality]

enum TriggerType {NEVER, ON_ATTACKED, LOW_HEALTH, HIGH_HEALTH}
@export var defense_reaction_trigger:TriggerType
@export var attack_response:BattleMove

func process_damage(battle_instance:BattleManager):
	if not attack_response:
		return
	
	match defense_reaction_trigger:
		TriggerType.ON_ATTACKED:
			battle_instance._execute_battle_move(
				attack_response,
				battle_instance.player_entity
			)
		TriggerType.LOW_HEALTH:
			if battle_instance.player_entity._health.current_health < 15:
				battle_instance._execute_battle_move(
					attack_response,
					battle_instance.player_entity
				)
		TriggerType.HIGH_HEALTH:
			if battle_instance.player_entity._health.current_health > 60:
				battle_instance._execute_battle_move(
					attack_response,
					battle_instance.player_entity
				)
	pass

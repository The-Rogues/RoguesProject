# Author: Fabian

# Updates enemy icons to display enemy intent and context

extends EntityBehaviour
class_name OnTurnRegenerateHealth

const REGENERATE_STATUS_EFFECT = preload("res://BattleSystem/StatusEffects/Regenerating/regenerating_status_effect_data.tres")
@export var health:int

func initialize(new_entity:Entity):
	# Return if behaviour is not attached to a BattleEntity with EnemyData
	if !new_entity is BattleEntity:
		return
	
	super(new_entity)
	# Call function when entity data is initalized
	entity_instance.entered_new_turn.connect(_on_new_turn_started)

func _on_new_turn_started():
	entity_instance.add_status(REGENERATE_STATUS_EFFECT, 2, health)

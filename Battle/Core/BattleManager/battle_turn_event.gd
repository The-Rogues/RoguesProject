@abstract
extends Resource
class_name BattleTurnEvent

signal event_ended(battle_event:BattleTurnEvent)

var battle_instance:BattleManager

const FLOATING_NUMBERS = preload(
		"res://General/UI/DamageNumbers/floating_numbers.tscn"
)

func display_floating_numbers(text:String, parent):
	if !battle_instance:
		return
	
	var new_pop_text = FLOATING_NUMBERS.instantiate()
	parent.add_child(new_pop_text)
	
	new_pop_text.initialize(text, Color.DIM_GRAY)

func initialize(
		new_battle_instance:BattleManager, 
		user:BattleEntity = null
) -> void:
	battle_instance = new_battle_instance

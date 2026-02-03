# BattleInfo likely exists for a brief moment to provide targeting information
# to atomic actions
# Thus a resource is not necessary as this data only needs to be seen once
extends RefCounted
class_name BattleActionInfo

var user:BattleEntity
var targets:Array[BattleEntity]
# action_queue and bus are passed to avoid globals
var action_queue:ActionQueue
#var animation_bus:AnimationBus
var battle_field:BattleField
# Constructor
func _init(
			new_user:BattleEntity,
			new_targets:Array[BattleEntity], 
			new_action_queue:ActionQueue,
			#new_animation_bus:AnimationBus,
			new_battle_field:BattleField
			) -> void:
		user = new_user
		targets = new_targets
		action_queue = new_action_queue
		#animation_bus = new_animation_bus
		battle_field = new_battle_field

func get_player():
	return battle_field.player_entity

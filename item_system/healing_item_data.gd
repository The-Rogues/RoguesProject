# ==========================================================
# Author: Fabian 
# Description:
#   An editable resource that stores display and behaviour script
#   of a unique type of item.
#   To be used as a creatable standalone asset in editor.
#
# ==========================================================

extends ItemData
class_name HealingItemData

@export var heal_amount:int = 5

# Override
func use_item(_player:PlayerEntity = null) -> bool:
	var run := GlobalSessionManager.run_progress
	
	if !run:
		return false
	
	if _player:
		_player.health.heal(heal_amount)
	else:
		run.player_data.set_health(
			run.player_data.current_health + heal_amount,
			run.player_data.max_health)
	
	return true

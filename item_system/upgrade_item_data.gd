# ==========================================================
# Author: Fabian 
# Description:
#   An editable resource that stores display and behaviour script
#   of a unique type of item.
#   To be used as a creatable standalone asset in editor.
#
# ==========================================================

extends ItemData
class_name UpgradeItemData

enum UpgradeType {MAX_HEALTH, MAX_ENERGY, ITEM_CAPACITY}
@export var upgrade:UpgradeType
@export_range(1,999) var amount:int = 1

# Override
func use_item(_player:PlayerEntity = null) -> bool:
	var run := GlobalSessionManager.run_progress
	
	if run == null:
		return false
	
	match upgrade:
		UpgradeType.MAX_HEALTH:
			if _player:
				_player.health.set_values(
						_player.health.value,
						_player.health.max_value + amount)
			else:
				run.player_data.set_health(
					run.player_data.current_health,
					run.player_data.max_health + amount)
		UpgradeType.MAX_ENERGY:
			if _player:
				_player.energy.set_energy(
						_player.energy.value,
						_player.energy.max_value + amount)
			else:
				run.player_data.set_energy(
						run.player_data.current_energy,
						run.player_data.max_energy + amount)
		UpgradeType.ITEM_CAPACITY:
			run.player_data.set_item_capacity(
				run.player_data.item_capacity + amount)
	
	return true

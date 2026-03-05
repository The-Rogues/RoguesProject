# ==========================================================
# Author: Fabian 
# Description:
#   An editable resource that stores display and behaviour script
#   of a unique type of item.
#   To be used as a creatable standalone asset in editor.
#
# ==========================================================

extends ItemData
class_name UpgradeCharacterItemData

enum UpgradeType {MAX_HEALTH, MAX_ENERGY, ITEM_CAPACITY}
@export var upgrade:UpgradeType
@export_range(1,999) var increase:int = 1

# Override
func use_item(_battle_instance:BattleManager = null) -> void:
	if upgrade == UpgradeType.MAX_HEALTH:
		if _battle_instance:
			_battle_instance.player_entity.increase_max_health(increase)
			GlobalSessionManager.increase_max_health(
					_battle_instance.player_entity._health.current_health
			)
		else:
			GlobalSessionManager.increase_max_energy(
				GlobalSessionManager.run_progress.current_health + increase
			)
	elif upgrade == UpgradeType.MAX_ENERGY:
		GlobalSessionManager.increase_max_energy(increase)
		if _battle_instance:
			_battle_instance.energy_counter.initialize(GlobalSessionManager.run_progress.max_energy)
	elif upgrade == UpgradeType.ITEM_CAPACITY:
		GlobalSessionManager.increase_item_capacity()
	pass

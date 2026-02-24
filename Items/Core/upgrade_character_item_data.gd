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
func _use_item(entity: BattleEntity, battle:BattleManager = null) -> void:
	var current_max:int = 0
	if upgrade == UpgradeType.MAX_HEALTH:
		entity.increase_max_health(increase)
		GlobalSessionManager.increase_max_health(entity._health.current_health)
	elif upgrade == UpgradeType.MAX_ENERGY:
		current_max = entity.entity_data.energy.max_value
		entity.entity_data.energy.max_value = current_max + increase
		battle.energy_counter.initialize(entity.entity_data.energy.max_value)
		GlobalSessionManager.upgrade_energy(increase)
	elif upgrade == UpgradeType.ITEM_CAPACITY:
		#update UI
		GlobalSessionManager.upgrade_item_capacity()
	pass

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

@export var health:int = 5

# Override
func _use_item(entity: BattleEntity, battle:BattleManager = null) -> void:
	print("item named: " + name + " was used")
	entity.heal(health)
	pass

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
func use_item(_battle_instance:BattleManager = null) -> void:
	if _battle_instance:
		_battle_instance.player_entity.heal(health)
		GlobalSessionManager.save_character_health(
				_battle_instance.player_entity._health.current_health
		)
	pass

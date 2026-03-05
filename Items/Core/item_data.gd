# ==========================================================
# Author: Fabian 
# Description:
#   An editable resource that stores display and behaviour script
#   of a unique type of item.
#   To be used as a creatable standalone asset in editor. Currently only the
#   player can use items.
#
# ==========================================================

extends Resource
class_name ItemData

# ActivationType is to be read by another script that interprets
# its different values
# Instant is meant to execute as soon as the use button on ItemSlotUI is clicked
# Drag on Enemy is meant to call a signal that makes a drag and drop interface
# appear that allows the player to select a living enemy
# Drag on Object is similar except it highlights empty battle positions to drag
# and release on
enum ActivationType {INSTANT, DRAG_ON_ENEMY, DRAG_ON_OBJECT_POSITION}
# Used by ItemShopData to determine the likely hood of items appearing in the shop
enum Rarity {COMMON, UNCOMMON, RARE}
@export var rarity:Rarity
@export var activation_type:ActivationType
@export var name:String
@export_multiline var description:String
@export var display_texture:Texture
@export var usable_out_of_battle:bool = false
# TODO: Replace with a dedicated behaviour script that can send and recieve signals
# from and too the batte scene it originated in
#@export var behaviour:Script
# TODO: Add sales price field and make is half of shop price by default
@export var shop_price:int = 100
@export var sell_price:int = 50
# Override
func use_item(_battle_instance:BattleManager = null) -> void:
	print(name + " was used")
	pass

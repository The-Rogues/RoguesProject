# ==========================================================
# Author: Fabian 
# Description:
#   An editable resource that stores display and behaviour script
#   of a unique type of item.
#   To be used as a creatable standalone asset in editor.
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
enum ActivationType {NONE, INSTANT, DragOnEnemy, DragOnObjectPosition}
# Used by ItemShopData to determine the likely hood of items appearing in the shop
enum Rarity {COMMON, UNCOMMON, RARE}
@export var name:String
@export_multiline var description:String
@export var activation_type:ActivationType
@export var display_texture:Texture
# TODO: Replace with a dedicated behaviour script that can send and recieve signals
# from and too the batte scene it originated in
@export var behaviour:Script
@export var rarity:Rarity
# TODO: Add sales price field and make is half of shop price by default
@export var shop_price:int = 100

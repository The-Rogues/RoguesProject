extends Resource
class_name ItemData

enum ActivationType {NONE, INSTANT, DragOnEnemy, DragOnObjectPosition}
enum Rarity {COMMON, UNCOMMON, RARE}
@export var name:String
@export_multiline var description:String
@export var activation_type:ActivationType
@export var display_texture:Texture
@export var behaviour:Script
@export var rarity:Rarity
@export var shop_price:int = 100

extends Resource
class_name EnemyMove

enum Type {PHYSICAL, SPECIAL}
@export var name: String
@export_multiline var description_text:String
@export var icon:Texture2D
@export var action_type:Type
@export var actions:Array[CombatMove]

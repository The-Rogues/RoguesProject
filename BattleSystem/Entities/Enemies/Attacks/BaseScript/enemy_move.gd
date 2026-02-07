extends Resource
class_name EnemyMove

enum Type {ATTACK, SABOTAGE, SPECIAL_MOVE, SPECIAL_ATTACK}
@export var name: String
@export_multiline var description_text:String
@export var icon:Texture2D
@export var action_type:Type
@export var actions:Array[CombatMove]

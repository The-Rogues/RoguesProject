extends Resource
class_name MonsterSaveData

@export var monster_data: MonsterData = null
@export var current_health: int = 0
@export var max_health: int = 0
@export var move_index: int = 0
@export var move_sequence: MoveSequence = null 
@export var intent: EnemyMove = null

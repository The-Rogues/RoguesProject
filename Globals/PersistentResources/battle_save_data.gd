extends Resource
class_name BattleSaveData

@export var is_active: bool = false
@export var resume_node_index: int = 0
@export var enemies: Array[EnemySnapshot] = []
@export var player_hp : int = 100
@export var object_layout: BattleObjectLayout = null
@export var object_states : Array[BattleObjectState] = []

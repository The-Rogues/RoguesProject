extends Resource
class_name BattleEffectsSaveData

# Player
@export var player_status_effects: Array[StatusEffectSaveData] = []
@export var player_block: int = 0

# Enemies — flattened with count per enemy
@export var enemy_status_effects: Array[StatusEffectSaveData] = []
@export var enemy_effect_counts: Array[int] = []
@export var enemy_blocks: Array[int] = []

# Battlefield
@export var position_effects: Array[PositionEffectSaveData] = []

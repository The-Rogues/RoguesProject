extends Resource
class_name BattleSaveData

@export var is_active: bool = false
@export var resume_node_index: int = 0
@export var battle_config: BattleConfigSaveData = null
@export var enemy_states: Array[MonsterSaveData] = []
@export var object_states: Array[ObjectSaveData] = []
@export var player_position_index: int = 0
@export var draw_pile: Array[CardInstanceSaveData] = []
@export var discard_pile: Array[CardInstanceSaveData] = []
@export var exhaust_pile: Array[CardInstanceSaveData] = []
@export var drawn_pile: Array[CardInstanceSaveData] = []
@export var battle_state: int = 0
@export var effects: BattleEffectsSaveData = null 
@export var player_energy: int = 0
@export var player_max_energy: int = 0
@export var player_bonus_energy: int = 0
@export var pending_rewards: Array[BattleRewardData] = []
@export var enemy_turn_completed = true
@export var battle_won: bool = false

# --Misc Player Tracking Variable Saves--
@export var misc_damage_taken_this_turn: int = 0
@export var misc_damage_taken_last_turn: int = 0
@export var misc_attacked_this_turn: bool = false
@export var misc_attacked_last_turn: bool = false
@export var misc_unused_energy_last_turn: int = 0
@export var misc_cards_played_this_turn: int = 0
@export var misc_cards_played_last_turn: int = 0
@export var misc_strongest_attack_this_battle: int = 0

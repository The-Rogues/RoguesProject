extends AbstractEntityData
class_name ObjectData

enum Role {DEFENSIVE, OFFENSIVE, REWARD}

@export var role:Role = Role.DEFENSIVE
@export var on_turn_entered_actions:Array[BattleAction]
@export var on_hit_actions:Array[BattleAction]
@export var on_destroyed_actions:Array[BattleAction]

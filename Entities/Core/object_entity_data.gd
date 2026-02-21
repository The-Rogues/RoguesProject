extends EntityData
class_name ObjectEntityData
## Resource that defines an object that can spawn or be places on battle positions
## in [BattleField]
##
## Extend this class to add unique behaviours

enum Type {NONE, COVER, TREASURE, WEAPON}
enum AttackFilter {IGNORE, INTERCEPT, BLOCK}
@export var object_type:Type
@export var attack_filter:AttackFilter
@export_range(0.5, 2) var damage_amplifier:float = 1

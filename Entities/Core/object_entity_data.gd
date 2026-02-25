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
@export_group("Projectile")
@export var fire_projectile:bool = false
## Replaces the default projectile texture
@export var projectile_texture:Texture2D
## Toggles whether the projectile sprite will rotate to face it's movement
## direction. Useful for directional projectile textures.
@export var face_direction:bool = false
## Controls the damage that the launched projectile will deal towards a
## targeted entity
@export var impact_damage:int
## Controls the speed that the projectile moves 
@export var speed : float = 400
## Controls the deviation in angular degrees that the projectile will launch
## towards. Set to 0 if you want the projectile to move straight towards the
## targeted entity's position
@export_range(0, 1) var direction_range:float = 0.35
@export var projectile_count:int = 1

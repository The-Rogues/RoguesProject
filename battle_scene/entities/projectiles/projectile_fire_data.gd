extends Resource
class_name ProjectileFireData
## Data container that configures shared properties of Projectile's.
##
## Used by ProjectileLauncher.gd to modify projectiles it fires.
## Author: Fabian.


## Make sure to pass a scene that is of type Projectile.
@export var projectile_scene:PackedScene
## Number of projectiles to fire in a sequence.
@export var projectile_count:int = 1
## Delay time between projectiles that are fired in a sequence.
@export var fire_delay:float = 0.3
## Replaces damage that the projectile will deal on impact. If -1, impact damage
## will be unchanged on the passed projectile scene.
@export_range(-1, 999) var impact_damage:int = -1
## Replaces applied status effect when projectile hits a valid target.
## If Empty, status effects are unchanged on the passed projectile scene.
@export var impact_status_effect:StatusEffectConfig

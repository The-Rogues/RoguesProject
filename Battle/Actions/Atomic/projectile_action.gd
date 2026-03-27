extends TargetedBattleAction
class_name ProjectileAction
## AtomicAction that spawns and launches attack projectiles toward targets.
##
## Instantiates a projectile at the user’s position and launches it either 
## directly at the target or along a randomized angular deviation based on 
## vertical positioning, for each targeted entity.
##
## Projectiles are configured with damage, speed, visual appearance, and
## valid damage targets before being launched.
##
## Projectile handle their own logic for damaging entities

const ATTACK_PROJECTILE = preload(
		"res://Entities/Scenes/AttackProjectile/attack_projectile.tscn"
)

signal finished

## Replaces the default projectile texture
@export var projectile_texture:Texture2D
## Toggles whether the projectile sprite will rotate to face it's movement
## direction. Useful for directional projectile textures.
@export var face_direction:bool = false
## Controls the damage that the launched projectile will deal towards a
## targeted entity
@export var impact_damage:int
## Controls the speed that the projectile moves 
@export var speed: float = 400
## Controls the deviation in angular degrees that the projectile will launch
## towards. Set to 0 if you want the projectile to move straight towards the
## targeted entity's position
@export_range(0, 1) var direction_range:float = 0.35

@export_range(1, 99) var shots:int = 1
enum RepeatTargetMode { LOCK_TARGETS, REROLL_TARGETS }
@export var repeat_mode:RepeatTargetMode = RepeatTargetMode.LOCK_TARGETS
enum HitEffect {
	NONE,
	BLOCK,
	PARRY,
	STATUS,
}

enum DamageTarget {PLAYER, ENEMY}
@export var effect:HitEffect
@export var damages:DamageTarget
@export var effect_amount:int
@export var status:StatusEffectData
@export var stack:int
@export var duration:int
var projectile_count:int = 0

func _execute(battle_instance:BattleManager, _action_user:BattleEntity = null):
	#var locked_targets:Array[BattleEntity] = []
	
	#if repeat_mode == RepeatTargetMode.LOCK_TARGETS:
		#locked_targets = _resolve_target(battle_instance, _action_user)
	
	var action:ProjectileAction = self.duplicate(true)
	if _action_user:
		action = _action_user.get_modified_projectile(self)
	
	for shot in action.shots:
		#var targets := locked_targets if repeat_mode == RepeatTargetMode.LOCK_TARGETS \
		#	else _resolve_target(battle_instance, _action_user)
	
		_fire_projectiles(battle_instance, _action_user, targets, action)
		await _fire_delay(battle_instance)


func _fire_projectiles(
	battle_instance:BattleManager,
	_action_user:BattleEntity,
	targets:Array[Entity],
	projectile_action:ProjectileAction
):
	for target in targets:
		if not target:
			continue
		
		var direction := _calculate_direction(_action_user, target)
		var damage := _calculate_damage(_action_user, projectile_action)
		
		
		var projectile := _spawn_projectile(_action_user, direction, damage)
		projectile.spawn_and_launch(_action_user.global_position, direction)
		projectile_count += 1
		projectile.destroyed.connect(_on_projectile_destoyed)
		await battle_instance.action_delay()


func _calculate_direction(
	user:BattleEntity,
	target:Entity
) -> Vector2:
	var base_direction := user.global_position.direction_to(
		target.global_position
	)
	
	if direction_range <= 0:
		return base_direction
	
	var target_below := target.global_position.y > user.global_position.y
	var min_angle := 0.0
	var max_angle := 0.0
	
	if target_below:
		max_angle = direction_range * PI
	else:
		min_angle = -direction_range * PI
	
	
	return base_direction.rotated(randf_range(min_angle, max_angle))


func _calculate_damage(user:BattleEntity, projectile_action:ProjectileAction) -> int:
	var damage := projectile_action.impact_damage
	damage = user.get_attack_damage(damage)
	return max(damage, 0)


func _spawn_projectile(
	user:BattleEntity,
	direction:Vector2,
	damage:int
) -> AttackProjectile:
	var projectile:AttackProjectile = ATTACK_PROJECTILE.instantiate()
	user.add_child(projectile)
	
	projectile.configure(
		user,
		projectile_texture,
		speed,
		damage,
		face_direction
	)
	
	match effect:
		HitEffect.NONE:
			pass
		HitEffect.BLOCK:
			projectile.effect == AttackProjectile.HitEffect.BLOCK
			projectile.effect_amount = effect_amount
		HitEffect.PARRY:
			projectile.effect == AttackProjectile.HitEffect.PARRY
			projectile.effect_amount = effect_amount
		HitEffect.STATUS:
			projectile.effect == AttackProjectile.HitEffect.STATUS
			projectile.status = status
			projectile.duration = duration
			projectile.stack = stack
	
	return projectile


func _fire_delay(battle_instance:BattleManager):
	# Delay is different so that if multiple entities are targeted, they play
	# damage animations in unison vs sequentially.
	await battle_instance.action_delay()


func _on_projectile_destoyed():
	projectile_count -= 1
	if projectile_count == 0:
		finished.emit()


func get_stack_value(
	battle_instance:BattleManager,
	action_user:BattleEntity,
) -> int:
	var damage := impact_damage
	damage = action_user.get_attack_damage(damage)
	return damage

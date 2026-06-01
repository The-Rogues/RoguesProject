extends AbstractCreature
class_name MonsterEntity

signal fleed(monster: MonsterEntity)
signal spared(monster: MonsterEntity)
signal intent_chosen(intent:EnemyMove)

var data:MonsterData
var intent:EnemyMove = null
var move_sequence:MoveSequence = null
var move_index:int = 0


# Fletcher - This is the targeting that is updated for each individual enemy.
var updated_targeting: Array[MonsterData.AttackTargetingCategory] 


@onready var sprite_2d: HitFlash = $Sprite2D
@onready var intent_icon: IntentIcon = $IntentIcon
@onready var damage_numbers_spawn: Node2D = $DamageNumbersSpawn


const MAX_BONUS_HEALTH = 6


func initialize(_data:MonsterData):
	self.data = _data
	sprite_2d.texture = _data.display_texture
	
	var rand_health = _data.health + randi_range(0, MAX_BONUS_HEALTH)
	
	health.initialize(rand_health, rand_health)
	stat_display.initialize(self)
	intent_icon.initialize(self)
	health.died.connect(on_destroyed)
	projectile_launcher.fired_projectile.connect(_on_projectile_fired)
	
	#health.died.connect(on_destroyed)
	updated_targeting = data.init_targeting.duplicate()
	#projectile_launcher.fired_projectile.connect(_on_projectile_fired)
	add_to_group("Enemies")



func take_damage(amount:int, _attacker = null, _ignore_foreground: bool = false):
	var damage:int = effects.apply_incoming_damage_effects(amount)
	
	if _ignore_foreground || !_object_intercept_attack(damage, _attacker):
		attacker = _attacker
		damage = block.absorb_damage(damage)
		sprite_2d.flash()
		DamageNumber.display_number(damage, damage_numbers_spawn.global_position)
		health.take_damage(damage)
	
		if !_attacker is Projectile:
			effects.on_attacked(_attacker)
	
		if damage > 0:
			if !_attacker is Projectile:
				effects.on_damaged(_attacker, self)
			else:
				effects.on_damaged(null, self)
	
		if _attacker is AbstractEntity:
			_attacker.set_last_attacked_entity(self)
	
		if _attacker is Projectile and _attacker.source is AbstractEntity:
			_attacker.source.set_last_attacked_entity(self)


func on_destroyed():
	intent_icon.resolve()
	sprite_2d.visible = false
	#sprite_2d.flash()
	#await sprite_2d.hit_flash.animation_finished
	sprite_2d.visible = false
	defeated.emit(self)


func enter_turn(_turn_count:int):
	super(_turn_count)
	#turn_entered.emit()



func choose_intent(in_context: BattleContext = null, skip_decision: bool = false):
	if data && !skip_decision:
		data.behaviour.decide_next_action(self, in_context)
	intent_chosen.emit(intent)


func resolve_intent(resolver:ActionResolver):
	if intent:
		await get_tree().create_timer(0.25).timeout
		intent_icon.resolve()
		if intent.type == EnemyMove.Type.ATTACK:
			play_attack_anim()
		resolver.process_actions(intent.get_actions(), self)


func leave_battle(reason:String):
	var safe_zone = global_position + Vector2(0, -300)
	var tween = create_tween()
	tween.tween_property(self, "global_position", safe_zone, 1.0)

	await tween.finished
	
	if health.is_alive:
		reason = reason.to_upper()
		if reason == "FLEE":
			fleed.emit(self)
		elif reason == "SPARED":
			spared.emit(self)
		else:
			health.kill()

func _object_intercept_attack(damage:int, _attacker) -> bool:
	if !_attacker is PlayerEntity:
		return false
	if _attacker is Projectile:
		return false
	
	if _attacker.battle_position.has_object() and _attacker.battle_position.get_object().health.is_alive:
		_attacker.battle_position.get_object().take_damage(damage, _attacker)
		return true
	else:
		return false

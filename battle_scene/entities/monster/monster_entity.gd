extends AbstractCreature
class_name MonsterEntity

signal intent_chosen(intent:EnemyMove)

var data:MonsterData
var intent:EnemyMove = null
var move_sequence:MoveSequence = null
var move_index:int = 0

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



func take_damage(amount:int, _attacker = null):
	attacker = _attacker
	
	var damage:int = effects.apply_incoming_damage_effects(amount)
	damage = block.absorb_damage(damage)
	
	sprite_2d.flash()
	DamageNumber.display_number(damage, damage_numbers_spawn.global_position)
	health.take_damage(amount)
	effects.on_attacked(_attacker)


func on_destroyed():
	intent_icon.resolve()
	sprite_2d.flash()
	await sprite_2d.hit_flash.animation_finished
	sprite_2d.visible = false
	defeated.emit(self)


func enter_turn(_turn_count:int):
	super(_turn_count)


func choose_intent():
	if !data:
		return
	
	data.behaviour.decide_next_action(self)
	intent_chosen.emit(intent)


func resolve_intent(resolver:ActionResolver):
	if intent:
		await intent_icon.resolve()
		if intent.type == EnemyMove.Type.ATTACK:
			play_attack_anim()
		resolver.process_actions(intent.get_actions(), self)

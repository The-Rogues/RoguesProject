extends AbstractCreature
class_name MonsterEntity

signal intent_chosen(intent:BattleAction)
signal defeated(monster:MonsterEntity)

var data:MonsterData
var intent:BattleAction = null
var move_sequence:MoveSequence = null

@onready var sprite_2d: Sprite2D = $Sprite2D
@onready var sprite_flasher: SpriteFlasher = $SpriteFlasher


func initialize(data:MonsterData):
	self.data = data
	health.initialize(data.health, data.health)



func take_damage(amount:int, _attacker = null):
	attacker = _attacker
	health.take_damage(amount)


func on_destroyed():
	sprite_flasher.flash()
	await play_death_anim()
	defeated.emit(self)


func on_turn_entered():
	if !data:
		return
	
	data.behaviour.decide_next_action(self)
	intent_chosen.emit(intent)

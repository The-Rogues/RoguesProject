extends Node

@export var entity:AbstractCreature
@onready var damage_sound: AudioStreamPlayer = %DamageSound
@onready var death_sound: AudioStreamPlayer = %DeathSound
@onready var add_block_sound: AudioStreamPlayer = %AddBlockSound

func _ready() -> void:
	entity.health.damaged.connect(func(_a):
			damage_sound.play())
	
	entity.health.died.connect(func():
		damage_sound.play())
	
	#entity.block.changed.connect(func(_b):
		#if _b > 0:
			#add_block_sound.play())

extends Node

@export var entity:ObjectEntity
@onready var damage_sound: AudioStreamPlayer = %DamageSound
@onready var death_sound: AudioStreamPlayer = %DeathSound
@onready var add_block_sound: AudioStreamPlayer = %AddBlockSound

func _ready() -> void:
	entity.health.damaged.connect(func(_a):
			damage_sound.play())
	
	entity.health.died.connect(func():
		damage_sound.play())

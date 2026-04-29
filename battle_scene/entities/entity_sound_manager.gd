extends Node

@export var entity:AbstractEntity
@onready var damage_sound: AudioStreamPlayer = %DamageSound
@onready var death_sound: AudioStreamPlayer = %DeathSound

func _ready() -> void:
	entity.health.damaged.connect(func(_a):
			damage_sound.play())

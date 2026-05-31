extends Node

@export var item_slot:ItemSlot

@onready var clicked: AudioStreamPlayer = $Clicked
@onready var discard: AudioStreamPlayer = $Discard
@onready var use: AudioStreamPlayer = $Use


func _ready() -> void:
	if item_slot:
		item_slot.used.connect(_on_item_used)
		item_slot.discard.connect(_on_item_discard)
		item_slot.clicked.connect(_on_slot_clicked)


func _on_item_used(index:int, item_slot:ItemSlot):
	if item_slot.item_texture_rect.texture != null:
		use.play()


func _on_item_discard(index:int, item_slot:ItemSlot):
	if item_slot.item_texture_rect.texture != null:
		discard.play()


func _on_slot_clicked(index:int):
	if item_slot.item_texture_rect.texture != null:
		clicked.play()

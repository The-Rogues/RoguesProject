extends Control
class_name CardViewer

const CARD = preload("res://card_system/card.tscn")
@onready var card_conatiner: FlowContainer = $ScrollContainer/CardConatiner
@onready var open_sound: AudioStreamPlayer = %OpenSound
@onready var close_sound: AudioStreamPlayer = %CloseSound

func open():
	open_sound.play()
	visible = true

func display_cards_from_data(cards:Array[CardData]):
	for child in card_conatiner.get_children():
		child.queue_free()
	await get_tree().process_frame
	
	for data in cards:
		var instance = CardInstance.new(data)
		var card:Card = CARD.instantiate()
		card_conatiner.add_child(card)
		card.initialize(instance)


func on_cards_updated(cards:Array[CardInstance]):
	for child in card_conatiner.get_children():
		child.queue_free()
	await get_tree().process_frame
	
	for instance in cards:
		var card:Card = CARD.instantiate()
		card_conatiner.add_child(card)
		card.initialize(instance)


func _on_close_button_up() -> void:
	visible = false
	close_sound.play()

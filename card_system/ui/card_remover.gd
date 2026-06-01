extends Control
class_name CardRemover

signal closed(removed_card:bool)


const CARD = preload("res://card_system/card.tscn")
@onready var card_conatiner: FlowContainer = $ScrollContainer/CardConatiner
@onready var card_remover_confirmation: Control = $CardRemoverConfirmation
@onready var open_sound: AudioStreamPlayer = %OpenSound
@onready var close_sound: AudioStreamPlayer = %CloseSound

func _ready() -> void:
	card_remover_confirmation.confirmed_remove_card.connect(
			func():
				closed.emit(true)
				close())


func open():
	open_sound.play()
	visible = true


func initialize(cards:Array[CardData]):
	for child in card_conatiner.get_children():
		child.queue_free()
	await get_tree().process_frame
	
	for data in cards:
		var instance = CardInstance.new(data)
		var card:Card = CARD.instantiate()
		card_conatiner.add_child(card)
		card.initialize(instance)
		card.clicked.connect(_on_card_selected)
		card.interaction_mode = true


func _on_card_selected(card: Card) -> void:
	open_sound.play()
	card_remover_confirmation.set_card_to_remove(card)
	card_remover_confirmation.visible = true


func _on_cancel_button_up() -> void:
	closed.emit(false)
	close()
	pass # Replace with function body.


func close():
	close_sound.play()
	visible = false

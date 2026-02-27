extends Area2D

@export var card_hand:CardPlayHand
@onready var panel: Panel = $Panel

func _ready() -> void:
	if card_hand:
		card_hand.grabbed_card.connect(_on_card_grabbed)
		card_hand.released_card.connect(_on_card_released)

func _on_area_exited(area: Area2D) -> void:
	#label.visible = false
	pass # Replace with function body.


func _on_area_entered(area: Area2D) -> void:
	#label.visible = true
	pass # Replace with function body.

func _on_card_grabbed():
	panel.visible = true

func _on_card_released():
	panel.visible = false

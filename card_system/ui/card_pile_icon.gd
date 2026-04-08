extends Control

@onready var pile_size_label: Label = $Container/PileSizeLabel


func _on_card_pile_updated(cards:Array[CardInstance]):
	pile_size_label.text = str(cards.size())


func _on_deck_updated(cards:Array[CardData]):
	pile_size_label.text = str(cards.size())

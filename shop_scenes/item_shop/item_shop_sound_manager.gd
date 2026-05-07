extends Node

@export var item_shop_scene: Control
@onready var enter_shop: AudioStreamPlayer = $EnterShop
@onready var transaction_completed: AudioStreamPlayer = $TransactionCompleted
@onready var item_selected: AudioStreamPlayer = $ItemSelected
@onready var failed_to_buy: AudioStreamPlayer = $FailedToBuy


func _ready() -> void:
	enter_shop.play()
	
	item_shop_scene.transaction_completed.connect(
		func():
			transaction_completed.play()
	)
	
	item_shop_scene.item_selected.connect(
		func():
			var ran = randf_range(1, 0.8)
			item_selected.pitch_scale = ran
			item_selected.play()
	)
	
	item_shop_scene.failed_to_buy_item.connect(
		func():
			failed_to_buy.play()
	)
	

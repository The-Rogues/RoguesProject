extends PanelContainer

@onready var v_box_container: VBoxContainer = $MarginContainer/ScrollContainer/VBoxContainer

@export var items:Array[ItemData]
const ITEM_BUTTON = preload("res://testing_and_prototypes/ItemTester/add_item_button.tscn")


func _ready() -> void:
	for item in items:
		var button = ITEM_BUTTON.instantiate()
		v_box_container.add_child(button)
		button.initialize(item)

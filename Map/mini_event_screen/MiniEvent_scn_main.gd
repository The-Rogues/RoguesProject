extends Control

@onready var slf_lbl: Label = $Label
@onready var slf_lbl_2: Label = $Label2
@onready var slf_container: PanelContainer = $PanelContainer

@onready var slf_check: CheckButton = $CheckButton
@onready var slf_confirm: Button = $ConfirmButton
@onready var slf_next: Button = $NextButton

var event_data: EventData

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	
	# Make Parent take up the whole screen.
	anchor_left = 0.0
	anchor_right = 1.0
	anchor_top = 0.0
	anchor_bottom = 1.0
	
	offset_left = 0
	offset_right = 0
	offset_top = 0
	offset_bottom = 0
	
	# Make child take up a fraction of the screen.
	slf_container.anchor_left = 0.25
	slf_container.anchor_right = 0.75
	slf_container.anchor_top = 0.15
	slf_container.anchor_bottom = 0.85
	
	slf_container.offset_left = 0
	slf_container.offset_right = 0
	slf_container.offset_top = 0
	slf_container.offset_bottom = 0

	var black_bg: StyleBoxFlat = StyleBoxFlat.new()
	black_bg.set("bg_color", Color(0.0, 0.0, 0.0, 1.0))
	slf_container.add_theme_stylebox_override("panel", black_bg)
	
	await get_tree().process_frame
	
	slf_lbl.position = Vector2(
		slf_container.position.x + slf_container.size.x * 0.15,
		slf_container.position.y
	)
	slf_lbl.size = Vector2(
		slf_container.size.x * 0.7, 
		slf_container.size.y * 0.2
	)
	slf_lbl_2.position = Vector2(
		slf_container.position.x + slf_container.size.x * 0.15,
		slf_container.position.y + slf_container.size.y * 0.2
	)
	slf_lbl_2.size = Vector2(
		slf_container.size.x * 0.7, 
		slf_container.size.y * 0.3
	)
	slf_next.position = Vector2(
		slf_container.position.x + slf_container.size.x * 0.15,
		slf_container.position.y + slf_container.size.y * 0.75
	)
	slf_next.size = Vector2(
		slf_container.size.x * 0.7, 
		slf_container.size.y * 0.10
	)
	slf_next.pressed.connect(_on_next_button_pressed)

func init_screen(node_data: EventData):
	event_data = node_data
	var gen_button: Control
	if node_data.mini_event.is_toggle:
		slf_check.visible = true
		slf_confirm.disabled = true
		gen_button = slf_check
	else:
		slf_confirm.visible = true
		slf_check.disabled = true
		gen_button = slf_confirm
		slf_confirm.pressed.connect(_on_confirm_button_pressed)
	gen_button.position = Vector2(
		slf_container.position.x + slf_container.size.x * 0.15,
		slf_container.position.y + slf_container.size.y * 0.5
	)
	gen_button.size = Vector2(
		slf_container.size.x * 0.7, 
		slf_container.size.y * 0.10
	)

func _on_confirm_button_pressed() -> void:
	slf_confirm.disabled = true
	var callback: RefCounted = event_data.mini_event.event_callback.new()
	callback.process_event()

func _on_next_button_pressed() -> void:
	if event_data.mini_event.is_toggle:
		if slf_check.button_pressed:
			var mini_callback: RefCounted = event_data.mini_event.event_callback.new()
			mini_callback.process_event()
	queue_free()
	var main_callback: RefCounted = event_data.main_event.event_callback.new()
	main_callback.process_event()

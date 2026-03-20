# --MiniEventScreen Main Scene--
# Author: Fletcher Green

#------------------------------------------------------------------------------------
# Section: Declarations
#------------------------------------------------------------------------------------

extends Control

# Get children nodes.
@onready var slf_lbl: Label = $TitleLbl
@onready var slf_lbl_2: Label = $DescriptionLbl
@onready var slf_container: PanelContainer = $ContentContainer
@onready var slf_check: CheckButton = $CheckButton
@onready var slf_confirm: Button = $ConfirmButton
@onready var slf_next: Button = $NextButton
@onready var slf_image: TextureRect = $Image

# This will store the event data that contains the information for representing a mini event.
var event_data: EventData

#------------------------------------------------------------------------------------
# Section: Functions
#------------------------------------------------------------------------------------

# --_ready Function--
# Description: Sets the anchors for the screen's background content panel. Calls the resize function to size the
#              rest of the content.
# Return: Void.
func _ready() -> void:
	
	# Make Parent control take up the whole screen.
	anchor_left = 0.0
	anchor_right = 1.0
	anchor_top = 0.0
	anchor_bottom = 1.0
	
	offset_left = 0
	offset_right = 0
	offset_top = 0
	offset_bottom = 0
	
	# Make the background panel take up a set portion of the screen.
	slf_container.anchor_left = 0.25
	slf_container.anchor_right = 0.75
	slf_container.anchor_top = 0.15
	slf_container.anchor_bottom = 0.85
	
	slf_container.offset_left = 0
	slf_container.offset_right = 0
	slf_container.offset_top = 0
	slf_container.offset_bottom = 0
	
	# Create black background style for the panel. 
	var black_bg: StyleBoxFlat = StyleBoxFlat.new()
	black_bg.set("bg_color", Color(0.0, 0.0, 0.0, 1.0))
	slf_container.add_theme_stylebox_override("panel", black_bg)
	
	# Wait for the panel to be sized and resize the rest of the content based on its size.
	await get_tree().process_frame
	resize_content()
	get_window().size_changed.connect(
		func():
			resize_content()
	)
	
	# Connect the next button to its callback.
	slf_next.pressed.connect(_on_next_button_pressed)

# --init_screen Function--
# Description: Sets the text and screen's image to the specified mini event data and saves the data for later use.
# node_data: The event data used to initialize the screen.
# Return: Void.
func init_screen(node_data: EventData):
	
	# Set screen text and save event data.
	event_data = node_data
	slf_lbl.text = event_data.mini_event.event_title
	slf_lbl_2.text = event_data.mini_event.event_description
	slf_image.texture = event_data.mini_event.aes_texture
	
	# Initialize the toggle button if that variation is specified.
	var gen_button: Control
	if node_data.mini_event.is_toggle:
		slf_check.visible = true
		slf_confirm.disabled = true
		gen_button = slf_check
	
	# Initialize the normal button if that variation is specified.
	else:
		slf_confirm.visible = true
		slf_check.disabled = true
		gen_button = slf_confirm
		slf_confirm.pressed.connect(_on_confirm_button_pressed)
	
	# Position the specified button correctly.
	gen_button.position = Vector2(
		slf_container.position.x + slf_container.size.x * 0.15,
		slf_container.position.y + slf_container.size.y * 0.7
	)
	gen_button.size = Vector2(
		slf_container.size.x * 0.7, 
		slf_container.size.y * 0.10
	)

# --resize_content Function--
# Description: Sizes the content of the screen based on the main panel's position.
# Return: Void.
func resize_content() -> void:
	
	# Position the title label.
	slf_lbl.position = Vector2(
		slf_container.position.x + slf_container.size.x * 0.15,
		slf_container.position.y
	)
	slf_lbl.size = Vector2(
		slf_container.size.x * 0.7, 
		slf_container.size.y * 0.2
	)
	
	# Position the description label.
	slf_lbl_2.position = Vector2(
		slf_container.position.x + slf_container.size.x * 0.15,
		slf_container.position.y + slf_container.size.y * 0.2
	)
	slf_lbl_2.size = Vector2(
		slf_container.size.x * 0.7, 
		slf_container.size.y * 0.2
	)
	
	# Position the next button.
	slf_next.position = Vector2(
		slf_container.position.x + slf_container.size.x * 0.15,
		slf_container.position.y + slf_container.size.y * 0.85
	)
	slf_next.size = Vector2(
		slf_container.size.x * 0.7, 
		slf_container.size.y * 0.10
	)
	
	# Position the event's image.
	slf_image.position = Vector2(
		slf_container.position.x + slf_container.size.x * 0.15,
		slf_container.position.y + slf_container.size.y * 0.40
	)
	slf_image.size = Vector2(
		slf_container.size.x * 0.7, 
		slf_container.size.y * 0.3
	)
	
	# Execute if event data is initialized.
	if event_data != null:
		
		# Select the correct button type.
		var gen_button: Control
		if event_data.mini_event.is_toggle:
			gen_button = slf_check
		else:
			gen_button = slf_confirm
		
		# Position the button.
		gen_button.position = Vector2(
			slf_container.position.x + slf_container.size.x * 0.15,
			slf_container.position.y + slf_container.size.y * 0.7
		)
		gen_button.size = Vector2(
			slf_container.size.x * 0.7, 
			slf_container.size.y * 0.10
		)

# --resize_content Function--
# Description: Executes the callback associated with the mini event when the confirm button is pressed.
# Return: Void.
func _on_confirm_button_pressed() -> void:
	
	# Disable the button, initialize the callback script, and execute the callback.
	slf_confirm.disabled = true
	var callback: RefCounted = event_data.mini_event.event_callback.new()
	callback.process_event()

# --resize_content Function--
# Description: Executes the callback associated with the mini event if the button type is toggle.
#              Loads the next scene.
# Return: Void.
func _on_next_button_pressed() -> void:
	
	# Execute the mini event callback if the event type is toggle.
	if event_data.mini_event.is_toggle:
		if slf_check.button_pressed:
			var mini_callback: RefCounted = event_data.mini_event.event_callback.new()
			mini_callback.process_event()
	
	# Free the screen.
	queue_free()
	
	# Load the next scene.
	var main_callback: RefCounted = event_data.main_event.event_callback.new()
	main_callback.process_event()

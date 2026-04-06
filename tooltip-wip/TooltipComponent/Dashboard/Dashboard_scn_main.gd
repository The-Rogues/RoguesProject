# --Dashboard Classs Script--
# Author: Fletcher Green

#------------------------------------------------------------------------------------
# Section: Declarations
#------------------------------------------------------------------------------------

extends Control

@onready var dash_container: HBoxContainer = $DashContainer # HBoxContainer that holds dashboard items.
@onready var dash_background: ColorRect = $DashBackground # Color rectangle that is the bachground of the dashboard.
@onready var dash_expand: Button # Button that is created on the left side of the dashboard.

#------------------------------------------------------------------------------------
# Section: init_dash Function
#------------------------------------------------------------------------------------

# --init_dash Function Description--
# Description: Creates a dashboard containing an image, title, and button that can later be connected to.
# Return: Void.
func init_dash(
	in_image: CompressedTexture2D, # The image to display on the left side of the dashboard.
	in_title: String, # The title to display in the center of the dashboard.
	in_width: int, # The width of the dashboard.
	in_margin: int, # The size of the margin separating the elements of the dashboard.
	bg_col: Color, # The color of the dsahboard's background.
	button_col_1: Color, # The color of the button's unpressed state.
	button_col_2: Color # The color of the button's pressed state.
) -> void:
	
	# Initialize the dimentions of the dashboard using the given width.
	size = Vector2(in_width, in_width * 0.2)
	custom_minimum_size = Vector2(in_width, in_width * 0.2)
	z_index = 0
	
	# Size HBoxContainer child and set its sepatation to zero.
	dash_container.size = Vector2(in_width, in_width * 0.2)
	dash_container.custom_minimum_size = Vector2(in_width, in_width * 0.2)
	dash_container.add_theme_constant_override("separation", 0)
	dash_container.z_index = 0
	
	# Sixe the container background and ignore when it receives mouse input.
	dash_background.size = Vector2(in_width, in_width * 0.2)
	dash_background.custom_minimum_size = Vector2(in_width, in_width * 0.2)
	dash_background.z_index = 0
	dash_background.mouse_filter = Control.MOUSE_FILTER_IGNORE
	dash_background.color = bg_col
	
	# --Image Initialization--
	# Description: Add a margin container to the HBoxContainer child. Make the dashboard image a child of that container.
	#              The image inherits its size from the margin container. The margin container is a square based on the input width.
	var image_container: MarginContainer = MarginContainer.new()
	image_container.size = Vector2(in_width * 0.2, in_width * 0.2)
	image_container.custom_minimum_size = Vector2(in_width * 0.2, in_width * 0.2)
	image_container.z_index = 1
	
	# Set margins.
	image_container.add_theme_constant_override("margin_left", in_margin)
	image_container.add_theme_constant_override("margin_right", in_margin / 2)
	image_container.add_theme_constant_override("margin_top", in_margin)
	image_container.add_theme_constant_override("margin_bottom", in_margin)
	
	# Create image child.
	var image_rect: TextureRect = TextureRect.new()
	image_rect.texture = in_image
	
	# Add children.
	image_container.add_child(image_rect)
	dash_container.add_child(image_container)
	
	# --Title Initialization--
	# Description: Add a margin container to the HBoxContainer child. Make the title label a child of that container.
	#              The title inherits its size from the margin container. The margin container is a rectangle based on the input width.
	var title_container: MarginContainer = MarginContainer.new()
	title_container.size = Vector2(in_width * 0.6, in_width * 0.2)
	title_container.custom_minimum_size = Vector2(in_width * 0.6, in_width * 0.2)
	title_container.z_index = 1
	
	# Set margins.
	title_container.add_theme_constant_override("margin_left", in_margin / 2)
	title_container.add_theme_constant_override("margin_right", in_margin / 2)
	title_container.add_theme_constant_override("margin_top", in_margin)
	title_container.add_theme_constant_override("margin_bottom", in_margin)
	
	# Create title label.
	var title_lbl: Label = Label.new()
	title_lbl.add_theme_font_override("font", load("res://General/Fonts/dungeon-mode.ttf")) # load font.
	title_lbl.add_theme_font_size_override("font_size", (in_width * 0.2) / 3.5) # Change font size.
	title_lbl.text = in_title
	title_lbl.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	title_lbl.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	title_lbl.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	
	# Add children.
	title_container.add_child(title_lbl)
	dash_container.add_child(title_container)
	
	# --Button Initialization--
	# Description: Add a margin container to the HBoxContainer child. Make the button a child of that container.
	#              The button inherits its size from the margin container. The margin container is a square based on the input width.
	var button_container: MarginContainer = MarginContainer.new()
	button_container.size = Vector2(in_width * 0.2, in_width * 0.2)
	button_container.custom_minimum_size = Vector2(in_width * 0.2, in_width * 0.2)
	button_container.z_index = 1
	
	# Set margins.
	button_container.add_theme_constant_override("margin_left", in_margin / 2)
	button_container.add_theme_constant_override("margin_right", in_margin)
	button_container.add_theme_constant_override("margin_top", in_margin)
	button_container.add_theme_constant_override("margin_bottom", in_margin)
	
	# Create button and set properties.
	dash_expand = Button.new()
	dash_expand.text = "..."
	dash_expand.add_theme_font_override("font", load("res://General/Fonts/dungeon-mode.ttf"))
	dash_expand.add_theme_font_size_override("font_size", (in_width * 0.2) / 5)
	dash_expand.toggle_mode = true
	
	# Create styles for coloring the button.
	var style := StyleBoxFlat.new()
	style.bg_color = button_col_1
	var style_2 := StyleBoxFlat.new()
	style_2.bg_color = button_col_2
	
	# Set margins.
	dash_expand.add_theme_stylebox_override("normal", style)
	dash_expand.add_theme_stylebox_override("hover", style)
	dash_expand.add_theme_stylebox_override("pressed", style_2)
	dash_expand.add_theme_stylebox_override("hover_pressed", style_2)
	
	# Add children.
	button_container.add_child(dash_expand)
	dash_container.add_child(button_container)

#------------------------------------------------------------------------------------
# Section: Other Functions
#------------------------------------------------------------------------------------

# --add_callback Function--
# Description: Attaches a callback function to the dashboard's button.
# in_call: A callable that will be called whenever the dashboard's button is pressed.
# Return: Void.
func add_callback(in_call: Callable) -> void:
	dash_expand.pressed.connect(
		func():
			in_call.call(dash_expand.button_pressed)
	)

# --get_height Function--
# Description: Returns the height of the dashboard.
# Return: And integer representing the height of the dashboard in pixels. 
func get_height() -> int:
	return dash_container.custom_minimum_size.y

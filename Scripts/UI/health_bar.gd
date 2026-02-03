extends ProgressBar
class_name HealthBar

@export var health_stat:Stat
@onready var difference_bar: ProgressBar = $DifferenceBar
@onready var difference_timer: Timer = $Timer
@onready var health_label: Label = $CenterContainer/HealthLabel
@export var display_numbers: bool = true
@export var debug_force_initialize:bool = false

func initialize(new_health_stat:Stat):
	difference_bar = $DifferenceBar
	health_label = $CenterContainer/HealthLabel
	health_stat = new_health_stat
	max_value = health_stat.max_value
	value = health_stat.value
	difference_bar.max_value = health_stat.max_value
	difference_bar.value = health_stat.value
	
	if health_label:
		health_label.text = str(int(value)) + "/" + str(int(max_value))
	
	health_label.visible = display_numbers
	health_stat.value_changed.connect(update_health_bar)

func _ready() -> void:
	if debug_force_initialize:
		initialize(health_stat)

func update_health_bar(new_value:float):
	value = new_value
	if health_label:
		health_label.text = str(int(value)) + "/" + str(int(max_value))
	difference_timer.start()

func _on_timer_timeout() -> void:
	difference_bar.value = value
	pass # Replace with function body.

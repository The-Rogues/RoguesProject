extends ProgressBar
class_name HealthBar

@onready var difference_bar: ProgressBar = $DifferenceBar
@onready var difference_timer: Timer = $Timer
@onready var health_label: Label = $CenterContainer/HealthLabel
@export var display_numbers: bool = true


func initialize(health:Health):
	difference_bar = $DifferenceBar
	health_label = $CenterContainer/HealthLabel
	
	max_value = health.max_value
	value = health.value
	difference_bar.max_value = max_value
	difference_bar.value = value
	
	health_label.text = str(int(value)) + "/" + str(int(max_value))
	health.health_changed.connect(_on_health_changed)


func _on_health_changed(current:int, max:int):
	value = current
	if health_label:
		health_label.text = str(int(value)) + "/" + str(int(max))
	difference_timer.start()


func _on_timer_timeout() -> void:
	difference_bar.value = value
	pass # Replace with function body.

extends Button

const ATTACK_PROJECTILE = preload("res://BattleSystem/Entities/Enemies/Attacks/Projectiles/Boulder/attack_projectile.tscn")
@onready var entity: BattleEntity = $"../Entity"

func _on_button_up() -> void:
	var projectile = ATTACK_PROJECTILE.instantiate()
	add_child(projectile)
	print(global_position.direction_to(entity.global_position))
	projectile.spawn_and_launch(global_position, global_position.direction_to(entity.global_position))
	
	pass # Replace with function body.

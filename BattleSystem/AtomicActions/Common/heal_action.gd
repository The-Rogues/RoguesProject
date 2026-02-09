extends AtomicAction
class_name HealAction
## Atomic action that restores the health of targeted battle entities
## 
## Targets are healed by a configurable amount. All entities handle
## their own healing logic

## Controls the amount of health a targeted entity will recieve
@export var health:int = 0

# TODO: Creating a timer on the tree for pausing execution isn't reccomended
# in most cases. Consider having damage response time stored locally in 
# entity class
func execute(action_context:ActionContext):
	for target in action_context.targets:
		
		target.heal(health)
		await target.get_tree().create_timer(0.15).timeout

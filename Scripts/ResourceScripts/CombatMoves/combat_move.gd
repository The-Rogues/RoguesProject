# Wrapper to allow for changing targets per actions
extends Resource
class_name CombatMove

# Targeting is data only
@export var targeting:TargetingEnum.TARGETING
# The grouped atomic actions to perform
@export var actions: Array[AtomicAction]

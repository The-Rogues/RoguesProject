extends AbstractEntityData
class_name ObjectData

enum Role {DEFENSIVE, OFFENSIVE, REWARD, DECOY}
enum InteractionOption {NONE, ON_HIT, BUTTON, BUTTON_WITH_KEY}

@export var role:Role = Role.DEFENSIVE
@export var interaction:InteractionOption
@export var interaction_actions:Array[Action]
# Behaviour scripts

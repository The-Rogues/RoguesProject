# Author: Fabian

# Used to execute logic on entities when signals are emitted
# Example use: When entity emits defeated signal, spawn particle A
# Must be implemented in a child class
@abstract
extends Resource
class_name EntityBehaviour

# Stores entity that this behaviour resource tracks
var entity_instance:Entity
# Add additional variables as needed in child classes

# Override to connect specific signals of entity
func initialize(new_entity:Entity):
	# Always include this somewhere in override implementations
	entity_instance = new_entity

# Add additional functions as needed in child classes

extends Resource
class_name TargetingEnum

# Created to allow for global access without being a global
# Treated as a data type

enum TARGETING {
	SELF,
	PLAYER,
	ENEMY,
	ENEMIES,
	NONE,
	# TODO: LOCATION or other future targeting types
}

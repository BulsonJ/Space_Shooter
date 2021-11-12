extends Resource
class_name Technology

enum effects{
	HEALTH,
	ROF,
	SPEED
	ROTATION_SPEED,
	TURRET_UNLOCK
}
export(String) var technology_name
export(int) var technology_cost
export var technology_effects = {
	effects.TURRET_UNLOCK : "beam"
}


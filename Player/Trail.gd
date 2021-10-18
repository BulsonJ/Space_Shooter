extends Line2D


var length := 20
onready var point = get_parent().global_position

# Called when the node enters the scene tree for the first time.
func _physics_process(_delta: float) -> void:
	global_position = Vector2(0,0)
	global_rotation = 0
	point = get_parent().global_position
	add_point(point)
	while get_point_count()>length:
		remove_point(0)

extends Control

export(NodePath) var space_station_path
onready var space_station = get_node(space_station_path)
onready var turret_manager = space_station.get_node("TurretManager")

onready var turret_control_node = preload("res://UI/TurretControl.tscn")

var placed_control_nodes := [null, null, null]

func _ready() -> void:
	modulate = Color(1, 1, 1, 0)
	visible = false
	for i in turret_manager.turretPoints.size():
		add_turret_control(i)
			
func show_ui(time : float) -> void:
	visible = true
	$Tween.interpolate_property(self, "modulate", 
	  Color(1, 1, 1, 0), Color(1, 1, 1, 1), time)
	$Tween.start()
	
func hide_ui(time : float) -> void:
	visible = false
	$Tween.interpolate_property(self, "modulate", 
	  Color(1, 1, 1, 1), Color(1, 1, 1, 0), time)
	$Tween.start()

func _on_SpaceStation_player_docked(animation_time) -> void:
	show_ui(animation_time)

func _on_SpaceStation_player_undocked(animation_time) -> void:
	hide_ui(animation_time)

func add_turret_control(turret_index : int) -> void:
	var control_node = turret_control_node.instance()
	control_node.get_node("TurretMenuButton").turret_index = turret_index
	
	# Gets middle of turret, applies translation based on rotation
	var vec3_pos : Vector3 = turret_manager.turretPoints[turret_index]
	var pos : Vector2 = Vector2(vec3_pos.x - 16, vec3_pos.y - 16)
	if vec3_pos.z == 0:
		pos = pos + Vector2(16, 0)
	elif vec3_pos.z == 90:
		pos = pos + Vector2(0, 16)
	elif vec3_pos.z == 180:
		pos = pos + Vector2(-16, 0)
	elif vec3_pos.z == -90:
		pos = pos + Vector2(0, -16)
		
	pos = turret_manager.to_global(pos)
	control_node.rect_global_position = pos
	placed_control_nodes[turret_index] = control_node
	add_child(control_node)
	
func remove_turret_control(turret_index : int) -> void:
	if placed_control_nodes[turret_index] == null:
		return
		
	remove_child(placed_control_nodes[turret_index])
	placed_control_nodes[turret_index] = null

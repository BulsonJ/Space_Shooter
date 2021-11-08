extends Control

export(NodePath) var space_station_path
var turret_manager = null

var turret_control_node = preload("res://UI/TurretControl.tscn")

var placed_control_nodes := [null, null, null, null]

export (Resource) var player_currency 

func _ready() -> void:
	modulate = Color(1, 1, 1, 0)
	visible = false
	
func _process(_delta: float) -> void:
	for control_node in placed_control_nodes:
		if control_node != null:
			var vec3_pos : Vector3 = turret_manager.turretPoints[control_node.get_node("TurretMenuButton").turret_index]
			var pos : Vector2 = Vector2(vec3_pos.x - 16, vec3_pos.y - 16)
			if vec3_pos.z == 0:
				pos = pos + Vector2(16, 0)
			elif vec3_pos.z == 90:
				pos = pos + Vector2(0, 16)
			elif vec3_pos.z == 180:
				pos = pos + Vector2(-16, 0)
			elif vec3_pos.z == -90:
				pos = pos + Vector2(0, -16)
			control_node.set_global_position(turret_manager.get_global_transform_with_canvas().origin + pos, false)
			
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
	control_node.get_node("TurretMenuButton").turret_manager = turret_manager
	control_node.get_node("TurretMenuButton").player_currency = player_currency
	
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
	control_node.set_global_position(pos, false)
	placed_control_nodes[turret_index] = control_node
	add_child(control_node)
	
func remove_turret_control(turret_index : int) -> void:
	if placed_control_nodes[turret_index] == null:
		return
		
	remove_child(placed_control_nodes[turret_index])
	placed_control_nodes[turret_index] = null

func _on_SpaceStation_base_ready() -> void:
	turret_manager = get_node(space_station_path).get_node("TurretManager")
	for i in turret_manager.turretPoints.size():
		add_turret_control(i)

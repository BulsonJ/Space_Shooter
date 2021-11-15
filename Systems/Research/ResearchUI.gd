extends Control

var _turret_resources = [
	preload("res://Defence/Resources/cannon_stats.tres"),
	preload("res://Defence/Resources/beam_stats.tres")
]

var turret_dictionary = {
	"cannon" : _turret_resources[0],
	"beam" : _turret_resources[1],
}

var technologies : Array
var researched_technologies : Array

func _ready() -> void:
	for i in $Technologies.get_children():
		i.update_node()
		i.connect("technology_researched", self, "update_nodes")
		technologies.append(i)

func update_nodes(technology_node) -> void:
	researched_technologies.append(technology_node)
	apply_research(technology_node.technology_resource)

	for i in $Technologies.get_children():
		i.update_node()

# Primitive apply research function. Simply modifiers the resources.

func apply_research(technology_resource : Resource) -> void:
	var active_resource : Resource = turret_dictionary[technology_resource.turret_unlock]

	if technology_resource.rof_modifier != 0:
		active_resource.modify_rof(technology_resource.rotation_speed_modifier)
	if technology_resource.rotation_speed_modifier != 0:
		active_resource.modify_rotation_speed(technology_resource.rotation_speed_modifier)
	if technology_resource.health_modifier != 0:
		active_resource.modify_max_health(technology_resource.health_modifier)
	

	
	


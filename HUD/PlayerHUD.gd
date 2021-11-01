extends Control

export(NodePath) var actor_to_follow
onready var actor : KinematicBody2D = get_node(actor_to_follow)

func _process(delta: float) -> void:
	var actor = get_node(actor_to_follow)
	var actor_position = actor.get_global_transform_with_canvas().origin
	
	set_global_position(actor_position, false) 
	

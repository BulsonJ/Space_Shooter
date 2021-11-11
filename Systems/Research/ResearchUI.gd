extends Control

func _ready() -> void:
	for i in $Technologies.get_children():
		i.update_node()
		i.connect("technology_researched", self, "update_nodes")

func update_nodes() -> void:
	for i in $Technologies.get_children():
		i.update_node()



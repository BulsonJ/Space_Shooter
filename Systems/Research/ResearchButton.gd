extends TextureButton

export(Array, NodePath) var prereq
var prereq_nodes := []
var prereq_node_lines := []
export var researched := false
export var researchable := false

signal technology_researched()

func update_node() -> void:
	pressed = researched

	if prereq.size() > 0 && prereq_nodes.size() == 0:
		for i in prereq:
			var node = get_node(i)
			prereq_nodes.append(node)
			var line = Line2D.new()
			line.width = 5
			line.begin_cap_mode = line.LINE_CAP_ROUND
			line.end_cap_mode = line.LINE_CAP_ROUND
			line.points = [rect_global_position + Vector2(16,0), (node.rect_global_position + Vector2(16,32) - rect_global_position) + rect_global_position]
			get_parent().get_parent().get_node("Lines").add_child(line)
			prereq_node_lines.append(line)
	
	var r := true
	var count := 0
	for i in prereq_nodes:
		if i.researched == false:
			r = false
			prereq_node_lines[count].default_color = Color(0.2,0,0,1.0)
		else:
			prereq_node_lines[count].default_color = Color(0.6,0,0,1.0)
		count += 1
	researchable = r
	disabled = !researchable

	#text = researched as String + "," + researchable as String


func _on_research_pressed() -> void:
	researched = !researched
	emit_signal("technology_researched")

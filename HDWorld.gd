extends Node


onready var view_box = $ViewportContainer
onready var sub_viewport = $ViewportContainer/Viewport
onready var screen_res = get_viewport().size

var scaling = Vector2()

func _ready() -> void:
	scaling = screen_res / sub_viewport.size
	view_box.rect_scale = scaling


func _on_SpaceStation_player_docked() -> void:
	view_box.rect_min_size = Vector2(960,540)
	sub_viewport.size = Vector2(960,540)


func _on_SpaceStation_player_undocked() -> void:
	view_box.rect_min_size = Vector2(640,360)
	sub_viewport.size = Vector2(640,360)

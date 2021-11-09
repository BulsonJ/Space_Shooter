extends Control


# Declare member variables here. Examples:
# var a: int = 2
# var b: String = "text"


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta: float) -> void:
#	pass


func _on_wave_starting_timer(time) -> void:
	$WaveStartText.bbcode_text = "[center]Wave starting in: " + str(int(time)) + "[center]"


func _on_wave_start(_wave_number) -> void:
	$WaveStartText.text = ""

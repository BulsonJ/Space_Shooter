extends AnimatedSprite

func _ready():
	play("default")
	rotation_degrees = rand_range(0, 360)

func _on_Enemy_1_DeathEffect_animation_finished():
	if $AudioStreamPlayer2D.playing == false:
		queue_free()

func _on_AudioStreamPlayer2D_finished() -> void:
	if playing == false:
		queue_free()


extends RigidBody2D

export(float) var weapon_damage = 1.0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func _physics_process(delta: float) -> void:
	$Trail.rotation = angular_velocity
	#$Trail.speed_scale = linear_velocity.length() /175

func _on_Bullet_body_entered(body: Node) -> void:
	#queue_free()
	
	# Stop particle, delete bullet once particle lifetime is up
	$Trail.emitting = false
	var time = ($Trail.lifetime * 2) / $Trail.speed_scale
	get_tree().create_timer(time).connect("timeout", self, "queue_free")
	
	# Hide sprite and disable collision so can't be seen while waiting for trail to finish
	$Sprite.visible = false
	$CollisionShape2D.disabled = true
	
	if body.has_method("take_damage"):
			body.take_damage(weapon_damage)

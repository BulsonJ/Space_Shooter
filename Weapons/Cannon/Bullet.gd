extends Area2D

export(float) var weapon_damage = 1.0
export(float) var max_lifetime = 3.0
export(float) var speed = 400.0

onready var lifetime = max_lifetime
onready var particle_trail = $Trail
onready var bullet_fade = $BulletFadeTween
onready var sprite = $Sprite

func _ready() -> void:
	#bullet_fade.interpolate_property($Sprite, "modulate", $Sprite.modulate, Color(1.5,1.5,1.5), lifetime)
	bullet_fade.start()

func _physics_process(delta: float) -> void:
	lifetime -= delta
	
	position += transform.x * speed * delta
	
	if lifetime < 0:
		delete_bullet()

func delete_bullet() -> void:
	# Stop particle, delete bullet once particle lifetime is up
	set_physics_process(false)
	particle_trail.emitting = false
	$Line2D.visible = false
	var time = (particle_trail.lifetime * 2) / particle_trail.speed_scale
	var _err = get_tree().create_timer(time).connect("timeout", self, "queue_free")
	
	# Hide sprite and disable collision so can't be seen while waiting for trail to finish
	$Sprite.visible = false
	$CollisionShape2D.call_deferred("set_disabled", true)

func _on_Bullet_body_entered(body):
	delete_bullet()
	
	if body:
		if body.has_method("take_damage"):
			body.take_damage(weapon_damage)

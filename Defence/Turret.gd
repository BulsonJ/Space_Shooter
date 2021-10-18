class_name Turret
extends StaticBody2D

export(float) var max_health = 5.0
onready var health = max_health setget _set_health

var _target : Enemy = null

enum state{
	FUNCTIONAL,
	REPAIRING,
	DESTROYED
}

var initial_state = state.FUNCTIONAL
onready var current_state = initial_state

onready var animation_player = $AnimationPlayer

signal turret_destroyed()

func _ready() -> void:
	animation_player.play("build")
	
func get_sorted_targets() -> Enemy:
	var possibleTargets = $Turret_Vision.get_overlapping_bodies()
	possibleTargets.sort_custom(self, "_sort_target")
	return possibleTargets

func repair_turret() -> void:
	if health != max_health:
		current_state = state.REPAIRING
		animation_player.play("repair")
	
func _repair_animation_finished() -> void:
	$RepairFX.play()
	current_state = state.FUNCTIONAL
	set_physics_process(true)
	_set_health(max_health)

func take_damage(amount: float) -> void:
	if current_state == state.FUNCTIONAL:
		_set_health(health - amount)
		animation_player.play("hit")
		if health == 0:
			animation_player.queue("destroyed")
			current_state = state.DESTROYED

func _set_health(value) -> void:
	health = clamp(value, 0, max_health)
	if (health == 0):
		current_state = state.DESTROYED
		emit_signal("turret_destroyed")
		
func _on_TargetListTimer_timeout():
	var targets = get_sorted_targets()
	if targets.size() > 0:
		_target = targets.front()
		
# Custom sort function used to sort targets into distance to turret
func _sort_target(a : Enemy,b: Enemy) -> bool:
	if a != null and b != null:
		return a.global_position.distance_to(global_position) < b.global_position.distance_to(global_position)
	else:
		return false

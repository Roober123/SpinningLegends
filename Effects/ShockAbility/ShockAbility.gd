extends Ability

@export var damage : float
@export var knock_power : float
var duration : float
@export var stats_scaling : float = 1.0
func start():
	damage *= stats_scaling
	global_position = parent.global_position
	duration = $GPUParticles3D.lifetime-0.05
	$GPUParticles3D.emitting=true
	$GPUParticles3D2.emitting = true
	await get_tree().create_timer(duration).timeout
	call_deferred('queue_free')


func _on_collision_area_body_entered(body):
	var i = body
	if i is Spinner and i != parent:
			i.take_damage(damage)
			CollisionManager.add_sound(Vector3.ZERO,-3)
			i.velocity += global_position.direction_to(i.global_position) * knock_power

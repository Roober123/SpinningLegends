extends Ability

var stats_scaling : float = 1.0
@export var damage : float = 2500
@export var knock : float = 150

var dir : Vector3
@export var speed : float = 30

var active : Dictionary


func start()->void:
	damage*=stats_scaling
	knock*=stats_scaling
	global_position = parent.global_position + Vector3(4,10,0)
	dir = global_position.direction_to(parent.global_position)

func update(delta : float)->void:
	global_position+=delta*dir*speed
	if is_queued_for_deletion():
		return
	for i in active:
		if i!=null:
			i.velocity += global_position.direction_to(i.global_position) * knock /i.mass * delta
			i.take_damage(damage* delta)
	
func _on_area_3d_body_entered(body):
	$comet.call_deferred('queue_free')
	$Area3D.call_deferred('queue_free')
	$CometExplosion/GPUParticles3D.emitting = true
	$CometExplosion/GPUParticles3D2.emitting = true
	$exparea.set_deferred('monitoring',true)
	await  get_tree().create_timer(1).timeout
	active.clear()
	call_deferred('queue_free')


func _on_exparea_body_entered(body):
	if body is Spinner and body!=parent:
		active[body] = true


func _on_exparea_body_exited(body):
	if body is Spinner and body!=parent:
		active.erase(body)

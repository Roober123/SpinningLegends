extends Ability

@export var damage : float
@export var knock_power : float
var stats_scaling : float = 1.0
var duration : float = 5

var active : Dictionary

func start()->void:
	damage = stats_scaling * damage
	global_position = parent.global_position
	for i in $Beam.get_children():
		i.emitting = true
	$Beam/GPUParticles3D4.emitting=false
	await  get_tree().create_timer(0.1).timeout
	$Beam/GPUParticles3D4.emitting=true
	$Area3D.set_deferred('monitoring',true)
	
	await  get_tree().create_timer(duration-0.1).timeout
	call_deferred('queue_free')

func update(delta : float)->void:
	for i in active:
		if is_instance_valid(i):
			i.take_damage(damage*delta)
			i.velocity += global_position.direction_to(i.global_position) * knock_power / i.mass * delta


func _on_area_3d_body_entered(body):
	var i = body
	if i is Spinner and i != parent:
		active[body]=true


func _on_area_3d_body_exited(body: Node3D) -> void:
	if body is Spinner and body != parent:
		active.erase(body)

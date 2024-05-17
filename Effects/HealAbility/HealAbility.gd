extends Ability

@export var heal_power_ps : float = 50
var stats_scaling : float = 1.0
var parent_inside : bool = false

func _on_area_3d_body_entered(body):
	if body == parent:
		parent_inside = true


func _on_area_3d_body_exited(body):
	if body == parent:
		parent_inside = false

func get_avg_normal()->Vector3:
	var nnrm := Vector3.UP
	var sum_normals : Vector3 = Vector3.ZERO
	var nr : int = 0
	for i in $rays.get_children():
		i.force_raycast_update()
		if i.is_colliding():
			sum_normals+=i.get_collision_normal()
			nr+=1
	sum_normals/=nr
	if sum_normals!=Vector3.ZERO:
		return sum_normals
	return nnrm
	

func start()->void:
	heal_power_ps *= stats_scaling
	global_position = parent.tip.global_position
	
	var nrm : Vector3 = get_avg_normal()
	global_transform.basis.y = nrm
	global_transform.basis.x = -global_transform.basis.z.cross(nrm)
	global_transform.basis=global_transform.basis.orthonormalized()
	$rays.call_deferred('queue_free')
	#	global_transform = ntransf
	$WaveEffect/GPUParticles3D.emitting=true
	$WaveEffect/GPUParticles3D2.emitting=false
	await get_tree().create_timer(0.1).timeout
	$WaveEffect/GPUParticles3D2.emitting=true
	await  get_tree().create_timer(3).timeout
	call_deferred('queue_free')
func _process(delta):
	if parent_inside:
		parent.damage_taken-=heal_power_ps*delta

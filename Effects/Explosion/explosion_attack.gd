extends Node3D


var damage : float
var knock_power : float
var parent : Spinner


func _on_area_3d_body_entered(body):
	if body==parent:
		return
	if body is Spinner:
		body.take_damage(damage)
		body.velocity += global_position.direction_to(body.ring.global_position) * knock_power / body.mass


func _ready():
	$explosion/GPUParticles3D.emitting=true
	$explosion/GPUParticles3D2.emitting=true
	await  get_tree().create_timer(0.2).timeout
	$explosion/GPUParticles3D3.emitting=true
	await  get_tree().create_timer(0.3).timeout
	$Area3D.set_deferred('monitoring',false)
	await $explosion/GPUParticles3D3.finished
	call_deferred('queue_free')

extends Node3D


var parent : Spinner

var start_pos : Vector3
var end_pos :Vector3
var mid_pos : Vector3

var t : float

var speed : float
var damage : float
var knock : float 

var last_vel : Vector3
var reached : bool = false

var exp_att : PackedScene = preload("res://Effects/Explosion/explosion_attack.tscn")



func initialize(pos : Vector3,_rotate_rate : float,sp : float,dmg : float,kn : float)->void:
	start_pos = parent.ring.global_position
	end_pos = pos
	knock = kn
	damage = dmg
	mid_pos = (start_pos + end_pos)/2  + Vector3.UP * start_pos.distance_to(end_pos)/2
	speed = sp/(start_pos.distance_to(mid_pos) + mid_pos.distance_to(end_pos))
	
	await  get_tree().create_timer(0.2).timeout
	$Area3D.set_deferred('monitoring',true)
	$Area3D.set_deferred('monitorable',true)
func _physics_process(delta):
	t=clamp(t+delta*speed,0,1)
	var p2 : Vector3 = global_position.bezier_interpolate(start_pos,mid_pos,end_pos,t)
	if p2.is_equal_approx(global_position)==false and global_position.direction_to(p2).is_equal_approx(Vector3.UP)==false:
		look_at(p2)
	if p2.is_equal_approx(global_position)==false and !reached:
		last_vel = p2 - global_position
		global_position = p2
	else:
		reached = true
		look_at(global_position + last_vel)
		global_position+=last_vel*delta * speed * 3





func _on_area_3d_body_entered(body):
	if body==parent:
		return
	var e : Node3D  = exp_att.instantiate()
	get_parent().add_child(e)
	e.global_position = global_position
	e.knock_power = knock
	e.damage = damage
	call_deferred('queue_free')

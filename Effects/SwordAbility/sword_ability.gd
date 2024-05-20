extends Ability

@export var damage : float
@export var knock_power : float
@export var duration : float = 6.0
@export var rot_speed : float = 30

@onready var sword : Node3D = $sword
@onready var area : Area3D = $Area3D

var stats_scaling : float = 1.0


var active : Dictionary


func start()->void:
	damage *= stats_scaling
	await get_tree().create_timer(duration).timeout
	call_deferred('queue_free')

func smooth_look_at(node : Node3D,vec : Vector3,delta : float)->void:
	node.transform = node.transform.interpolate_with(node.transform.looking_at(global_position+vec),delta * rot_speed)

func _process(delta):
	if is_instance_valid(parent)==false:
		call_deferred('queue_free')
		return
	global_position = parent.ring.center.global_position
	var vv = Vector2(parent.velocity.x,parent.velocity.z).normalized()
	var vec : Vector3 = Vector3(vv.x,0,vv.y).normalized()
	if global_position.is_equal_approx(global_position + vec)==false and global_position.direction_to(global_position + vec).is_equal_approx(Vector3.UP)==false:
		if vec.length()>0.12:
			var t : Transform3D = $sword.global_transform
			t.basis.z = -vec
			t.basis.x = t.basis.y.cross(t.basis.z)
			t.basis=t.basis.orthonormalized()
			sword.global_transform = sword.global_transform.interpolate_with(t,delta*rot_speed)
			area.global_transform = sword.global_transform
		
	for i in active:
		if is_instance_valid(i):
			i.take_damage(damage*delta)
			i.velocity += global_position.direction_to(i.global_position)*knock_power/i.mass*delta


func _on_area_3d_body_entered(body):
	if body == parent:
		return
	if body is Spinner:
		active[body]=true
		body.take_damage(damage)
		body.velocity+=global_position.direction_to(body.global_position)*knock_power/body.mass


func _on_area_3d_body_exited(body: Node3D) -> void:
	if body==parent:
		return
	if body is Spinner:
		active.erase(body)

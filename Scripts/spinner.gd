class_name Spinner
extends CharacterBody3D

var mass : float
var resistance : float
var speed : float
var damage_taken : float
var resistance_offset : float 
var recover_rate : float 


var min_friction : float
var max_friction : float 

var tip : Spinner_Tip
var tip_coll : CollisionShape3D
var ring : Spinner_Ring
var ring_coll : CollisionShape3D
var middle : Spinner_Middle
var middle_coll : CollisionShape3D

var ground_ray : RayCast3D
var last_velocity : Vector3

@export var max_rot_speed : float = 1600

signal Collided()
signal Die()

class effect:
	var time : float
	var property : StringName
	var value_divider : float

var has_effect : Dictionary

func add_efect(time : float,property : StringName,val : float)->void:
	var f : effect
	f.time = time
	f.property = property
	f.value_divider = val
	if has_effect.find_key(f):
		return
	else:
		has_effect[f]=true
		set(property,get(property)/val)
		await  get_tree().create_timer(time).timeout
		has_effect.erase(f)
		set(property,get(property)*val)




func reset()->void:
	if tip == null or middle == null or ring==null:
		return
	set_properties_array_sum(['mass','resistance','speed','recover_rate'],[tip,ring,middle])
	min_friction = min(tip.friction,min(middle.friction,ring.friction))
	max_friction = max(tip.friction,max(middle.friction,ring.friction))
	
	var origin : Vector3 = Vector3.ZERO
	for i : Spinner_part in Array([tip,middle,ring]):
		i.position = origin
		i.coll_shape.position=origin + i.center.position
		origin += i.up_part_origin.position
func set_properties_array_sum(property : Array[StringName],arr : Array)->void:
	if arr.is_empty():
		push_warning('accesing a null part array : ',name)
		return
	for j in property:
		var s = null
		for i in arr:
			if i.get(j):
				if s == null:
					s = i.get(j)
				else:
					s +=i.get(j)
		set(j,s)

func swap_part(type : StringName,x : PackedScene)->void:
	var e = x.instantiate()
	if get(type)!=null:
		get(type).call_deferred('queue_free')
		get(type+'_coll').call_deferred('queue_free')
	set(type,e)
	add_child(e)
	set(type+'_coll',e.coll_shape)
	e.coll_shape.reparent(self)
	reset()

func take_damage(damage : float)->void:
	damage_taken += damage



func Ready()->void:
	add_to_group('Spinners')

func Movement_physics(delta : float)->void:
	for i in movement_queue:
		velocity+=speed*delta*i
	
	movement_queue.clear()
	if !is_on_floor() and tip_coll!=null:
		velocity.y -= 8 * delta
	else:
		velocity.y = 0
	velocity.limit_length(15)
	
	if is_zero_approx(velocity.length())==false:
		var move_vec : Vector2 = Vector2(velocity.x,velocity.z).normalized() * mass * tip.ground_friction * delta 
		velocity -= Vector3(move_vec.x,0,move_vec.y)
		
	for i in get_slide_collision_count():
		var c := get_slide_collision(i)
		for j in c.get_collision_count():
			if c.get_collider(j) is Spinner:
				CollisionManager.resolve(self,c.get_collider(j),c,j) 
	#if ground_ray.is_colliding() :
	#	var nrm : Vector3 = ground_ray.get_collision_normal()
	#	var ntransf : Transform3D = global_transform
	#	ntransf.basis.y = nrm
	#	ntransf.basis.x = -ntransf.basis.z.cross(nrm)
	#	ntransf.basis=ntransf.basis.orthonormalized()
	#	#global_transform = global_transform.interpolate_with(ntransf,10*delta)
	#	global_transform = ntransf
	last_velocity = get_real_velocity()


var movement_queue : Array[Vector3]

func AddVelocityTowards(v : Vector3)->void:
	var dir : Vector2 = Vector2(global_position.x,global_position.z).direction_to(Vector2(v.x,v.z))
	movement_queue.push_back( Vector3(dir.x,0,dir.y))

func Update(delta : float)->void:
	rotation.z = lerp(rotation.z,clamp(-velocity.x*0.2,-0.35,0.35),delta * 2) 
	rotation.x = lerp(rotation.x,clamp(velocity.z*0.2,-0.35,0.35),delta*2)
	
	tip.rotate(Vector3.UP,deg_to_rad(max_rot_speed * (1-damage_taken/resistance)) * delta)
	ring.rotate(Vector3.UP,deg_to_rad(max_rot_speed * (1-damage_taken/resistance)) * delta)
	middle.rotate(Vector3.UP,deg_to_rad(max_rot_speed * (1-damage_taken/resistance)) * delta)

	if damage_taken > resistance - resistance_offset:
		emit_signal('Die')
		call_deferred('queue_free')
	damage_taken = clamp(damage_taken - delta*recover_rate,0,resistance+1000)


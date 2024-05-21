class_name Collision_manager
extends Node

#tip - 0.09m
#ring - 0.08m
#middle -0.04m
#radius 0.2

var contact : PackedScene = preload("res://Effects/Contact/contact_effect.tscn")
var game_folder : Node3D
var arena_center : Vector3 = Vector3(0.421,-0.592,0.812)

var audio_streams : Array[AudioStream]=[preload("res://Resources/hit1.wav"),preload("res://Resources/hit2.wav"),preload("res://Resources/hit3.wav"),preload("res://Resources/hit4.wav")]


func first_eq(m1 : float,m2 : float,v1 : float,v2 : float,e : float)->float:
	return (m1 - e*m2) / (m1+m2) * v1 + (1+e)*m2/(m1+m2) * v2
func second_eq(m1 : float,m2 : float,v1 : float,v2 : float,e : float)->float:
	return (1+e)*m1/(m1+m2)*v1 + (m2-e*m1)/(m1+m2) * v2


var exclusions : Dictionary

var shake_cam : Camera3D
var sound_pl : AudioStreamPlayer3D


const freeze_ticks : float = 0.16
func resolve(part1 : Spinner,part2 : Spinner,coll_data : KinematicCollision3D,coll_nr : int)->void:
	if exclusions.has([part1,part2]):
		return
	exclusions[[part1,part2]] = true
	exclusions[[part2,part1]] = true
	
	var ind : Node3D = contact.instantiate()
	game_folder.add_child(ind)
	ind.global_position = coll_data.get_position(coll_nr)
	var a : Spinner = part1
	var b : Spinner = part2
	
	var e : float = (randf_range(a.min_friction,a.max_friction) + randf_range(b.min_friction,b.max_friction))/2.0
	
	var n : Vector3 = a.global_position.direction_to(b.global_position)
	var meff : float = 1.0/(1.0/a.mass + 1.0/b.mass)
	var vimp : float = n.dot(a.last_velocity-b.last_velocity)
	var j : float = e*meff*vimp
	var v1 : Vector3 = -j/a.mass*n
	var v2 : Vector3 = j/b.mass*n
	
	if shake_cam:
		shake_cam.start_shake(min(j,50)*0.0015,0.12)
	if sound_pl:
		add_sound(coll_data.get_position(coll_nr),0)
	
	a.velocity += v1
	b.velocity += v2
	
	var ang1 : float = clamp(b.last_velocity.normalized().dot(-n),0,1)
	var ang2 : float = clamp(a.last_velocity.normalized().dot(n),0,1)

	a.take_damage(b.last_velocity.length() * ang1 * b.mass)
	b.take_damage(a.last_velocity.length() * ang2 * a.mass)
	
	a.emit_signal('Collided')
	b.emit_signal('Collided')
	
	
	await  get_tree().create_timer(freeze_ticks).timeout
	exclusions.erase([part1,part2])
	exclusions.erase([part2,part1])

func add_contact(pos : Vector3)->void:
	var ind : Node3D = contact.instantiate()
	game_folder.add_child(ind)
	ind.global_position = pos


func add_sound(p : Vector3,intesity : float)->void:
	if !sound_pl:
		return
	if sound_pl.playing==true:
		return
	sound_pl.global_position = p
	sound_pl.stream=audio_streams.pick_random()
	sound_pl.play()
	sound_pl.volume_db = intesity

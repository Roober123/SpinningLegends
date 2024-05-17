extends Ability

@export var damage : float
@export var speed : float
@export var rocket_rot_degrees : float
@export var knock_power : float
var stats_scaling : float = 1.0
var  rocket : PackedScene = preload("res://Effects/RocketAbility/rocket.tscn")


func start()->void:
	damage *= stats_scaling
	for i in get_tree().get_nodes_in_group('Spinners'):
		if i!=parent:
			var r : Node3D = rocket.instantiate()
			CollisionManager.game_folder.add_child(r)
			r.parent = parent
			r.global_position = parent.global_position
			r.initialize(i.global_position,rocket_rot_degrees,speed,damage,knock_power)
	call_deferred('queue_free')

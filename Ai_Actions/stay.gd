class_name stay
extends ActionLeaf


var last_pos : Vector3

@export var max_time : float = 0.2

var succes : bool = false

func before_run(actor: Node, _blackboard: Blackboard) -> void:
	last_pos = actor.global_position
	succes = false
	await  get_tree().create_timer(max_time).timeout
	succes=true


func tick(actor: Node, _blackboard: Blackboard) -> int:
	if actor.global_position.distance_to(last_pos) > 0.4:
		actor.AddVelocityTowards(last_pos)
	if succes:
		return SUCCESS
	return RUNNING


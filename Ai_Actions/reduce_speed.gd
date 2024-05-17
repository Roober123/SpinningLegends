class_name reduce_speed
extends ActionLeaf

@export var max_time : float = 0.2

var succes : bool = false

func before_run(_actor: Node, _blackboard: Blackboard) -> void:
	succes = false
	await  get_tree().create_timer(max_time).timeout
	succes=true

func tick(_actor: Node, _blackboard: Blackboard) -> int:
	var v2 : Vector2 = Vector2(_actor.velocity.x,_actor.velocity.z).normalized()
	_actor.movement_queue.push_back(-Vector3(v2.x,0,v2.y))
	if succes:
		return SUCCESS
	return RUNNING

class_name MoveTowardsCenter
extends ActionLeaf

@export var max_time : float = 0.2


var t : float = 0



func before_run(_actor: Node, _blackboard: Blackboard) -> void:
	t = 0
	set_process(true)

func _process(delta):
	t+=delta

func tick(actor: Node, _blackboard: Blackboard) -> int:
	actor.AddVelocityTowards(CollisionManager.arena_center)
	if t >= max_time:
		return SUCCESS
	return RUNNING

func after_run(_actor: Node, _blackboard: Blackboard) -> void:
	t = 0
	set_process(false)

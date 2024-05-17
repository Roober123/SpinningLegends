class_name FarFromCenter
extends ConditionLeaf

@export var max_distance_from_center : float

func tick(actor: Node, _blackboard: Blackboard) -> int:
	if max_distance_from_center <  (actor.global_position + actor.velocity*0.3).distance_to(CollisionManager.arena_center):
		return FAILURE
	return SUCCESS

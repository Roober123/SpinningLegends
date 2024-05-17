class_name hasEnemyClose
extends ConditionLeaf

@export var close_max_dist : float = 0.3

func tick(actor: Node, _blackboard: Blackboard) -> int:
	var min_dist_sq : float = 100000000
	for i in get_tree().get_nodes_in_group("Spinners"):
		if i!=actor and actor.global_position.distance_squared_to(i.global_position) < min_dist_sq:
			min_dist_sq = actor.global_position.distance_squared_to(i.global_position)
	if close_max_dist*close_max_dist >= min_dist_sq:
		return SUCCESS
	return FAILURE

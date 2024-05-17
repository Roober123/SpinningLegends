class_name has_ability
extends ConditionLeaf

@export var ability : PackedScene

func tick(actor: Node, _blackboard: Blackboard) -> int:
	if ability==actor.ring.ability:
		return SUCCESS
	return FAILURE

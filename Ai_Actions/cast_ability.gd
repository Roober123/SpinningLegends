class_name cast_ability
extends ActionLeaf

var delay : float = 1.5
var can_cast : bool = false

func _ready():
	await get_tree().create_timer(delay).timeout
	can_cast=true


func tick(actor : Node,_black : Blackboard)->int:
	if !can_cast:
		return RUNNING
	else:
		actor.ring.cast_ability()
		return SUCCESS

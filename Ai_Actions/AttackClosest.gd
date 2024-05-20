class_name AttackClosest
extends ActionLeaf



@export var max_time : float = 0.2

var selected_node : Spinner = null
var suc : bool = false
var t : float = 0

func before_run(actor : Node, _black_board : Blackboard)->void:
	if actor.is_connected('Collided',succeded)==false:
		actor.connect('Collided',succeded)
	set_selected(actor)
	suc = false
	set_process(true)
	t=0

func _process(delta):
	t+=delta

func set_selected(actor : Spinner)->void:
	var n : Array = get_tree().get_nodes_in_group("Spinners")
	if n.size()==1:
		return
	selected_node = null
	while selected_node == null or selected_node==actor:
		selected_node = n.pick_random()

func tick(actor: Node, _blackboard: Blackboard) -> int:
	if t>=max_time:
		return SUCCESS
	if suc:
		return SUCCESS
	if selected_node==null:
		return SUCCESS
	if is_instance_valid(selected_node):
		actor.AddVelocityTowards(selected_node.global_position)
	return RUNNING

func after_run(_actor : Node, _black_board : Blackboard)->void:
	set_process(false)

func succeded()->void:
	suc = true

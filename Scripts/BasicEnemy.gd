class_name BasicEnemy
extends Spinner

var ai : PackedScene = preload("res://Ai_Actions/spinner_ai.tscn")

var is_boss : bool
var stats_boost_overall : float = 1.0
var max_tier : int 

func get_good_packed(arr : Array)->PackedScene:
	var good : bool = false
	var l : PackedScene = null
	while !good:
		l = arr.pick_random()
		var x = l.instantiate()
		if x.tier <= max_tier:
			good = true
		x.queue_free()
	return l

func _ready():
	if is_boss:
		scale = Vector3(1.5,1.5,1.5)
		stats_boost_overall  *=2.4
	CollisionManager.game_folder=get_parent()
	var x : BeehaveTree = ai.instantiate()
	add_child(x)
	Ready()
	swap_part('ring',get_good_packed(DataHandler.spinners_data.rings))
	swap_part('tip',get_good_packed(DataHandler.spinners_data.tips))
	swap_part('middle',get_good_packed(DataHandler.spinners_data.middles))
	if !is_boss:
		ring.ability = null
		speed = min(stats_boost_overall,1.75) * speed
	else:
		speed = speed * (max(1,stats_boost_overall*0.2))
	mass = stats_boost_overall * mass
	
	resistance = stats_boost_overall * resistance
	recover_rate = stats_boost_overall * recover_rate

func _process(delta):
	Update(delta)

func _physics_process(delta):
	Movement_physics(delta)
	move_and_slide()

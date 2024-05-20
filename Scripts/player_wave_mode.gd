extends Spinner

var  stats_boost_overall : float = 1.25


func _ready():
	stats_boost_overall += Global.xp * 0.003
	Ready()
	swap_part('ring',Global.player_ring)
	swap_part('tip',Global.player_tip)
	swap_part('middle',Global.player_middle)
	CollisionManager.game_folder=get_parent()
	mass = stats_boost_overall * mass
	speed = stats_boost_overall * speed
	resistance = stats_boost_overall * resistance
	recover_rate = stats_boost_overall * recover_rate
	
	
	
func _process(delta):
	if Input.is_action_just_pressed("ability"):
		ring.cast_ability()
	Update(delta)

func Movement(delta : float)->void:
	Movement_physics(delta)
	var dir : Vector2 = Input.get_vector("left",'right','up','down')
	var v1 : Vector3 =  speed * delta * global_transform.basis.z * dir.y
	v1.y=0
	var v2 : Vector3 = speed * delta * global_transform.basis.x * dir.x
	v2.y=0
	velocity += v1 + v2
	velocity = velocity.limit_length(15)
	move_and_slide()
func _physics_process(delta):
	Movement(delta)

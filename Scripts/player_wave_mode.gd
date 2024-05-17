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
	speed = min(1.75,stats_boost_overall) * speed
	resistance = stats_boost_overall * resistance
	recover_rate = stats_boost_overall * recover_rate
	
func _process(delta):
	if Input.is_action_just_pressed("ability"):
		ring.cast_ability()
	Update(delta)

func Movement(delta : float)->void:
	Movement_physics(delta)
	var dir : Vector2 = Input.get_vector("left",'right','up','down')
	velocity += speed * delta * global_transform.basis.z * dir.y + speed * delta * global_transform.basis.x * dir.x
	move_and_slide()
func _physics_process(delta):
	Movement(delta)

extends Spinner



func _ready():
	Ready()
	swap_part('ring',DataHandler.spinners_data.rings.pick_random())
	swap_part('tip',DataHandler.spinners_data.tips.pick_random())
	swap_part('middle',DataHandler.spinners_data.middles.pick_random())
	
	CollisionManager.game_folder=get_parent()
	
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
	#if Input.is_action_just_pressed("ui_accept"):
	#	swap_part('ring',DataHandler.spinners_data.rings.pick_random())
	#	swap_part('tip',DataHandler.spinners_data.tips.pick_random())
	#	swap_part('middle',DataHandler.spinners_data.middles.pick_random())

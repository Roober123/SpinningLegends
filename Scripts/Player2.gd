extends Spinner


func _ready():
	Ready()
	swap_part('ring',DataHandler.spinners_data.rings.pick_random())
	swap_part('tip',DataHandler.spinners_data.tips.pick_random())
	swap_part('middle',DataHandler.spinners_data.middles.pick_random())


func _process(delta):
	if Input.is_action_just_pressed("ability2"):
		ring.cast_ability()
	Update(delta)

func Movement(delta : float)->void:
	Movement_physics(delta)
	var dir : Vector2 = Input.get_vector("ui_left","ui_right","ui_up","ui_down")
	velocity += speed * delta * global_transform.basis.z * dir.y + speed * delta * global_transform.basis.x * dir.x
	move_and_slide()
	
func _physics_process(delta):
	Movement(delta)
	

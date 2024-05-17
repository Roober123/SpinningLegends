extends Ability

@export var duration : float = 4

@export var attract_power : float = 50
@export var damage_power : float  = 100

var stats_scaling : float = 1.0

var active_spinners : Dictionary

func start()->void:
	attract_power *= stats_scaling
	damage_power *= stats_scaling
	global_position=parent.global_position
	await  get_tree().create_timer(duration).timeout
	call_deferred('queue_free')


func update(delta : float)->void:
	for i in active_spinners:
		if i !=null:
			i.velocity += i.global_position.direction_to(global_position) * attract_power / i.mass  * delta
			i.take_damage( damage_power * delta )


func _on_body_detector_body_entered(body):
	if body is Spinner and body!=parent:
		active_spinners[body] = true


func _on_body_detector_body_exited(body):
	if body is Spinner and body!=parent:
		active_spinners.erase(body)

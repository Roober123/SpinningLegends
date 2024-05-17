extends Camera3D


var t : float 
var intens : float


func _process(delta: float) -> void:
	shake(delta)
	
	

func shake(delta : float)->void:
	h_offset = 0
	v_offset = 0
	if t<=0:
		return
	t-=delta
	var x : float = randf_range(-intens,intens)
	var y : float = randf_range(-intens,intens)
	h_offset = y
	v_offset = x


func start_shake(intensity : float,dur : float)->void:
	t=dur
	intens = intensity

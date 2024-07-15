class_name Spinner_part
extends Node3D


@export var up_part_origin : Node3D = null
@export var center : Node3D = null
@export var coll_shape : CollisionShape3D
## 0 - inelastic , 1 - elastic
@export_range(0,100) var friction : float = 0 
@export var resistance : float
@export var recover_rate : float
@export_range(0.001,1000) var mass : float = 1
@export var speed : float
@export var tier : int = 1
var parent : Spinner


	

func _ready():
	if up_part_origin == null or (get_parent() is Spinner == false):
		#push_warning('part is broken : ',name)
		return
	parent = get_parent()

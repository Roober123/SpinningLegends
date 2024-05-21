extends Node

var money : int 
var xp : float

var unlocked : Dictionary ={
	"res://Resources/Parts/Tips/spinner_tip_1.tscn"=true,
	"res://Resources/Parts/Middles/spinner_middle_1.tscn"=true,
	"res://Resources/Parts/Rings/spinner_ring_1.tscn"=true
	
}

var player_tip : PackedScene = preload("res://Resources/Parts/Tips/spinner_tip_1.tscn")
var player_middle : PackedScene = preload("res://Resources/Parts/Middles/spinner_middle_1.tscn")
var player_ring : PackedScene = preload("res://Resources/Parts/Rings/spinner_ring_1.tscn")

func _ready() -> void:
	process_mode=PROCESS_MODE_ALWAYS

func show_tweened(n : Control):
	var tw := get_tree().create_tween()
	n.visible = true
	n.scale = Vector2.ZERO
	tw.tween_property(n,'scale',Vector2(1,1),0.2)
func hide_tweened(n : Control):
	var tw := get_tree().create_tween()
	tw.tween_property(n,'scale',Vector2.ZERO,0.2)
	await  tw.finished
	n.visible = false


var nr : int = 0


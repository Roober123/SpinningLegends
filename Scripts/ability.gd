class_name Ability
extends Node3D

var parent : Spinner

func _ready():
	start()
func _physics_process(delta):
	update(delta)

## to be implemented
func start()->void:
	pass
func update(_delta : float)->void:
	pass

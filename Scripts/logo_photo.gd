extends Node3D


func _ready() -> void:
	await get_tree().create_timer(0.3).timeout
	$SubViewport.get_texture().get_image().save_png("user://data/photo.png")
	

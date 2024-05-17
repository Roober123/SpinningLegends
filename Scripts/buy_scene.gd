class_name BuyScene
extends Control

@export var price : int
@export var scene : PackedScene 
@export_enum("tip","middle","ring") var type : String = "tip"

@onready var vp : SubViewport = $SubViewport
@onready var button := $VBoxContainer/Button
func _ready() -> void:
	var x  = scene.instantiate()
	vp.add_child(x)
	x.rotation_degrees.x=15
	x.rotation_degrees.z=-15
	await RenderingServer.frame_post_draw
	$VBoxContainer/TextureRect.texture = ImageTexture.create_from_image(vp.get_texture().get_image())
	vp.queue_free()
	

func _process(delta: float) -> void:
	if Global.unlocked.has(scene.resource_path):
		if scene.resource_path == Global.player_tip.resource_path || scene.resource_path == Global.player_ring.resource_path || scene.resource_path == Global.player_middle.resource_path:
			button.text = 'Equipped'
		else:
			button.text = 'Equip'
	else:
		button.text='Buy:%s' %price


func equip()->void:
	match  type:
			"tip":
				Global.player_tip=scene
			"middle":
				Global.player_middle=scene
			"ring":
				Global.player_ring=scene

func _on_button_pressed() -> void:
	if button.text == 'Equipped':
		return
	if button.text == 'Equip':
		equip()
		return
	if Global.money >= price:
		Global.money -= price
		Global.unlocked[scene.resource_path] = true
		equip()
	

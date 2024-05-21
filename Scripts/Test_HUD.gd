extends CanvasLayer

@onready var player : Spinner = $"../Player"
@onready var player2 : Spinner =$"../Player2"
var menu : PackedScene = preload("res://Menu/menu_screen.tscn")

func _ready() -> void:
	get_viewport().scaling_3d_scale = DataHandler.scaling
	CollisionManager.sound_pl = $"../AudioStreamPlayer3D"
	if OS.get_name()!='Android' and OS.get_name()!='iOS':
		$Ability1.queue_free()
		$Ability2.queue_free()

func _on_change_tip_1_pressed():
	player.swap_part('tip',DataHandler.spinners_data.tips.pick_random())


func _on_change_middle_1_pressed():
	player.swap_part('middle',DataHandler.spinners_data.middles.pick_random())


func _on_change_ring_1_pressed():
	player.swap_part('ring',DataHandler.spinners_data.rings.pick_random())

func _on_change_tip_2_pressed():
	player2.swap_part('tip',DataHandler.spinners_data.tips.pick_random())


func _on_change_middle_2_pressed():
	player2.swap_part('middle',DataHandler.spinners_data.middles.pick_random())


func _on_change_ring_2_pressed():
	player2.swap_part('ring',DataHandler.spinners_data.rings.pick_random())


func _on_hide_pressed():
	$VBoxContainer.visible = !$VBoxContainer.visible
	$VBoxContainer2.visible = !$VBoxContainer2.visible

func _process(_delta):
	$fps_draw.text = "Fps : %s" %str(Engine.get_frames_per_second())
	if Input.is_action_just_pressed("ui_accept"):
		get_tree().reload_current_scene()


func _on_button_back_pressed():
	get_tree().change_scene_to_packed(menu)



func _on_ability_1_pressed() -> void:
	player.ring.cast_ability()


func _on_ability_2_pressed() -> void:
	player2.ring.cast_ability()

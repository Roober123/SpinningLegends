extends Control



func _on_button_1v_1_pressed():
	get_tree().change_scene_to_file("res://Scenes/test.tscn")



func _ready() -> void:
	get_viewport().scaling_3d_scale = 1.0



func _on_button_pressed():
	var actual := DisplayServer.window_get_vsync_mode()
	if actual == DisplayServer.VSYNC_ENABLED:
		DisplayServer.window_set_vsync_mode(DisplayServer.VSYNC_DISABLED)
		$Options/VBoxContainer/VsyncControl/Label.text = '       Off'
	else:
		DisplayServer.window_set_vsync_mode(DisplayServer.VSYNC_ENABLED)
		$Options/VBoxContainer/VsyncControl/Label.text = '       On'

func _on_line_edit_text_submitted(new_text):
	var nr : int = max(20,min(240,int(new_text)))
	Engine.physics_ticks_per_second = nr
	$Options/VBoxContainer/PhysicsFPS/LineEdit.text = ''
	$Options/VBoxContainer/PhysicsFPS/LineEdit.placeholder_text = str(nr)


func _on_mx_fps_line_edit_text_submitted(new_text):
	var val : int = int(new_text)
	if val < 0:
		val = 0
	Engine.set_max_fps(val)
	if val!=0:
		$Options/VBoxContainer/maxfpscontrol/mx_fps_line_edit.placeholder_text = str(val)
	else:
		$Options/VBoxContainer/maxfpscontrol/mx_fps_line_edit.placeholder_text = 'unlimited'
	$Options/VBoxContainer/maxfpscontrol/mx_fps_line_edit.text=''

func _on_button_options_pressed():
	Global.show_tweened($Options)

func _on_button_back_pressed():
	Global.hide_tweened($Options)


func _on_res_scale_text_submitted(new_text):
	var nr : float = max(0.1,min(2.0,float(new_text)))
	DataHandler.scaling = nr
	$Options/VBoxContainer/resolution_scale/res_scale.text = ''
	$Options/VBoxContainer/resolution_scale/res_scale.placeholder_text = str(nr)


func _on_button_shop_pressed() -> void:
	Global.show_tweened($BuyMenu)


func _on_button_back_shop_pressed() -> void:
	Global.hide_tweened($BuyMenu)


func _on_button_play_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/game_mode_1.tscn")


func _on_button_quit_pressed() -> void:
	get_tree().quit()

@onready var xp_label : Label = $xp_label
func _process(delta: float) -> void:
	xp_label.text = ": %s" % Global.xp


func _on_tree_entered() -> void:
	DataHandler.load_local_data()


func _on_tree_exited() -> void:
	DataHandler.save_local_data()
	



func _on_button_reset_progress_pressed() -> void:
	DataHandler.delete_local_data()
	DataHandler.load_local_data()
	Global.hide_tweened($Options)


func _on_xp_cheat_pressed() -> void:
	Global.xp += 100


func _on_money_cheat_pressed() -> void:
	Global.money += 100

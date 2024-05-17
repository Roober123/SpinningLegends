extends CanvasLayer


func _on_pause_pressed() -> void:
	get_tree().paused = !get_tree().paused
	$Hud_control/Pause_Menu.visible = !$Hud_control/Pause_Menu.visible


func _ready() -> void:
	$health_bar.max_value = pl.resistance
	
func _on_button_pressed() -> void:
	get_tree().paused = false
	get_parent().reset()

@onready var pl : Spinner = $"../PlayerWaveMode"
@onready var money_label : Label = $Hud_control/Pause_Menu/money_label
func _process(delta: float) -> void:
	money_label.text = "               : %s" % Global.money
	$health_bar.value = pl.resistance - pl.damage_taken
	$health_label.text = str(int(pl.resistance-pl.damage_taken))+'/'+str(int(pl.resistance))
	$fps_display.text = "FPS : %s" %Engine.get_frames_per_second()
	
		


func _on_ability_button_pressed() -> void:
	pl.ring.cast_ability()

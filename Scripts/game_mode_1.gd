extends Node3D

@onready var player : Spinner = $PlayerWaveMode

var wave_nr : int = 0
var wave_cool : float = 2

var t : float

func _ready() -> void:
	get_viewport().scaling_3d_scale = DataHandler.scaling
	CollisionManager.arena_center = Vector3.ZERO
	player.connect('Die',reset)
	CollisionManager.sound_pl = $AudioStreamPlayer3D
	CollisionManager.shake_cam = $CameraShake


func reset()->void:
	Global.high_score=max(Global.high_score,wave_nr)
	DataHandler.save_local_data()
	get_tree().call_deferred('change_scene_to_file',"res://Menu/menu_screen.tscn")

func _on_kill_area_body_exited(body: Node3D) -> void:
	if body is Spinner:
		body.emit_signal('Die')
		body.call_deferred('queue_free')

var last_nr_of_enemies : int 

@onready var wave_label = $GameMode1_Hud/wave_label
func _process(delta: float) -> void:
	t-=delta
	wave_label.text = "Wave  "+ str(wave_nr)
	if t <= 0 and get_tree().get_nodes_in_group("Spinners").size()==1:
		Global.money += last_nr_of_enemies * int(max(1,wave_nr*0.1))
		Global.xp += last_nr_of_enemies * int(max(1,wave_nr*0.1))
		t = wave_cool
		wave_nr+=1
		spawn_wave()


func spawn_wave()->void:
	if wave_nr % 5 !=0:
		var nr : float = min(max(1,int(wave_nr*0.2)),6)
		last_nr_of_enemies = nr
		for i in nr :
			await  get_tree().create_timer(0.1).timeout
			var e : BasicEnemy = BasicEnemy.new()
			e.max_tier = wave_nr/10 + 1
			e.position.x = randf_range(-2,2)
			e.position.z = randf_range(-2,2)
			e.position.y = 0.6
			e.stats_boost_overall = 1 + (wave_nr - 5) * 0.1 
			add_child(e)
		
	else:
		var e : BasicEnemy = BasicEnemy.new()
		e.max_tier = wave_nr/10 + 1
		e.is_boss = true
		e.position.x = randf_range(-2,2)
		e.position.z = randf_range(-2,2)
		e.position.y = 0.6
		e.stats_boost_overall = 1 + (wave_nr - 5) * 0.1 
		add_child(e)
		last_nr_of_enemies = 1
		#await  get_tree().create_timer(0.1).timeout
		#e.resistance_offset = max(e.resistance - 120, (30 - wave_nr) * 20)

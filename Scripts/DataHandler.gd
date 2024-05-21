extends Node

@export var save_file_name : String = "res://data/"
@export var file_name : String = "SpinData.tres"
@export var local_save_file_name : String = "user://data/"
@export var local_data_save_name : String = "local_data"

var spinners_data : Dictionary={
	'rings' : [] ,
	'middles' : [],
	'tips' : []
}

var scaling : float = 1.0




func register_data()->void:
	var sp :SpinnersData = SpinnersData.new()
	var dir = DirAccess.open('res://Resources/Parts/Tips')
	if dir:
		dir.list_dir_begin()
		var file_namee = dir.get_next()
		while file_namee != "":
			if file_namee.ends_with('.tscn'):
				register_tip('res://Resources/Parts/Tips/' + file_namee,sp)
			file_namee = dir.get_next()
	dir = DirAccess.open('res://Resources/Parts/Middles')
	if dir:
		dir.list_dir_begin()
		var file_namee = dir.get_next()
		while file_namee != "":
			if file_namee.ends_with('.tscn'):
				register_middle('res://Resources/Parts/Middles/' + file_namee,sp)
			file_namee = dir.get_next()
	dir = DirAccess.open('res://Resources/Parts/Rings')
	if dir:
		dir.list_dir_begin()
		var file_namee = dir.get_next()
		while file_namee != "":
			if file_namee.ends_with('.tscn'):
				register_ring('res://Resources/Parts/Rings/' + file_namee,sp)
			file_namee = dir.get_next()
	
	DirAccess.make_dir_absolute(save_file_name)
	ResourceSaver.save(sp,save_file_name+file_name)
	
func register_ring(ring : String,sp : SpinnersData)->void:
	spinners_data.rings.push_back(load(ring))
	sp.rings.push_back(ring)
func register_middle(middle : String,sp : SpinnersData)->void:
	spinners_data.middles.push_back(load(middle))
	sp.middles.push_back(middle)
func register_tip(tip : String,sp : SpinnersData)->void:
	spinners_data.tips.push_back(load(tip))
	sp.tips.push_back(tip)


func save_local_data()->void:
	var s : save_data = save_data.new()
	s.money = Global.money
	s.xp = Global.xp
	s.unlocked = Global.unlocked
	s.tip = Global.player_tip.resource_path
	s.middle = Global.player_middle.resource_path
	s.ring = Global.player_ring.resource_path
	s.high_score = Global.high_score
	DirAccess.make_dir_absolute(local_save_file_name)
	ResourceSaver.save(s,local_save_file_name+ local_data_save_name + ".res")

func delete_local_data()->void:
	var s : save_data = save_data.new()
	DirAccess.make_dir_absolute(local_save_file_name)
	ResourceSaver.save(s,local_save_file_name+ local_data_save_name + ".res")

func load_local_data()->void:
	var dir = DirAccess.open(local_save_file_name)
	if dir == null:
		return
		
	if dir.file_exists(local_save_file_name + local_data_save_name + ".res")==false:
		return
	var r = ResourceLoader.load(local_save_file_name + local_data_save_name + ".res")
	var s : save_data = r.duplicate(true)
	Global.money = s.money
	Global.xp = s.xp
	Global.unlocked = s.unlocked
	Global.high_score = s.high_score
	if s.tip != null:
		Global.player_tip = load(s.tip)
	if s.middle != null:
		Global.player_middle = load(s.middle)
	if s.ring != null:
		Global.player_ring = load(s.ring)


func _ready():
	if OS.has_feature("editor"):
		register_data()
	else:
		var sp : SpinnersData = ResourceLoader.load(save_file_name+file_name).duplicate(true)
		for i in sp.rings:
			spinners_data.rings.push_back(load(i))
		for i in sp.middles:
			spinners_data.middles.push_back(load(i))
		for i in sp.tips:
			spinners_data.tips.push_back(load(i))

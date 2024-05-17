class_name Spinner_Ring
extends Spinner_part

@export var ability : PackedScene
@export var ability_cooldown : float
@export var ability_tex : Texture

var can_use : bool = true

func _ready():
	super._ready()

func cast_ability()->void:
	if ability==null: 
		return
	if can_use==false:
		return
	can_use = false
	var x : Ability = ability.instantiate()
	x.parent = parent
	if parent.get('stats_boost_overall')!=null:
		x.stats_scaling = parent.get('stats_boost_overall')
	CollisionManager.game_folder.add_child(x)
	await  get_tree().create_timer(ability_cooldown).timeout
	can_use = true

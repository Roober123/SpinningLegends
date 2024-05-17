extends Control


@onready var money_label : Label = $money_label


func _process(delta: float) -> void:
	money_label.text = ": %s" % Global.money

extends Node

signal gold_changed

var gold = 0

func _process(delta):
	if Input.is_action_pressed("debug"):
		Engine.time_scale = 5
	else:
		Engine.time_scale = 1

func add_gold(val) -> void:
	gold += val
	emit_signal("gold_changed")

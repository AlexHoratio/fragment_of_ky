extends Node

signal gold_changed

var gold = 0

func add_gold(val) -> void:
	gold += val
	emit_signal("gold_changed")

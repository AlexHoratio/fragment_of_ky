extends Node2D

var dna_collected = 0

func _ready():
	pass
	
func _process(delta):
	pass

func _on_next_scene_timeout() -> void:
	get_tree().change_scene("res://Scenes/end.tscn")

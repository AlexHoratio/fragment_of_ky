extends Node2D

func _ready():
	pass
	
func _process(delta):
	pass

func _on_animation_player_animation_finished(anim_name):
	if anim_name == "fade_out":
		get_tree().change_scene_to_file("res://Scenes/mutations.tscn")

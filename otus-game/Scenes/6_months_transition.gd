extends Control


func _on_animation_player_animation_finished(anim_name):
	if anim_name == "default":
		get_tree().change_scene_to_file("res://Scenes/6monthslater.tscn")

extends Control

func _ready():
	pass
	
func _process(delta):
	pass
	
func say(text) -> void:
	Chat.spawn_message(text)


func _on_animation_player_animation_finished(anim_name):
	if anim_name == "fade_in":
		get_tree().change_scene_to_file("res://Scenes/read_classification.tscn")

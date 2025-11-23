extends Node2D

func _ready():
	pass
	
func _process(delta):
	pass


func _on_animation_player_animation_finished(anim_name):
	if anim_name == "fade_in":
		if $CanvasLayer/narrator.text_stage == 4:
			$CanvasLayer/narrator.next_stage()

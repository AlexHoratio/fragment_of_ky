extends Node2D

func _ready():
	pass
	
func _process(delta):
	pass

func _on_voidling_reproduce_timeout():
	var voidlings = get_tree().get_nodes_in_group("voidlings")
	var random_voidling = voidlings[randi()%voidlings.size()]
	random_voidling.reproduce()

func _on_voidling_reproduce_mutant_timeout():
	var voidlings = get_tree().get_nodes_in_group("voidlings")
	var random_voidling = voidlings[randi()%voidlings.size()]
	random_voidling.reproduce(true, 10, "C")

func _on_auto_reproduce_timeout():
	var voidlings = get_tree().get_nodes_in_group("voidlings")
	
	if voidlings.size() < 40:
		for v in voidlings:
			if randi()%2 == 0:
				v.reproduce(true, 2 + randi()%10, ["A", "T", "C", "G"][randi()%4])
			else:
				v.reproduce(true, -1, "", 0.015)
	else:
		$auto_reproduce.stop()
		get_tree().get_meta("orteil").walk_to(Vector2(960, 950))
		get_tree().get_meta("orteil").queue_dialogue_after_walk("[wave]Take a second to click around, and look at all those different genomes!", true, 0.7, 3, "mt_diff_genomes", 5)

func _on_marker_mutant_timeout():
	var voidlings = get_tree().get_nodes_in_group("voidlings")
	var random_voidling = voidlings[randi()%voidlings.size()]
	random_voidling.reproduce(true, -1, "", 0.0, true)


func _on_animation_player_animation_finished(anim_name):
	if anim_name == "fade_out":
		pass

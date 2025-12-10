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
	var random_voidling = voidlings[randi()%voidlings.size()]
	random_voidling.reproduce(true, -1, "", 0.02)

extends Node2D

func _ready():
	pass
	
func _process(delta):
	pass

func _on_voidling_reproduce_timeout():
	var voidlings = get_tree().get_nodes_in_group("voidlings")
	
	var random_voidling = voidlings[randi()%voidlings.size()]
	
	random_voidling.reproduce()

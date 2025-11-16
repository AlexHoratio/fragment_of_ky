extends Node2D

var max_voidlings = 12
var voidlings_enabled = false

func _ready() -> void:
	pass
	
func _process(delta: float) -> void:
	$CanvasLayer/press_to_begin.visible = $CanvasLayer/narrator.text_stage == 0
	
	if voidlings_enabled and get_tree().get_nodes_in_group("voidlings").size() < max_voidlings:
		if randi()%25 == 0:
			spawn_voidling()
	
func enable_voidlings() -> void:
	voidlings_enabled = true
	
func spawn_voidling() -> void:
	var voidling = load("res://Prefabs/Living/voidling.tscn").instantiate()
	voidling.position = Vector2(200, 200) + Vector2((1920 - 400) * randf(), (1080 - 400) * randf())
	voidling.clicked.connect($CanvasLayer/genome_viewer.view_voidling_genome.bind(voidling))
	$living.add_child(voidling)

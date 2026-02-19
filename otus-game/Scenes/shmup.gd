extends Node2D

var voidlings_spawned = 0
var max_voidlings = 7

var spawning = false

func _ready():
	pass
	
func _process(delta):
	if spawning:
		if voidlings_spawned < max_voidlings:
			spawn_voidling()
	
	
func spawn_voidling() -> void:
	var voidling = load("res://Prefabs/Living/voidling.tscn").instantiate()
	voidling.position = Vector2(200, 200) + Vector2((1920 - 400) * randf(), (1080 - 400) * randf())
	voidling.no_click_message = true
	voidling.drop_dna = true
	$living.add_child(voidling)
	
	voidlings_spawned += 1

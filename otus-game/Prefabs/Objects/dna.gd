extends Node2D

func _ready():
	pass
	
func _process(delta):
	rotation += (1 - (2*randf()))*2*delta
	position += Vector2(1 - 2*randf(), 1 - 2*randf()) * 0.5

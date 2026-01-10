extends Area2D

var movement_vector = Vector2(1, 0)
var speed = 1800

func _ready():
	pass
	
func _process(delta):
	position += movement_vector * speed * delta

func _on_area_entered(area):
	if area.has_method("damage"):
		area.damage(1)
		var explosion = load("res://Prefabs/Bullets/iron_bullet_explosion.tscn").instantiate()
		get_parent().add_child(explosion)
		explosion.global_position = area.global_position
		
		queue_free()

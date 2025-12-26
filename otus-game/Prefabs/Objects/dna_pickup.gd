extends Node2D

signal collected

func _ready():
	rotation = randi()

func _process(delta):
	rotation += ((randf() * 2) - 1)*delta * 5
	
	position += Vector2(randf()*2 - 1, randf()*2 - 1) * delta * 55
	
	if global_position.distance_to(get_global_mouse_position()) < 32:
		$AnimationPlayer.play("collect")

func _on_animation_player_animation_finished(anim_name):
	if anim_name == "collect":
		emit_signal("collected")
		queue_free()

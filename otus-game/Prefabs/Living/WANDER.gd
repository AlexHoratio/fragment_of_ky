extends Node

var fsm = null
var wander_point = Vector2(0, 0)

func enter() -> void:
	wander_point = fsm.kyztling.global_position + Vector2(50 + randf()*25, 0).rotated(randf()*2*PI)
	$wander_timer.start(10)
	
func process(delta: float) -> void:
	#fsm.kyztling.move_and_collide(Vector2(1, 0).rotated(fsm.kyztling.global_position.angle_to_point(wander_point)))
	fsm.kyztling.movement_vector = Vector2(1, 0).rotated(fsm.kyztling.global_position.angle_to_point(wander_point))
	
	#if fsm.kyztling.get_node("AnimatedSprite2D").animation != "walk":
		#fsm.kyztling.get_node("AnimatedSprite2D").animation = "walk"
	
	if fsm.kyztling.global_position.distance_to(wander_point) < 5:
		fsm.change_to("IDLE")
		$wander_timer.stop()

func _on_wander_timer_timeout() -> void:
	fsm.change_to("IDLE")

extends Node

var fsm = null

func enter() -> void:
	fsm.kyztling.movement_vector = Vector2(0, 0)  
	fsm.kyztling.get_node("AnimatedSprite2D").play("idle")
	$idle_timer.start(3 + randf()*6)
	
func process(delta: float) -> void:
	pass

func _on_idle_timer_timeout() -> void:
	fsm.change_to("WANDER")

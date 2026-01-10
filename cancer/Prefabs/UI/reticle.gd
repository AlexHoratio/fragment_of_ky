extends Node2D

var target_entity = null
var offset = Vector2(0, 0)

func _ready() -> void:
	get_tree().set_meta("reticle", self)

func _process(delta: float) -> void:
	if target_entity != null:
		global_position = lerp(global_position, target_entity.global_position, 0.2)
		
	modulate.a = lerp(modulate.a, 0.0 if target_entity == null else 1.0, 0.1)
	queue_redraw()
	
func _draw() -> void:
	draw_circle(offset, 48, Color("77777744"), false, 2)

func set_target(who, new_offset = Vector2(0, 0)) -> void:
	target_entity = who
	offset = new_offset

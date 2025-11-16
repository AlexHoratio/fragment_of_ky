extends RichTextLabel

var fade_speed = 0.2
var move_speed = 25.0

func _ready() -> void:
	pass
	
func _process(delta: float) -> void:
	position.y -= move_speed * delta
	modulate.a -= fade_speed * delta
	
	if modulate.a <= 0:
		queue_free()

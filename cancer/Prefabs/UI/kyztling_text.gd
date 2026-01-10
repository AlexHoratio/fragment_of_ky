extends RichTextLabel

var fade_speed = 0.2
var move_speed = 25.0

var border_size = 0

func _ready() -> void:
	self["theme_override_constants/outline_size"] = border_size
	
func _process(delta: float) -> void:
	position.y -= move_speed * delta
	modulate.a -= fade_speed * delta
	
	if modulate.a <= 0:
		queue_free()

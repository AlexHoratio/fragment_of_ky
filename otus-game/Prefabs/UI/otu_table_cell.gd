extends NinePatchRect

var cell_text = ""
var locked = false

var shake = 0
var textedit_start_position = Vector2(0, 0)

func _ready() -> void:
	$TextEdit.text = cell_text
	$TextEdit.editable = !locked
	
	textedit_start_position = $TextEdit.position
	
func _process(delta: float) -> void:
	shake = clamp(shake - delta * 5, 0, 1)
	
	if shake > 0:
		$TextEdit.position = Vector2(-1, 0).rotated(2*PI*randf()) * shake * shake * 10
	
	$TextEdit.self_modulate = lerp($TextEdit.self_modulate, Color.WHITE, 0.1)
	
func set_text(new_text) -> void:
	$TextEdit.text = new_text
	$TextEdit.self_modulate = Color.YELLOW
	shake = 1

func get_text() -> String:
	return $TextEdit.text

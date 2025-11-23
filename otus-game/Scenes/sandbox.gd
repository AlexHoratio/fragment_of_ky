extends NinePatchRect

var hovering = false
var dragging = false
var drag_offset = Vector2(0, 0)
var mouse_last_pos = Vector2(0, 0)

var time = 0

func _ready():
	pass
	
func _process(delta):
	time += delta
	$header/ColorRect.self_modulate.a = lerp($header/ColorRect.self_modulate.a, 1.0 if hovering else 0.0, 0.2)
	
	if dragging:
		global_position = get_global_mouse_position() - drag_offset
		
		for voidling in get_tree().get_nodes_in_group("voidlings"):
			voidling.otu_shove_momentum += (get_global_mouse_position() - mouse_last_pos) * 5
			
		mouse_last_pos = get_global_mouse_position()

func _on_button_mouse_entered():
	hovering = true

func _on_button_mouse_exited():
	hovering = false

func _on_button_button_down():
	dragging = true
	drag_offset = get_global_mouse_position() - global_position
	mouse_last_pos = get_global_mouse_position()
	
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)

func _on_button_button_up():
	dragging = false
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)

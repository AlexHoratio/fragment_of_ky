extends NinePatchRect

var hovering = false
var dragging = false
var drag_offset = Vector2(0, 0)

var cpus = 1

var can_download = false

func _ready():
	pass
	
func _process(delta):
	$header/ColorRect.self_modulate.a = lerp($header/ColorRect.self_modulate.a, 1.0 if hovering else 0.0, 0.2)
	
	if dragging:
		global_position = get_global_mouse_position() - drag_offset
	
	update_stats()
	
	$download/download.visible = can_download
	$download.position.y = lerp($download.position.y, 304.0 if can_download else 250.0, 0.2)
	$download/ColorRect.self_modulate.a = lerp($download/ColorRect.self_modulate.a, 0.0, 0.2)

func update_stats() -> void:
	$body/RichTextLabel.text = """[color=#777]withName: [color=#fff]COUNT {

	[color=#ffb629]cpus = """ + str(cpus) + """[color=#fff]

}
"""

func start_automation() -> void:
	$count.start()
	
func stop_automation() -> void:
	$count.stop()
	

func _on_button_mouse_entered():
	hovering = true

func _on_button_mouse_exited():
	hovering = false

func _on_button_button_down():
	dragging = true
	drag_offset = get_global_mouse_position() - global_position
	
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)

func _on_button_button_up():
	dragging = false
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)

func _on_count_timeout():
	get_node("../sandbox").count_random()

func _on_download_pressed():
	get_node("../sandbox").worlds[get_node("../sandbox").world_id]["finished"] = true
	get_node("../results").download_result()
	can_download = false
	stop_automation()
	
	$download/ColorRect.self_modulate.a = 1.0

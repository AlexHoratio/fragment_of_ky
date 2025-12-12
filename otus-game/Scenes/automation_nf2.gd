extends NinePatchRect

var hovering = false
var dragging = false
var drag_offset = Vector2(0, 0)

var cpus = 1

var can_download = false

var thats_enough = false
var first_destroy = false

func _ready():
	pass
	
func _process(delta):
	$header/ColorRect.self_modulate.a = lerp($header/ColorRect.self_modulate.a, 1.0 if hovering else 0.0, 0.2)
	
	if dragging:
		global_position = get_global_mouse_position() - drag_offset
	
	#update_stats()
	
	$download/download.visible = can_download
	$download.position.y = lerp($download.position.y, 304.0 if can_download else 250.0, 0.2)
	$download/ColorRect.self_modulate.a = lerp($download/ColorRect.self_modulate.a, 0.0, 0.2)

func update_stats() -> void:
	$body/RichTextLabel.text = """[color=#777]withName: [color=#fff]COUNT_OTUS {

	[color=#ffb629]cpus = """ + str(cpus) + """[color=#fff]

}
"""

func start_automation() -> void:
	$count.start()
	
func stop_automation() -> void:
	$count.stop()
	
func add_cpus() -> void:
	cpus += 1

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
	get_node("../results").download_result({"otu_tables": 1})
	can_download = false
	#stop_automation()
	
	$download/ColorRect.self_modulate.a = 1.0

func _on_culture_timeout():
	var voidlings = get_tree().get_nodes_in_group("voidlings")
	
	if voidlings.size() > 0:
		var random_voidling = voidlings[randi()%voidlings.size()]
		random_voidling.reproduce(false)
		
	get_node("../sandbox").scores["cultured"] += 1
	get_node("../sandbox").update_destination_bar()
	
	if !thats_enough:
		if voidlings.size() >= 15:
			thats_enough = true
			get_node("../CanvasLayer/narrator").text_stage = 10
			get_node("../CanvasLayer/narrator").next_stage()

func _on_destroy_timeout():
	var voidlings = get_tree().get_nodes_in_group("voidlings")
	
	if voidlings.size() <= 2:
		get_node("destroy").stop()
	
	if voidlings.size() > 1:
		var random_voidling = voidlings[randi()%voidlings.size()]
		random_voidling.explode()
		
	get_node("../sandbox").scores["destroyed"] += 1
	get_node("../sandbox").update_destination_bar()
	
	if !first_destroy:
		first_destroy = true
		get_node("../CanvasLayer/narrator").text_stage = 13
		get_node("../CanvasLayer/narrator").next_stage()

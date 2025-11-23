extends NinePatchRect

var hovering = false
var dragging = false
var drag_offset = Vector2(0, 0)
var mouse_last_pos = Vector2(0, 0)

var time = 0

var world_id = 0

var worlds = {
	0: {
		"voidlings": 11,
	}
}

func _ready():
	enter_world_id(0)
	
func _process(delta):
	time += delta
	$header/ColorRect.self_modulate.a = lerp($header/ColorRect.self_modulate.a, 1.0 if hovering else 0.0, 0.2)
	
	if dragging:
		global_position = get_global_mouse_position() - drag_offset
		
		for voidling in get_tree().get_nodes_in_group("voidlings"):
			voidling.otu_shove_momentum += (get_global_mouse_position() - mouse_last_pos) * 5
			
		mouse_last_pos = get_global_mouse_position()
	
func update_destination_bar() -> void:
	var alphanumeric = "abcdef0123456789"
	var work_dir = ""
	for i in 2:
		work_dir += alphanumeric[randi()%alphanumeric.length()]
	work_dir += "/"
	for i in 6:
		work_dir += alphanumeric[randi()%alphanumeric.length()]
		
	var max_voidlings = get_tree().get_node_count_in_group("voidlings")
	var clicked = 0
	for v in get_tree().get_nodes_in_group("voidlings"):
		if v.clicked_once:
			clicked += 1
	
	var pct = int(round(float(100 * clicked) / float(max_voidlings)))
	
	$arena/destination/task.text = "[color=#777][[color=#aaa]" + work_dir + "[color=#777]] KY:[color=#bbb]COUNT_OTUS[color=#777] [" + str(pct) + "%] [color=#ccc]" + str(clicked) + " of " + str(max_voidlings) 

func enter_world_id(id) -> void:
	world_id = id
	
	for voidling in get_tree().get_nodes_in_group("voidlings"):
		voidling.queue_free()
		
	for i in worlds[id]["voidlings"]:
		var voidling = load("res://Prefabs/Living/voidling.tscn").instantiate()
		voidling.scale = Vector2(0.5, 0.5)
		voidling.position = Vector2(100 + randf()*(size.x - 200), 100 + randf()*(size.y - 200))
		voidling.clicked.connect(voidling_clicked.bind(voidling))
		voidling.modulate.a = 0.2
		$arena/living.add_child(voidling)

func count_random() -> void:
	var unclicked = []
	
	for v in get_tree().get_nodes_in_group("voidlings"):
		if !v.clicked_once:
			unclicked.append(v)
	
	if unclicked.size() > 0:
		unclicked[randi()%unclicked.size()].click()
		
	update_destination_bar()
		
func voidling_clicked(v) -> void:
	v.modulate.a = 1.0

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

extends NinePatchRect

var hovering = false
var dragging = false
var drag_offset = Vector2(0, 0)
var mouse_last_pos = Vector2(0, 0)

var time = 0

var world_id = -1
var highest_world_unlocked = 0

var worlds = {
}

var scores = {
	"cultured": 0,
	"destroyed": 0
}

func _ready():
	update_destination_bar()
	
func _process(delta):
	time += delta
	$header/ColorRect.self_modulate.a = lerp($header/ColorRect.self_modulate.a, 1.0 if hovering else 0.0, 0.2)
	
	$arena/destination/next.self_modulate.a = lerp($arena/destination/next.self_modulate.a, 1.0 if (world_id < highest_world_unlocked and worlds.size() != 0) else 0.3, 0.2)
	$arena/destination/prev.self_modulate.a = lerp($arena/destination/prev.self_modulate.a, 1.0 if world_id > 0 else 0.3, 0.2)
	
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
	
	var pct = 0 
	var current_task = ""
	
	if !get_node("../automation/culture").is_stopped():
		current_task = "CULTURE"
	elif !get_node("../automation/destroy").is_stopped():
		current_task = "DESTROY"
	
	match current_task:
		"CULTURE":
			pct = int(100.0 * float(scores["cultured"]) / float(scores["cultured"] + 1.0))
			$arena/destination/task.text = "[color=#777][[color=#aaa]" + work_dir + "[color=#777]] KY:[color=#bbb]" + current_task + "[color=#777] [" + str(pct) + "%] [color=#ccc]" + str(scores["cultured"]) + " of " + str(scores["cultured"] + 1) 
		"DESTROY":
			pct = int(100.0 * float(scores["destroyed"]) / float(scores["destroyed"] + 1.0))
			$arena/destination/task.text = "[color=#777][[color=#aaa]" + work_dir + "[color=#777]] KY:[color=#bbb]" + current_task + "[color=#777] [" + str(pct) + "%] [color=#ccc]" + str(scores["destroyed"]) + " of " + str(scores["destroyed"] + 1) 
		"":
			$arena/destination/task.text = ""
		_:
			$arena/destination/task.text = ""
	

func enter_world_id(id) -> void:
	if id == world_id or worlds.size() == 0:
		return
		
	world_id = id
	
	for voidling in get_tree().get_nodes_in_group("voidlings"):
		voidling.queue_free()
		
	var pre_clicked = worlds[id]["counted_voidlings"]
	for i in worlds[id]["voidlings"]:
		var voidling = load("res://Prefabs/Living/voidling.tscn").instantiate()
		voidling.scale = Vector2(0.5, 0.5)
		voidling.position = Vector2(100 + randf()*(size.x - 200), 100 + randf()*(size.y - 200))
		voidling.clicked.connect(voidling_clicked.bind(voidling))
		voidling.modulate.a = 0.2
			
		$arena/living.add_child(voidling)
		
		if pre_clicked > 0:
			voidling.clicked_once = true
			voidling.modulate.a = 1.0
			pre_clicked -= 1
		
	$arena/destination/sample.text = "[center][color=#777](sample_0" + str(world_id + 1) + ".fasta)"
	update_destination_bar()

func count_random() -> void:
	var unclicked = []
	
	for v in get_tree().get_nodes_in_group("voidlings"):
		if !v.clicked_once:
			unclicked.append(v)
	
	if unclicked.size() > 0:
		unclicked[randi()%unclicked.size()].click()
		
	if unclicked.size() <= 1 and !worlds[world_id]["finished"]:
		get_node("../automation").can_download = true
		
	worlds[world_id]["counted_voidlings"] += 1
		
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

func _on_next_pressed():
	enter_world_id(clamp(world_id + 1, 0, highest_world_unlocked))

func _on_prev_pressed():
	enter_world_id(clamp(world_id - 1, 0, highest_world_unlocked))

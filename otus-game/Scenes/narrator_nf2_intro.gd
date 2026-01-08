extends NinePatchRect

var current_text = ""
var dialogue_transition_timer = 0

var text_stage = 0
var target_position = Vector2(0, 0)
var target_size = Vector2(0, 0)

var text_scroll_progress = 0

var waiting_for_all_destroyed = false

func _ready() -> void:
	target_size = Vector2(433, 106)
	position = Vector2(744, -240)
	target_position = position
	
	next_stage()
	
func _process(delta: float) -> void:
	dialogue_transition_timer = max(dialogue_transition_timer - delta, 0)
	text_scroll_progress = clamp(text_scroll_progress + delta, 0, 1)
	
	modulate.a = lerp(modulate.a, 0.0 if current_text == "" else 1.0, 0.1)
	
	position = lerp(position, target_position, 0.1)
	size = lerp(size, target_size, 0.1)
	
	if waiting_for_all_destroyed:
		if get_tree().get_node_count_in_group("voidlings") == 1:
			waiting_for_all_destroyed = false
			next_stage()
	
	$RichTextLabel.visible_ratio = text_scroll_progress
	
	if Input.is_action_just_pressed("dialogue_activate") and dialogue_transition_timer == 0:
		next_stage()
		
	if text_stage <= 3:
		if randi()%2 == 0:
			var lightning = load("res://Prefabs/Lightning/lightning.tscn").instantiate()
			lightning.begin_point = target_size/2.0 + Vector2(1, 0).rotated(2*PI*randf())
			lightning.end_point = (target_size/2.0) + Vector2(300 * randf(), 0).rotated((target_size/2.0).angle_to_point(lightning.begin_point))
			lightning.show_behind_parent = true
			lightning.modulate = Color("ffd493ff").darkened(randf())
			add_child(lightning)

func add_new_text(new_text = "", reset_text_scroll_progress = true) -> void:
	if reset_text_scroll_progress:
		text_scroll_progress = 0
		$RichTextLabel.visible_ratio = text_scroll_progress
		
	dialogue_transition_timer = 1
		
	current_text = new_text
	$RichTextLabel.text = new_text
	target_size = $RichTextLabel.get_theme_font("normal_font").get_string_size($RichTextLabel.get_parsed_text(), 0, -1, 32) + Vector2(64, 64)

func next_stage() -> void:
	var orteil = get_tree().get_meta("orteil")
	
	match text_stage:
		0:
			add_new_text("[color=#ffb629]Alright, nerd. Enough with the yakkety-yak!")
			target_position = Vector2(960 - target_size.x/2.0, 520 - target_size.y/2.0)
		1:
			add_new_text("[color=#ffb629]It's time to get [shake]paid!")
			target_position = Vector2(960 - target_size.x/2.0, 520 - target_size.y/2.0)
		2:
			add_new_text("[color=#ffb629]Forget OTU Tables... we're selling [color=#ffc555][wave]GENOMES[/wave][color=#ffb629] now!")
			target_position = Vector2(960 - target_size.x/2.0, 520 - target_size.y/2.0)
		3:
			add_new_text("[color=#ffb629]...")
			get_node("../ColorRect/AnimationPlayer").play("fade_in")
			target_position = Vector2(960 - target_size.x/2.0, 220 - target_size.y/2.0)
		4:
			add_new_text("[color=#ffb629]I've made a couple of changes to the game.")
			target_position = Vector2(960 - target_size.x/2.0, 180 - target_size.y/2.0)
		5:
			add_new_text("[color=#ffb629]I [color=#ffc555]stole[color=#ffb629] one of those beautiful [wave]mutant Voidlings[/wave] from Orteil...")
			target_position = Vector2(960 - target_size.x/2.0, 180 - target_size.y/2.0)
			
			var voidling = load("res://Prefabs/Living/voidling.tscn").instantiate()
			voidling.colour = Color("#FFB6A9")
			voidling.scale = Vector2(0.5, 0.5)
			voidling.position = get_node("../../sandbox").size/2.0
			voidling.area_center = get_node("../../sandbox").size/4.0
			get_node("../../sandbox/arena/living").add_child(voidling)
		6:
			add_new_text("[color=#ffb629]First, we're going to [color=#ffc555][wave]CULTURE[/wave][color=#ffb629] it...")
			target_position = Vector2(960 - target_size.x/2.0, 180 - target_size.y/2.0)
		7:
			add_new_text("[color=#ffb629]Then, we're going to [color=#ffc555][wave]DESTROY[/wave][color=#ffb629] it, collect that DNA, and sell the genome to Earth!")
			target_position = Vector2(960 - target_size.x/2.0, 180 - target_size.y/2.0)
		8:
			add_new_text("[color=#ffb629]It's the perfect plan! [wave]...")
			target_position = Vector2(960 - target_size.x/2.0, 180 - target_size.y/2.0)
		9:
			add_new_text("")
			target_position = Vector2(960 - target_size.x/2.0, 180 - target_size.y/2.0)
		10:
			add_new_text("[color=#ffb629]That should be enough. [color=#555][Press Enter to continue...]")
			target_position = Vector2(960 - target_size.x/2.0, 180 - target_size.y/2.0)
		11:
			add_new_text("[color=#ffb629]Hit the [color=#ffc555][shake]DESTROY[/shake][color=#ffb629] button!")
			target_position = Vector2(960 - target_size.x/2.0, 180 - target_size.y/2.0)
		12:
			add_new_text("")
			target_position = Vector2(960 - target_size.x/2.0, 180 - target_size.y/2.0)
		13:
			add_new_text("[color=#ffb629]Brilliant! Grab that DNA! [wave]... ")
			target_position = Vector2(960 - target_size.x/2.0, 180 - target_size.y/2.0)
		14:
			add_new_text("")
			target_position = Vector2(960 - target_size.x/2.0, 180 - target_size.y/2.0)
			
			waiting_for_all_destroyed = true
		15:
			add_new_text("[color=#ffb629]Great work, Gamer [wave]... ")
			target_position = Vector2(960 - target_size.x/2.0, 180 - target_size.y/2.0)
			
			get_node("../ColorRect/AnimationPlayer").play("fade_out")
			
		16:
			add_new_text("")
			target_position = Vector2(960 - target_size.x/2.0, 180 - target_size.y/2.0)
		
			$next_scene.start()
			
		_:
			print("NARRATOR: UHH??")
	
	text_stage = clamp(text_stage + 1, 0, 9 if not(get_node("../../automation").thats_enough) else (12 if not(get_node("../../automation").first_destroy) else (15 if waiting_for_all_destroyed else 999)))

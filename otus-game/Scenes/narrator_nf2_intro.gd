extends NinePatchRect

var current_text = ""
var dialogue_transition_timer = 0

var text_stage = 0
var target_position = Vector2(0, 0)
var target_size = Vector2(0, 0)

var text_scroll_progress = 0

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
		_:
			print("UHH")
	
	text_stage += 1

extends NinePatchRect

var current_text = ""
var dialogue_transition_timer = 0

var text_stage = 0
var target_position = Vector2(0, 0)
var target_size = Vector2(0, 0)

var text_scroll_progress = 0

func _ready() -> void:
	get_tree().set_meta("mutations_narrator_intro", self)
	
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
		
	#if text_stage == 0:
		#if randi()%2 == 0:
			#var lightning = load("res://Prefabs/Lightning/lightning.tscn").instantiate()
			#lightning.begin_point = target_size/2.0 + Vector2(1, 0).rotated(2*PI*randf())
			#lightning.end_point = (target_size/2.0) + Vector2(300 * randf(), 0).rotated((target_size/2.0).angle_to_point(lightning.begin_point))
			#lightning.show_behind_parent = true
			#lightning.modulate = Color("ffd493ff").darkened(randf())
			#add_child(lightning)

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
			add_new_text("[color=#aaa]so, I says,")
			target_position = Vector2(1150 - target_size.x/2.0, 550 - target_size.y)
		1:
			add_new_text("[shake][color=#ffb629]Sequencer?!")
			target_position = Vector2(1150 - target_size.x/2.0, 550 - target_size.y)
		2:
			add_new_text("[shake][color=#ffb629]I hardly know 'er!")
			target_position = Vector2(1150 - target_size.x/2.0, 550 - target_size.y)
		3:
			add_new_text("[color=#aaa]Ha ha.")
			target_position = Vector2(1525 - target_size.x/2.0, 550 - target_size.y)
		4:
			add_new_text("[color=#aaa]You're so funny.")
			target_position = Vector2(1525 - target_size.x/2.0, 550 - target_size.y)
		5:
			add_new_text("[color=#aaa]I know.")
			target_position = Vector2(1150 - target_size.x/2.0, 550 - target_size.y)
			
			orteil.queue_dialogue_after_walk("", true, 1, 0, "mt_intro", 2)
			orteil.walk_to(Vector2(560, 711))
			
			$startle.start()
		_:
			print("UHH")
	
	text_stage += 1

func _on_startle_timeout():
	add_new_text("[shake][color=#ffb629]...")
	target_position = Vector2(800 - target_size.x/2.0, 350 - target_size.y)
	
	get_node("../../living/voidling/GPUParticles2D").emitting = true
	get_node("../../living/voidling/AnimatedSprite2D").visible = false
	get_node("../../living/voidling2/GPUParticles2D").emitting = true
	get_node("../../living/voidling2/AnimatedSprite2D").visible = false

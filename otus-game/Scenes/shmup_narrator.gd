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
	
func _process(delta: float) -> void:
	dialogue_transition_timer = max(dialogue_transition_timer - delta, 0)
	text_scroll_progress = clamp(text_scroll_progress + delta, 0, 1)
	
	modulate.a = lerp(modulate.a, 0.0 if current_text == "" else 1.0, 0.1)
	
	position = lerp(position, target_position, 0.1)
	size = lerp(size, target_size, 0.1)
	
	$RichTextLabel.visible_ratio = text_scroll_progress
	
	if Input.is_action_just_pressed("dialogue_activate") and dialogue_transition_timer == 0:
		next_stage()

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
			add_new_text("[wave][color=#ffc555]Ah, forget it... [/color][/wave][color=#777][Press Enter to continue...]")
			target_position = Vector2(960 - target_size.x/2.0, 175)
		1:
			add_new_text("[wave][color=#aaa]This game is a complete waste of my time.")
			target_position = Vector2(960 - target_size.x/2.0, 175)
		2:
			add_new_text("[wave][color=#aaa]... and probably yours as well.")
			target_position = Vector2(960 - target_size.x/2.0, 175)
		3:
			add_new_text("[wave][color=#aaa]... but if you really want something to do, ...")
			target_position = Vector2(960 - target_size.x/2.0, 200)
		4:
			add_new_text("[wave][color=#ffb629]Why don't you help me clean up all these Voidlings?")
			target_position = Vector2(960 - target_size.x/2.0, 210)
		5:
			add_new_text("")
			target_position = Vector2(960 - target_size.x/2.0, -0)
			
			get_node("../../living/ironman").enable()
		_:
			print("UHH")
	
	text_stage += 1

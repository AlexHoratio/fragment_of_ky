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
			add_new_text("[color=#aaa]OPTIONAL CONTENT:[color=#fff] [wave]'Creature Features'")
			target_position = Vector2(960 - target_size.x/2.0, 150)
		_:
			print("UHH")
	
	text_stage += 1

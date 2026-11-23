extends Control

# rule_panel's resting layout (right half of the 1920x1080 screen, 60px margin) is set in the scene.
const PANEL_SLIDE_TIME = 0.7
const CAMERA_PAN_TIME = 0.5

@onready var rule_panel: Control = $CanvasLayer/rule_panel
@onready var camera: Camera2D = $movable_camera
@onready var rule_text: RichTextLabel = $CanvasLayer/rule_panel/rule_text

var panel_rest_x = 0.0

func _ready():
	panel_rest_x = rule_panel.position.x

func _process(delta):
	pass

func say(text) -> void:
	Chat.spawn_message(text)

func show_rule_panel() -> void:
	# Start offscreen on the right, then slide in with a little jelly overshoot.
	rule_panel.position.x = get_viewport_rect().size.x + 40
	rule_panel.visible = true
	$CanvasLayer/rule_panel/title.visible_ratio = 0.0
	$CanvasLayer/rule_panel/underline.scale.x = 0.0
	rule_text.visible_characters = 0

	var slide = create_tween()
	slide.tween_property(rule_panel, "position:x", panel_rest_x, PANEL_SLIDE_TIME) \
		.set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)

	# Re-center the camera so both kyztlings sit in the middle of the free left area.
	var kai: Node2D = $living/kai
	var anonymi: Node2D = $living/anonymi
	var kyz_mid_x = (kai.global_position.x + anonymi.global_position.x) / 2.0
	var free_area_center_x = panel_rest_x / 2.0
	var pan = create_tween()
	pan.tween_property(camera, "position:x", kyz_mid_x - free_area_center_x, CAMERA_PAN_TIME) \
		.set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)

	# Once the board has landed, write "RULE 1" onto it and underline it.
	slide.tween_interval(0.3)
	slide.tween_property($CanvasLayer/rule_panel/title, "visible_ratio", 1.0, 0.6)
	slide.tween_property($CanvasLayer/rule_panel/underline, "scale:x", 1.0, 0.35) \
		.set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)
	
	# Then the rule itself: only the "VIBE CODE EVERYTHING!!!!!" part for now.
	slide.tween_interval(0.4)
	slide.tween_callback(reveal_rule_text_up_to.bind("!!!!!", 1.0))

# The rest of rule_text is revealed in stages from the fade_in animation track.
func reveal_rule_also() -> void:
	reveal_rule_text_up_to("YOU", 0.6)

func reveal_rule_hashtags() -> void:
	reveal_rule_text_up_to("", 1.2)

# Types rule_text on up to the end of `marker` (or the whole text if marker is "").
func reveal_rule_text_up_to(marker: String, duration: float) -> void:
	var parsed = rule_text.get_parsed_text()
	var target = parsed.length()
	if marker != "":
		var idx = parsed.find(marker, max(rule_text.visible_characters, 0))
		if idx != -1:
			target = idx + marker.length()
	var tween = create_tween()
	tween.tween_property(rule_text, "visible_characters", target, duration)

# Contents fade away, then the board swells to cover the whole screen and goes black.
func blackout_rule_panel() -> void:
	var contents = create_tween().set_parallel()
	for child in rule_panel.get_children():
		if child.name != "board":
			contents.tween_property(child, "modulate:a", 0.0, 1.0)
	
	# Overshoot the screen edges a little so the jellypatch's rounded corners don't show.
	var overscan = 40.0
	var screen = get_viewport_rect().size
	var grow = create_tween().set_parallel()
	grow.tween_property(rule_panel, "position", Vector2(-overscan, -overscan), 0.5) \
		.set_delay(0.2).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_IN)
	grow.tween_property(rule_panel, "size", screen + Vector2(overscan, overscan) * 2.0, 0.5) \
		.set_delay(0.2).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_IN)
	grow.tween_property($CanvasLayer/rule_panel/board, "self_modulate", Color(0, 0, 0, 1), 0.5) \
		.set_delay(0.2)

func _on_animation_player_animation_finished(anim_name):
	if anim_name == "fade_in":
		get_tree().change_scene_to_file("res://Scenes/rule_2.tscn")

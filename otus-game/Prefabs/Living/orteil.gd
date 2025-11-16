extends CharacterBody2D

signal done_talking

var target_position = Vector2(0, 0)
var walk_speed = 150

var seeking_destination = false
var orteil_ready = true

var text_scroll_progress = 0
var text_reveal_speed = 1
var after_walk_timer = 0
var after_talk_timer = 0

var prev_dialogue = ""

func _ready() -> void:
	target_position = position
	get_tree().set_meta("orteil", self)
	
	done_talking.connect(finished_talking)
	
func _process(delta: float) -> void:
	var movement_vector = Vector2(0, 0)
	
	if global_position.distance_to(target_position) > 15:
		movement_vector = Vector2(1, 0).rotated(global_position.angle_to_point(target_position))
	else:
		if seeking_destination:
			seeking_destination = false
			orteil_ready = true
	
	if !seeking_destination and orteil_ready:
		after_walk_timer = max(after_walk_timer - delta, 0)
		
		if after_walk_timer == 0:
			text_scroll_progress = clamp(text_scroll_progress + delta*text_reveal_speed, 0, 1)
	
	if text_scroll_progress == 1 and $dialogue/RichTextLabel.visible_ratio != 1:
		emit_signal("done_talking")
	
	$dialogue/RichTextLabel.visible_ratio = text_scroll_progress
	
	velocity = movement_vector * walk_speed
	move_and_slide()
	
	update_shadow_pos()
	
func update_shadow_pos() -> void:
	if velocity.x < 0:
		$AnimatedSprite2D.flip_h = true
	if velocity.x > 0:
		$AnimatedSprite2D.flip_h = false
	
	var target_anim = "walk" if velocity.length() > 15 else "idle"
	
	if $AnimatedSprite2D.animation != target_anim:
		$AnimatedSprite2D.play(target_anim)

func walk_to(new_target) -> void:
	if orteil_ready:
		target_position = new_target
		seeking_destination = true
		orteil_ready = false

func queue_dialogue_after_walk(new_text, reset_text_scroll_progress = true, new_text_reveal_speed = 1, new_after_walk_timer = 1, new_prev_dialogue = "", new_after_talk_timer = 1) -> void:
	$dialogue/RichTextLabel.text = new_text
	
	if reset_text_scroll_progress:
		text_scroll_progress = 0
		text_reveal_speed = new_text_reveal_speed
		$dialogue/RichTextLabel.visible_ratio = text_scroll_progress
	
	after_walk_timer = new_after_walk_timer
	after_talk_timer = new_after_talk_timer
	
	prev_dialogue = new_prev_dialogue
	
func finished_talking() -> void:
	$after_talk_timer.start(after_talk_timer)

func _on_after_talk_timer_timeout() -> void:
	match prev_dialogue:
		"six_bases":
			walk_to(global_position + Vector2(0, 50))
			queue_dialogue_after_walk("""Count up the [color=#aaa][wave]Frequencies[/wave][color=white] of all
the different [color=#2D73FF]Marker Gene Variants[color=white]
in the community.

[color=pink][wave](Click on them all.)""", true, 0.2)
		"viewed_all_voidlings":
			queue_dialogue_after_walk("""Now, let's do it again, on a 
[rainbow sat=0.5][shake][wave]different world...""", true, 0.2, 1, "different_world")
		"different_world":
			get_tree().get_meta("fader").fade_out()
		_:
			pass

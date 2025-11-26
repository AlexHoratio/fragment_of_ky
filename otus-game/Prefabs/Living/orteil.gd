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
	
	if text_scroll_progress >= 0.999 and $dialogue/RichTextLabel.visible_ratio != 1:
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

func queue_dialogue_after_walk(new_text, reset_text_scroll_progress = true, new_text_reveal_speed = 1.0, new_after_walk_timer = 1.0, new_prev_dialogue = "", new_after_talk_timer = 1.0) -> void:
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
		"nf_think":
			walk_to(Vector2(1330, 1010))
			queue_dialogue_after_walk("", true, 1, 1, "nf_move_along")
			
			get_node("../automation").start_automation()
			
		"nf_move_along":
			queue_dialogue_after_walk("Looks good to me.", true, 1, 0, "nf_move_along2", 3)
		"nf_move_along2":
			queue_dialogue_after_walk("", true)
			walk_to(Vector2(2100, 1010))
		"nf1_end_calm_down":
			walk_to(Vector2(1630, 995))
			queue_dialogue_after_walk("""You see, these [color=#aaa]OTU Tables[color=#fff] are nearly [color=red][wave]meaningless[/wave][color=#fff] for Earthlings.""", true, 0.4, 0.3, "nf1_end_dev_interrupt")
		"nf1_end_dev_interrupt":
			var narrator_interrupt = load("res://Prefabs/UI/Narrators/narrator_interrupt.tscn").instantiate()
			get_parent().add_child(narrator_interrupt)
			narrator_interrupt.add_new_text("[color=#ffb629][shake level=50]WHAT?!")
			narrator_interrupt.scale = Vector2(2, 2)
			narrator_interrupt.target_position = Vector2(960 - narrator_interrupt.target_size.x, 540 - narrator_interrupt.target_size.x)
			get_node("../ColorRect/AnimationPlayer").play("partial_fadeout")
			
			walk_to(Vector2(1630, 995))
			queue_dialogue_after_walk("Well, think of it this way.", true, 1, 6, "nf1_end_thinkofit", 3)
		"nf1_end_thinkofit":
			var narrator_interrupt = get_node("../narrator_interrupt")
			narrator_interrupt.add_new_text("")
			narrator_interrupt.target_position = Vector2(960 - narrator_interrupt.target_size.x, 540 - narrator_interrupt.target_size.x)
			
			queue_dialogue_after_walk("Do you really think that [color=#aaa]this[color=#fff] genome...", true, 1, 0, "nf1_end_this_genome", 3)
			
		"nf1_end_this_genome":
			get_node("../CanvasLayer/this_genome").showing = true
			queue_dialogue_after_walk("... and [color=#aaa]that[color=#fff] genome ...", true, 1, 3, "nf1_end_and_this_genome", 3)
			
		"nf1_end_and_this_genome":
			get_node("../CanvasLayer/that_genome").showing = true
			queue_dialogue_after_walk("... would do the same thing?", true, 1, 0.5, "nf1_end_same_thing", 6)
		"nf1_end_same_thing":
			queue_dialogue_after_walk("[wave]Of course not!", true, 1, 0, "nf1_end_ofcnot", 2)
		"nf1_end_ofcnot":
			queue_dialogue_after_walk("[wave]They're completely different!", true, 1, 0, "nf1_end_completely_different", 3)
		"nf1_end_completely_different":
			queue_dialogue_after_walk("To get to the bottom of this, we're going to need to take a [rainbow sat=0.5][wave]closer look at these genomes...", true, 0.25, 0, "nf1_end_closer_look", 3)
		"nf1_end_closer_look":
			get_node("../CanvasLayer/ColorRect/AnimationPlayer").play("fade_out")
		"gv_has_genome":
			queue_dialogue_after_walk("A [color=#aaa]genome[color=#fff] is made out of a [color=#87e3ff]sequence[color=#fff] of [color=#aaa][wave]DNA bases[/wave][color=#fff].", true, 0.4, 0, "gv_sequence", 8)
		"gv_sequence":
			queue_dialogue_after_walk("It is this exact sequence of [color=#aaa][wave]bases[/wave][color=#fff] that defines how a creature grows.", true, 0.4, 0, "gv_determine_creature", 8)
		"gv_determine_creature":
			queue_dialogue_after_walk("... On Earth, that is.", true, 1, 0, "gv_onearth", 1)
		"gv_onearth":
			queue_dialogue_after_walk("This happens by the way of [color=#87e3ff][wave]genes[/wave][color=#fff].", true, 0.4, 0, "gv_genes", 7)
		"gv_genes":
			queue_dialogue_after_walk("A [color=#87e3ff][wave]gene[/wave][color=#fff] is just a small section of the genome, which \"codes for\" some particular thing.", true, 0.4, 0, "gv_codesfor", 5)
		_:
			pass

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
			add_new_text("[shake level=25]Enough is enough! [/shake][color=#777][Press Enter to continue...]")
			target_position = Vector2(960 - target_size.x/2.0, 175)
		1:
			add_new_text("[shake level = 5]Every one of my precious [color=#ffb629]Voidlings[/color] is unique...")
			target_position = Vector2(960 - target_size.x/2.0, 75)
			get_parent().get_parent().enable_voidlings()
		2:
			add_new_text("No two are the same! [wave]...")
			target_position = Vector2(960 - target_size.x/2.0, 75)
		3:
			add_new_text("Although, I must admit...")
			target_position = Vector2(960 - target_size.x/2.0, 75)
		4:
			add_new_text("Some of them are really, really, similar.")
			target_position = Vector2(960 - target_size.x/2.0, 125)
		5:
			add_new_text("[color=#ffb629][wave]How could I possibly keep track of all these?! ...")
			target_position = Vector2(960 - target_size.x/2.0, 125)
		6:
			add_new_text("")
			target_position = Vector2(960, -40)
			get_tree().get_meta("orteil").walk_to(Vector2(960, 630))
			get_tree().get_meta("orteil").queue_dialogue_after_walk("""Hello! My name is [color=pink]Orteil[/color]. 
I will teach you how to organize
these Voidlings into 
[wave][color=yellow]Operational Taxonomic Units[color=white].""", true, 0.2, 1.5)
		7:
			if orteil.get_node("dialogue/RichTextLabel").visible_ratio == 1:
				orteil.queue_dialogue_after_walk("""The [color=yellow][wave]Operational Taxonomic Unit[/wave][color=white]
(or, [color=yellow][wave]OTU[/wave][/color]) is a concept developed
by Earthlings to group closely
related individuals.""", true, 0.2)
			else:
				return
		8:
			if orteil.get_node("dialogue/RichTextLabel").visible_ratio == 1:
				orteil.queue_dialogue_after_walk("""On Earth, every living thing
has a [color=#aaa]unique DNA sequence[color=white].

[wave][color=pink]Click on a Voidling to view
its genome!""", true, 0.2)
			else:
				return
				
			for voidling in get_tree().get_nodes_in_group("voidlings"):
				voidling.enable_clicking()
		9:
			if !get_node("../otu_table").locked:
				if orteil.get_node("dialogue/RichTextLabel").visible_ratio == 1:
					orteil.queue_dialogue_after_walk("""The first six bases of this genome
are going to be our [color=#2D73FF][wave]Marker Gene[/wave][color=white].

We'll use variants of the [color=#2D73FF]Marker
Gene[color=white] to define our [color=yellow]OTU[color=white].""", true, 0.2, 1, "six_bases", 5)
				else:
					return
			else:
				return
		10:
			if get_node("../otu_table").viewed_voidlings.size() == get_parent().get_parent().max_voidlings:
				if orteil.get_node("dialogue/RichTextLabel").visible_ratio == 1:
					orteil.queue_dialogue_after_walk("""[rainbow sat=0.5][shake]Great work![/shake][/rainbow]

Check out the [color=yellow]OTU Table[/color] tab
to view the composition of
this community.""", true, 0.2, 1, "viewed_all_voidlings", 4)
				else:
					return
			else:
				return
		_:
			print("UHH")
	
	text_stage += 1

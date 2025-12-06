extends CharacterBody2D

signal done_talking

var target_position = Vector2(0, 0)
var walk_speed = 150

@export var target_scale = Vector2(1, 1)

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
	
	if !$after_talk_timer.is_stopped() and Input.is_action_just_pressed("ui_accept") and after_walk_timer == 0 and text_scroll_progress == 1:
		$after_talk_timer.start(0.01)
	
	$dialogue/RichTextLabel.visible_ratio = text_scroll_progress
	
	velocity = movement_vector * walk_speed
	move_and_slide()
	
	scale = lerp(scale, target_scale, 0.2)
	
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
		"gv_codesfor":
			queue_dialogue_after_walk("[wave]Would you like to know [rainbow sat=0.5]more?", true, 0.4, 0, "gv_creaturefeatures", 0)
			
			var orteil_longver_creaturefeatures = load("res://Prefabs/UI/Narrators/orteil_longver_creaturefeatures.tscn").instantiate()
			get_parent().add_child(orteil_longver_creaturefeatures)
		"gv_awesome":
			queue_dialogue_after_walk("Unlike us, [color=#aaa][wave]Earthlings[/wave][color=#fff] aren't made of [shake val=5][color=#B800AC]special psychic energy.", true, 0.4, 0, "gv_long_psychic_potential", 6)
		"gv_long_psychic_potential":
			queue_dialogue_after_walk("Instead, they are made of these weird bubbly things called '[color=#aaa]atoms[color=#fff]' and '[color=#aaa]molecules[color=#fff]'.", true, 0.4, 0, "gv_long_atoms", 6)
		"gv_long_atoms":
			queue_dialogue_after_walk("There are loads of molecules: [wave]...", true, 1, 0, "gv_long_loads_of_molecules", 4)
		"gv_long_loads_of_molecules":
			queue_dialogue_after_walk("Lipids [color=#aaa][wave](like fats and oils)[/wave][color=#fff] ...", true, 1, 0, "gv_long_lipids", 2)
		"gv_long_lipids":
			queue_dialogue_after_walk("... nucleic acids [color=#aaa][wave](like in DNA)[/wave][color=#fff] ...", true, 1, 0, "gv_long_dna", 2)
		"gv_long_dna":
			queue_dialogue_after_walk("... sugars [color=#aaa][wave](yummy)[/wave][color=#fff] ...", true, 1, 0, "gv_long_sugars", 2)
		"gv_long_sugars":
			queue_dialogue_after_walk("... and most importantly, [color=#ff7e57][wave]PROTEINS[/wave][color=#fff]!", true, 1, 0, "gv_long_proteins", 6)
		"gv_long_proteins":
			queue_dialogue_after_walk("[color=#aaa][wave]Proteins[/wave][color=#fff] are the best molecules.", true, 0.7, 0, "gv_long_proteins_best", 4)
		"gv_long_proteins_best":
			queue_dialogue_after_walk("They make up the complex [color=#aaa]molecular machinery[color=#fff] of the cell.", true, 0.7, 0, "gv_long_molmach", 7)
		"gv_long_molmach":
			queue_dialogue_after_walk("Proteins can do anything from [wave]...", true, 1, 0, "gv_long_anythingfrom", 3)
		"gv_long_anythingfrom":
			get_node("../CanvasLayer/atp_synthase").open = true
			queue_dialogue_after_walk("... generating energy ...", true, 1, 0, "gv_long_atpsynthase", 8)
		"gv_long_atpsynthase":
			get_node("../CanvasLayer/dna_binding").open = true
			queue_dialogue_after_walk("... to protecting DNA ...", true, 1, 0, "gv_long_dna_binding", 8)
		"gv_long_dna_binding":
			queue_dialogue_after_walk("... to piercing and injecting [wave]goop[/wave] into enemy cells.", true, 1, 0, "gv_long_goop", 8)
		"gv_long_goop":
			get_node("../CanvasLayer/atp_synthase").open = false
			get_node("../CanvasLayer/dna_binding").open = false
			queue_dialogue_after_walk("[color=#ff7e57]Proteins[color=#fff] are what genes [color=#aaa]\"code for\"[color=#fff].", true, 1, 0, "gv_long_genescodefor", 6)
		"gv_long_genescodefor":
			queue_dialogue_after_walk("You see, proteins are long strings of [color=#aaa][wave]amino acids[color=#fff].", true, 1, 0, "gv_long_longstring", 6)
		"gv_long_longstring":
			queue_dialogue_after_walk("For this reason, you might also hear them being called '[color=#aaa][wave]polypeptide chains[/wave][color=#fff]'.", true, 1, 0, "gv_long_polypeptide", 6)
		"gv_long_polypeptide":
			queue_dialogue_after_walk("In fact, the way that a gene codes for a protein is so [rainbow sat=0.5][wave]amazing[/wave][/rainbow] to Earthlings, that they call it [wave]...", true, 0.4, 0, "gv_long_theycallit", 6)
		"gv_long_theycallit":
			queue_dialogue_after_walk("... '[color=#B800AC][wave]Central Dogma[/wave][color=#fff]'", true, 0.4, 0, "gv_long_central_dogma", 9)
		"gv_long_central_dogma":
			queue_dialogue_after_walk("[color=#B800AC][wave]Central Dogma[/wave][color=#fff] is very simple.", true, 0.4, 0, "gv_long_cd_simple", 6)
		"gv_long_cd_simple":
			queue_dialogue_after_walk("First, a gene is copied-- or, '[color=#aaa][wave]transcribed[/wave][color=#fff]' into [color=#aaa]RNA[color=#fff].", true, 0.4, 0, "gv_long_transcribed", 4)
		"gv_long_transcribed":
			queue_dialogue_after_walk("Next, the RNA '[color=#aaa]transcript[color=#fff]' is [color=#aaa]translated[color=#fff] into a protein sequence.", true, 0.4, 0, "gv_long_protein_seq", 6)
		"gv_long_protein_seq":
			queue_dialogue_after_walk("In short, every [rainbow sat=0.5][wave]3 DNA bases[/wave][/rainbow] codes for [rainbow sat=0.5][wave]1 amino acid[/wave][/rainbow] in the protein.", true, 0.4, 0, "gv_long_base_per_aa", 7)
		"gv_long_base_per_aa":
			queue_dialogue_after_walk("Finally, the protein [color=#aaa]floats off[color=#fff], [color=#aaa]folds itself up[color=#fff], and goes on to fulfill its [color=#aaa]cellular purpose[color=#fff].", true, 0.4, 0, "gv_longver", 10)
		"gv_longver":
			queue_dialogue_after_walk("Anyway, for now, let's focus on the biology of our [color=#ffb629][wave]Voidlings[/wave][color=#fff].", true, 1, 0, "gv_voidling_bio", 6)
		"gv_voidling_bio":
			queue_dialogue_after_walk("These [color=#ffb629]Voidlings[color=#fff] have genes coding for...", true, 1, 0, "gv_voidling_genes_for", 4)
		"gv_voidling_genes_for":
			get_node("../genome/coldjellypatch/colour_gene").enabled = true
			queue_dialogue_after_walk("... [color=#ffb629][wave]colour[/wave][color=#fff] ...", true, 1, 0, "gv_voidling_genes_colour", 4)
		"gv_voidling_genes_colour":
			get_node("../genome/coldjellypatch2/hp_gene").enabled = true
			queue_dialogue_after_walk("... [color=#ff295e][wave]health[/wave][color=#fff] ...", true, 1, 0, "gv_voidling_genes_health", 4)
		"gv_voidling_genes_health":
			get_node("../genome/coldjellypatch2/speed_gene").enabled = true
			queue_dialogue_after_walk("... and [color=#29ff9b][wave]speed[/wave][color=#fff] ...", true, 1, 0, "gv_voidling_genes_speed", 4)
		"gv_voidling_genes_speed":
			get_node("../AnimationPlayer").play("pulse")
			queue_dialogue_after_walk("In fact, there is still much of the Voidling genome that we [color=#aaa][wave]don't understand yet...", true, 0.7, 0, "gv_voidling_genes_dont_understand", 6)
		"gv_voidling_genes_dont_understand":
			var narrator_interrupt = load("res://Prefabs/UI/Narrators/gv_narrator_interrupt.tscn").instantiate()
			get_parent().add_child(narrator_interrupt)
			
			narrator_interrupt.add_new_text("[color=#ffb629][wave]... ... ...")
			narrator_interrupt.target_position = Vector2(960 - narrator_interrupt.target_size.x/2.0, 450 - narrator_interrupt.target_size.x/2.0)
			
			queue_dialogue_after_walk("", true, 0.7, 0, "gv_silence", 5)
			
		"gv_silence":
			get_tree().get_meta("gv_narrator_interrupt").next_stage()
			queue_dialogue_after_walk("Anyway,", true, 0.5, 0, "gv_silence_anyway", 4)
			
		"gv_silence_anyway":
			queue_dialogue_after_walk("[rainbow sat=0.5]Random mutations[/rainbow] in these genes drive evolution.", true, 0.5, 0, "gv_mutations", 6)
		"gv_mutations":
			queue_dialogue_after_walk("[wave]Let's take a look at an [color=#aaa]example...", true, 0.5, 0, "gv_example", 3)
		"gv_example":
			get_node("../CanvasLayer/ColorRect/AnimationPlayer").play("fade_out")
		"mt_intro":
			var narrator_intro = get_node("../../CanvasLayer/mutations_narrator_intro")
			narrator_intro.add_new_text("[shake][color=#ffb629]Hi, Orteil.")
			narrator_intro.target_position = Vector2(800 - narrator_intro.target_size.x/2.0, 350 - narrator_intro.target_size.y)
			
			queue_dialogue_after_walk("Wtf are you doing.", true, 1, 3, "mt_weird", 1.5)
		"mt_weird":
			queue_dialogue_after_walk("Anyway,", true, 1, 0, "mt_anyway", 1)
		"mt_anyway":
			var narrator_intro = get_node("../../CanvasLayer/mutations_narrator_intro")
			narrator_intro.add_new_text("")
			narrator_intro.target_position = Vector2(800 - narrator_intro.target_size.x/2.0, 350 - narrator_intro.target_size.y)
			
			get_node("../voidling").queue_free()
			get_node("../voidling2").queue_free()
			
			queue_dialogue_after_walk("Let's take a closer look at [color=#ffb629]Gilzork[color=#fff].", true, 0.7, 0, "mt_gilzork_intro", 4)
			
			var voidling = load("res://Prefabs/Living/voidling.tscn").instantiate()
			voidling.enable_clicking()
			voidling.no_click_message = true
			voidling.position = Vector2(960, 200) + Vector2((960 - 400) * randf(), (1080 - 400) * randf())
			voidling.clicked.connect(get_node("../../CanvasLayer/mutations_genome_viewer").view_voidling_genome.bind(voidling))
			get_parent().add_child(voidling)
			
			target_scale = Vector2(1, 1)
			walk_to(Vector2(960, 911))
			
		"mt_gilzork_intro":
			queue_dialogue_after_walk("Click on [color=#ffb629]Gilzork[color=#fff] to view his [color=#005BDF][wave]genome[/wave][color=#fff].", true, 0.7, 0, "mt_click_gilzork", 6)
		
		_:
			pass

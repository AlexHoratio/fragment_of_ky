extends CharacterBody2D

signal clicked

var spawn_momentum = Vector2(0, 0)
var otu_shove_momentum = Vector2(0, 0)

var movement_vector = Vector2(0, 0)
var walk_speed = 75
var hp = 1
var colour = Color("ffb629")

var click_enabled = false
var hovering = false

var no_click_message = false

var debug = false

var clicked_once = false
@export var acting = false

var genome = {
	"marker": "",
	"junk": ""
}

func _ready() -> void:
	randomize()
	
	generate_genome()
	
	$AnimatedSprite2D.self_modulate = colour
	
	if debug:
		enable_clicking()
	
	if !acting:
		$GPUParticles2D.emitting = true
		spawn_momentum = Vector2(256, 0).rotated(2*PI*randf())
	
	for voidling in get_tree().get_nodes_in_group("voidlings"):
		add_collision_exception_with(voidling)
		
	
func _process(delta: float) -> void:
	spawn_momentum *= 0.98
	otu_shove_momentum *= 0.95
	
	if spawn_momentum.length() < 0.01:
		spawn_momentum = Vector2(0, 0)
		
	if get_tree().has_meta("otu_table"):
		if global_position.y > get_tree().get_meta("otu_table").get_node("body").global_position.y:
			otu_shove_momentum += Vector2(0, -20)
	
	velocity = otu_shove_momentum + spawn_momentum + movement_vector * walk_speed
	move_and_slide()
	
	update_shadow_pos()
	
	$AnimatedSprite2D.scale = lerp($AnimatedSprite2D.scale, Vector2(2.5, 2.5) if hovering else Vector2(2, 2), 0.15)
	$AnimatedSprite2D/mask.modulate.a = lerp($AnimatedSprite2D/mask.modulate.a, 0.2 if hovering else 0.0, 0.1)
	
	$AnimatedSprite2D/mask.flip_h = $AnimatedSprite2D.flip_h
	$AnimatedSprite2D/mask.animation = $AnimatedSprite2D.animation
	$AnimatedSprite2D/mask.frame = $AnimatedSprite2D.frame
	
func update_shadow_pos() -> void:
	if velocity.x < 0:
		$AnimatedSprite2D.flip_h = true
	if velocity.x > 0:
		$AnimatedSprite2D.flip_h = false
	
	var target_anim = "walk" if velocity.length() > 15 else "idle"
	
	if $AnimatedSprite2D.animation != target_anim:
		$AnimatedSprite2D.play(target_anim)

func generate_genome() -> void:
	var marker_genes = ["ATCGTG", "ATCGTA", "ATCGTT"]
	genome["marker"] = marker_genes[randi()%marker_genes.size()]
	
	var nucs = ["A", "T", "C", "G"]
	
	var spacer = ""
	for i in range(2):
		spacer += nucs[randi()%4]
	genome["junk"] += spacer
		
	var colour_gene = convert_colour_to_gene(colour) # 12 chars
	genome["junk"] += colour_gene
	
	spacer = ""
	for i in range(2):
		spacer += nucs[randi()%4]
	genome["junk"] += spacer
	
	var hp_gene = convert_int_to_gene(hp, 5)
	genome["junk"] += hp_gene
	
	spacer = ""
	for i in range(2):
		spacer += nucs[randi()%4]
	genome["junk"] += spacer
	
	var speed_gene = convert_int_to_gene(walk_speed, 5)
	genome["junk"] += speed_gene
	
	for i in range(46):
		genome["junk"] += ["A", "T", "C", "G"][randi()%4]
	
	#print("MY GENOME IS....")
	#print(genome)

func convert_colour_to_gene(col=Color("FFFFFF")) -> String:
	var gene = ""
	
	var col_hex = col.to_html(false)
	var col_dec = col_hex.hex_to_int()
	
	return convert_int_to_gene(col_dec, 12)
	
func convert_int_to_gene(val = 0, min_gene_length = 4) -> String:
	var gene = ""
	
	var base_4 = ""
	var quotient = int(val)
	while int(quotient) != 0:
		var remainder = quotient - ((int(quotient) / 4) * 4)
		quotient = (int(quotient) / 4)
		base_4 = str(int(remainder)) + base_4 
	
	var nucs = ["A", "T", "C", "G"]
	for char in base_4:
		gene += nucs[int(char)]
	
	while gene.length() < min_gene_length:
		gene = "A" + gene
	
	return gene

func convert_gene_to_int(gene: String) -> int:
	var number = 0
	
	var nucs_map = {"A": 0, "T": 1, "C": 2, "G": 3}
	
	for i in range(gene.length()):
		var num = nucs_map[gene[gene.length() - 1 - i]]
		number += num * pow(4, i)
	
	return number

func enable_clicking() -> void:
	click_enabled = true
	$Button.visible = true

func click(suppress_message = false) -> void:
	clicked_once = true
	$AnimatedSprite2D/mask.modulate.a = 1
	emit_signal("clicked")
	
	if !suppress_message:
		var kyztling_text = load("res://Prefabs/UI/kyztling_text.tscn").instantiate()
		#kyztling_text.global_position = global_position
		kyztling_text.text = "[wave]+1 " + str(genome["marker"]) + "!"
		kyztling_text.position = Vector2(0, 0)
		kyztling_text.global_position.x -= kyztling_text.size.x/2.0
		kyztling_text.global_position.y -= 64
		kyztling_text.fade_speed = 2.25
		kyztling_text.move_speed = 50
		add_child(kyztling_text)

func reproduce(mutate=false) -> void:
	
	var new_voidling = load("res://Prefabs/Living/voidling.tscn").instantiate()
	new_voidling.position = position + Vector2(32, 0)
	new_voidling.no_click_message = no_click_message
	new_voidling.clicked.connect(get_node("../../CanvasLayer/mutations_genome_viewer").view_voidling_genome.bind(new_voidling))
	if click_enabled:
		new_voidling.enable_clicking()
	
	get_parent().add_child(new_voidling)
	
	if !mutate:
		new_voidling.genome = genome
	
	position -= Vector2(32, 0)
	
	var reproduce_effect = load("res://Prefabs/UI/censor_bar.tscn").instantiate()
	reproduce_effect.position = position.lerp(new_voidling.position, 0.5)
	get_parent().add_child(reproduce_effect)
	

func _on_button_mouse_entered() -> void:
	hovering = true

func _on_button_mouse_exited() -> void:
	hovering = false

func _on_button_pressed() -> void:
	click(no_click_message)

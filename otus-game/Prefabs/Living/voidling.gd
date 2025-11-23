extends CharacterBody2D

signal clicked

var spawn_momentum = Vector2(0, 0)
var otu_shove_momentum = Vector2(0, 0)

var movement_vector = Vector2(0, 0)
var walk_speed = 75

var click_enabled = false
var hovering = false

var debug = false

var clicked_once = false

var genome = {
	"marker": "",
	"junk": ""
}

func _ready() -> void:
	randomize()
	
	generate_genome()
	
	if debug:
		enable_clicking()
	
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
	
	for i in range(74):
		genome["junk"] += ["A", "T", "C", "G"][randi()%4]
	
	print("MY GENOME IS....")
	print(genome)

func enable_clicking() -> void:
	click_enabled = true
	$Button.visible = true

func click() -> void:
	clicked_once = true
	$AnimatedSprite2D/mask.modulate.a = 1
	emit_signal("clicked")

func _on_button_mouse_entered() -> void:
	hovering = true

func _on_button_mouse_exited() -> void:
	hovering = false

func _on_button_pressed() -> void:
	click()

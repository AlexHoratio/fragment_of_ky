extends Control

var current_voidling = null
var genome_text = ""
var marker_color = Color("#2D73FF")

var first_voidling_clicked = false

func _ready() -> void:
	pass

func _process(delta: float) -> void:
	position = lerp(position, Vector2(1576, -565) if current_voidling == null else Vector2(1576, 30), 0.1)

func view_voidling_genome(voidling, refresh=false) -> void:
	$RichTextLabel.text = ""
	
	if !refresh:
		if current_voidling == voidling:
			current_voidling = null
			get_tree().get_meta("reticle").set_target(null, Vector2(0, -16))
			return
	
	#get_node("../otu_table").view_new_voidling(voidling)
	
	current_voidling = voidling
	get_tree().get_meta("reticle").set_target(voidling, Vector2(0, -16))
	
	var raw_genome_text = voidling.genome["marker"] + voidling.genome["junk"]
	genome_text = ""
	
	for i in range(raw_genome_text.length()):
		if i == 0:
			genome_text += "[color=#" + str(marker_color.to_html(false)) + "][url=marker]"
		elif i == 6:
			genome_text += "[/url][color=#aaa]"
		
		elif i == 8:
			genome_text += "[color=#" + str(voidling.colour.to_html(false)) + "]"
		elif i == 20:
			genome_text += "[color=#aaa]"
		
		elif i == 22:
			genome_text += "[color=#ff295e]"
		elif i == 27:
			genome_text += "[color=#aaa]"
		
		elif i == 29:
			genome_text += "[color=#29ff9b]"
		elif i == 34:
			genome_text += "[color=#aaa]"
	
		genome_text += raw_genome_text[i]
	
	#genome_text = "[color=#" + str(marker_color.to_html(false)) + "][url=marker]" + voidling.genome["marker"] + "[/url][color=#aaa]" + voidling.genome["junk"]
	
	for i in range(genome_text.length()):
		$RichTextLabel.text += genome_text[i]

func _on_rich_text_label_meta_hover_ended(meta: Variant) -> void:
	if meta == "marker":
		marker_color = Color("#2D73FF")
	
	view_voidling_genome(current_voidling, true)

func _on_rich_text_label_meta_hover_started(meta: Variant) -> void:
	if meta == "marker":
		marker_color = Color.SKY_BLUE
	
	view_voidling_genome(current_voidling, true)

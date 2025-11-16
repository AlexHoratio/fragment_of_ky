extends Control

var hovered = false
var locked = true
var open = false

var debug = false

var viewed_voidlings = []

func _ready() -> void:
	get_tree().set_meta("otu_table", self)
	
	if debug: 
		locked = false
		open = true
	
	generate_table()
	
func _process(delta: float) -> void:
	position.y = lerp(position.y, 100.0 if locked else (-275.0 if open else 0.0), 0.1)
	$tab/mask.self_modulate.a = lerp($tab/mask.self_modulate.a, 0.15 if hovered else 0.0, 0.2)
	
	arrange_cells(delta)
	
func arrange_cells(delta: float) -> void:
	for row in $body/rows.get_children():
		row.position.y = lerp(row.position.y, row.get_index() * 64.0, 0.1)
		row.size.y = lerp(row.size.y, 64.0, 0.1)
		
		for cell in row.get_children():
			cell.size.x = lerp(cell.size.x, 164.0, 0.1)
			cell.position.x = lerp(cell.position.x, cell.get_index() * 164.0, 0.1)
	
func generate_table() -> void:
	create_row("colnames", ["OTU Name", "Frequency"])
	
func create_row(row_name, cells = []) -> void:
	if !$body/rows.has_node(row_name):
		var colnames_node = Control.new()
		colnames_node.name = row_name
		$body/rows.add_child(colnames_node)
		
	for cell_text in cells:
		var otu_table_cell = load("res://Prefabs/UI/otu_table_cell.tscn").instantiate()
		otu_table_cell.cell_text = cell_text
		otu_table_cell.locked = true
			
		get_node("body/rows/" + row_name).add_child(otu_table_cell)
	
func view_new_voidling(voidling) -> void:
	if !(voidling in viewed_voidlings):
		viewed_voidlings.append(voidling)
		if !$body/rows.has_node(voidling.genome["marker"]):
			var otu_discovered = load("res://Prefabs/UI/kyztling_text.tscn").instantiate()
			otu_discovered.text = "[rainbow][wave]OTU Discovered!"
			otu_discovered.global_position = get_global_mouse_position()
			otu_discovered.global_position.x -= otu_discovered.size.x/2.0
			otu_discovered.global_position.y -= 32
			get_parent().get_parent().add_child(otu_discovered)
			
			create_row(voidling.genome["marker"], [voidling.genome["marker"], "1"])
		else:
			var plus_one = load("res://Prefabs/UI/kyztling_text.tscn").instantiate()
			plus_one.text = "[wave]+1 " + str(voidling.genome["marker"]) + "!"
			plus_one.global_position = get_global_mouse_position()
			plus_one.global_position.x -= plus_one.size.x/2.0
			plus_one.global_position.y -= 32
			get_parent().get_parent().add_child(plus_one)
			
			var freq_cell = get_node("body/rows/" + voidling.genome["marker"]).get_child(1)
			freq_cell.set_text(str(int(freq_cell.get_text()) + 1))
			
	
func _on_tab_button_pressed() -> void:
	if !locked:
		open = !open

func _on_tab_button_mouse_entered() -> void:
	hovered = true

func _on_tab_button_mouse_exited() -> void:
	hovered = false

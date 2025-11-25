extends NinePatchRect

var hovering = false
var open = false

var first_time_sell = true

var results = {
	"otu_tables": 0
}

func _ready():
	pass
	
func _process(delta):
	open = true
	var any_results = false
	for result_type in results.keys():
		if results[result_type] > 0:
			any_results = true
			break
			
	position.y = lerp(position.y, (1030.0 if open else 1078.0) if any_results else 1250.0, 0.2)
	
	$tab/mask.self_modulate.a = lerp($tab/mask.self_modulate.a, 0.1 if hovering else 0.0, 0.1)
	
	update_ui()
	
func update_ui() -> void:
	$otus.text = "OTU Tables: " + str(results["otu_tables"])
	$sell/sell.text = "Sell All (" + str(int(round(get_value_of_results()))) + "g)"

func download_result(new_results) -> void:
	for result_type in new_results.keys():
		results[result_type] += new_results[result_type]

func sell_results() -> void:
	Gold.add_gold(get_value_of_results())
	for result_type in results.keys():
		results[result_type] = 0
		
	if first_time_sell:
		first_time_sell = false
		
		var narrator = load("res://Prefabs/UI/Narrators/narrator_nf1_end.tscn").instantiate()
		get_node("../CanvasLayer").add_child(narrator)
		narrator.next_stage()
	
func get_value_of_results() -> float:
	var value = 0
	
	value += results["otu_tables"]
	
	return value
	
func _on_open_tab_mouse_entered():
	hovering = true

func _on_open_tab_mouse_exited():
	hovering = false

func _on_open_tab_pressed():
	open = !open

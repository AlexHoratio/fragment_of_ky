extends NinePatchRect

var hovering = false
var open = false

var results = 0

func _ready():
	pass
	
func _process(delta):
	position.y = lerp(position.y, (1040.0 if open else 1078.0) if results > 0 else 1250.0, 0.2)
	
	$tab/mask.self_modulate.a = lerp($tab/mask.self_modulate.a, 0.1 if hovering else 0.0, 0.1)

func download_result() -> void:
	results += 1

func _on_open_tab_mouse_entered():
	hovering = true

func _on_open_tab_mouse_exited():
	hovering = false

func _on_open_tab_pressed():
	open = !open

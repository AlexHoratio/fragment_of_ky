extends CanvasLayer

func _ready():
	pass
	
func _process(delta):
	if Input.is_action_just_pressed("ui_select"):
		spawn_message("ioufjdsoijfd")
	
func spawn_message(text: String) -> void:
	var chat_message = load("res://Prefabs/UI/chat_message.tscn").instantiate()
	chat_message.text = text
	chat_message.position = Vector2(-1920, 1000)
	add_child(chat_message)

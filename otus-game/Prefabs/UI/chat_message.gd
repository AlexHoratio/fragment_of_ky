extends Control

var scroll_speed = 25
var fade_speed = 0.02
var text = ""

func _ready():
	$RichTextLabel.text = text
	
func _process(delta):
	modulate.a -= fade_speed * delta
	position.y -= scroll_speed * delta
	
	position.x = lerp(position.x, 48.0, 0.1)
	
	for other_message in get_tree().get_nodes_in_group("chat_messages"):
		if other_message != self:
			if abs(position.y - other_message.position.y) < 32:
				if position.y > other_message.position.y:
					position.y += 16 * delta
				elif position.y < other_message.position.y:
					position.y -= 16 * delta
				else:
					position.y += (randi()%2 - 1) * 16 * delta
					

extends CharacterBody2D

var walk_speed = 420
var gun_flash_col = Color("3e3e3eff")

func _ready():
	pass
	
func _process(delta):
	var movement_vector = Vector2(0, 0)
	
	if Input.is_action_pressed("left"):
		movement_vector.x -= 1
	if Input.is_action_pressed("right"):
		movement_vector.x += 1
	if Input.is_action_pressed("up"):
		movement_vector.y -= 1
	if Input.is_action_pressed("down"):
		movement_vector.y += 1
		
	velocity = lerp(velocity, movement_vector * walk_speed, 0.2)
	move_and_slide()
	
	if movement_vector.length() > 0:
		if !$AnimatedSprite2D.is_playing() or $AnimatedSprite2D.animation == "idle":
			$AnimatedSprite2D.play("walk")
	else:
		$AnimatedSprite2D.animation = "idle"
	
	if movement_vector.x > 0:
		$AnimatedSprite2D.flip_h = false
	elif movement_vector.x < 0:
		$AnimatedSprite2D.flip_h = true
		
	gun_flash_col = lerp(gun_flash_col, Color("3e3e3eff"), 0.14)
	
	if Input.is_action_just_pressed("left_click"):
		gun_flash_col = Color("ffc555")
	
	queue_redraw()
	
func _draw():
	draw_circle(Vector2(0, -4) + Vector2(1, 0).rotated(global_position.angle_to_point(get_global_mouse_position())) * 40, 10, gun_flash_col)
	draw_circle(Vector2(0, -4) + Vector2(1, 0).rotated(global_position.angle_to_point(get_global_mouse_position())) * 40, 8, Color("202020ff"))
	
	
	

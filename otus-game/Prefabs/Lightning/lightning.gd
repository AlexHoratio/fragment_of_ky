extends Node2D

var end_point = Vector2(1920, 1080)
var begin_point = Vector2(0, 0)
var ENERGY_VALUE = 0.25
var prolog = false
#onready var player = get_tree().get_meta("player")

func _ready():
	randomize()
	
	get_node("Timer").wait_time = randf()*0.1
	randomize_points()
	#get_node("Timer").start()
		
#	if(not(prolog)):
#
#		if(randi()%2 == 0):
#			end_point = Vector2(randf()*480, 270*(randi()%2))
#		else:
#			end_point = Vector2(480*(randi()%2), randf()*270)
#
#		begin_point = player.position
#	else:
#		get_node("Line2D").default_color = Color(1, 1, 1, 1)

func randomize_points():
	var distance = begin_point.distance_to(end_point)
	var intermediary_points = int(int(distance)/7)
	var line_points = []
	var angle_from_end = begin_point.angle_to_point(end_point)
	line_points.append(end_point)
	for point in range(intermediary_points):
		var new_point = end_point + Vector2(-7*(point+1), 0).rotated(angle_from_end)
		new_point += Vector2(randf()*9, 0).rotated(2*PI*randf())
		line_points.append(new_point)
	line_points.append(begin_point)
	
	$Line2D.points = PackedVector2Array(line_points)
#	for point in $Line2D.points:
#		var boom = RESOURCES.small_pulse.instance()
#		get_node("..").add_child(boom)
#		boom.global_position = get_node("Line2D").global_position + point

func _on_Timer_timeout():
	get_node("AnimationPlayer").play("flicker")

func _on_AnimationPlayer_animation_finished(anim_name):
	queue_free()

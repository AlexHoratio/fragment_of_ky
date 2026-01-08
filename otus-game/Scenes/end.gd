extends Control

func _ready() -> void:
	$orteil.walk_to(Vector2(508, 878))
	$orteil.queue_dialogue_after_walk("That concludes our journey.", true, 0.8, 3, "end_concludes", 6)  
	
func _process(delta: float) -> void:
	pass


func _on_links_meta_clicked(meta: Variant) -> void:
	OS.shell_open(str(meta))
	
	if OS.get_name() == "HTML5":
		JavaScriptBridge.eval("window.location.href='" + str(meta) + "'")
	else:
		OS.shell_open(str(meta))


func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name == "reveal_links":
		$orteil.queue_dialogue_after_walk("[wave]Thank you for playing! [color=pink]<3", true, 0.8, 1.5, "end_thank_you", 3)
		$orteil_leave.start()

func _on_orteil_leave_timeout() -> void:
	$orteil.walk_to(Vector2(-309, 990))
	$CanvasLayer/narrator_interrupt.next_stage()

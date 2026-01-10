extends Node

const DEBUG = false
var kyztling: Object

var state: Object
var history = []

var enabled = true
var locked = false

func _ready() -> void:
	kyztling = get_parent()
	
	state = get_node("IDLE") if randi()%2 == 0 else get_node("WANDER")
	_enter_state()
	
func _enter_state() -> void:
	if !enabled:
		return
		
	if DEBUG:
		print("Entering state: ", state.name)
		
	state.fsm = self
	state.enter()
	
func change_to(new_state) -> void:
	if !enabled or locked:
		return
	
	history.append(state.name)
	state = get_node(new_state)
	_enter_state()
	
func back(): 
	if history.size() > 0:
		state = get_node(history.pop_back())
		_enter_state()
		
func _process(delta: float) -> void:
	if !enabled:
		return
		
	if state.has_method("process"):
		state.process(delta)

func _input(event: InputEvent) -> void:
	if !enabled:
		return
	
	if state.has_method("input"):
		state.input(event)

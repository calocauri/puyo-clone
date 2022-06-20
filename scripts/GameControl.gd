class_name GameControl
extends Node2D

export(Resource) var puyo_scene
export(NodePath) var spawn_point

enum { PLAYER_CONTROL, FAST_FALL, GROUP_POP, GAME_PAUSED }
var phase = PLAYER_CONTROL
var main : Puyo
var sub : Puyo
var all_puyos = []

func _physics_process(delta):
	match phase:
		PLAYER_CONTROL:
			process_player_control(delta)
		FAST_FALL:
			process_fast_fall(delta)
		GROUP_POP:
			pass
		
func process_player_control(delta):
	if not main:
		spawn_pair()
	process_input()
	process_fall(delta)
	
func process_fall(delta):
	if main.position.direction_to(sub.position) == Vector2.DOWN:
		sub.falling_process(delta, false)
		main.falling_process(delta, false)
	else:
		main.falling_process(delta, false)
		sub.falling_process(delta, false)

func process_fast_fall(delta):
	for puyo in all_puyos:
		puyo.falling_process(delta, true)
		
func spawn_pair():
	print("spawn_pair")
	var pair = []
	main = puyo_scene.instance()
	sub = puyo_scene.instance()
	self.add_child(main)
	self.add_child(sub)
	main.position = get_node(spawn_point).position
	sub.position = main.position - (12 * Vector2.UP)
	main.control = Puyo.MAIN
	sub.control = Puyo.SUB
	pair.append(main)
	pair.append(sub)
	return pair
	
func process_input():
	if Input.is_action_just_pressed("move__right"):
		main.move_right(sub)
	if Input.is_action_just_pressed("move_left"):
		main.move_left(sub)

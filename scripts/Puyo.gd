class_name Puyo, "res://puyo-blue.png"
extends Area2D

#In pixels per second
export(float) var fall_speed
export(float) var full_speed
export(NodePath) var puyo_sprite
export(NodePath) var sensor_down_close
export(NodePath) var sensor_down_far
export(NodePath) var sensor_left
export(NodePath) var sensor_right


const VERTICAL_STEP = 6
const HORIZONTAL_STEP = 16

var position_delta : float
var subordinate : bool

enum { FALLING, SNAPPING, STATIC }
var state = FALLING

enum { BLUE, PINK, YELLOW, GREEN }
var flavor = BLUE
var flavor_group = [self]

enum { MAIN, SUB, FREE }
var control = FREE

func falling_process(delta, fast_mode):
	if break_fall():
		state = SNAPPING
	var speed = fall_speed
	if fast_mode:
		speed = full_speed
	position_delta += delta * speed
	if position_delta < VERTICAL_STEP:
		return
	if state == SNAPPING:
		control = FREE
	if state == FALLING:
		position_delta -= VERTICAL_STEP
		position.y += VERTICAL_STEP
	
func break_fall():
	var areas = get_node(sensor_down_close).get_overlapping_areas()
	if areas.size() == 0:
		return false
	if not areas[0].is_in_group("Puyo"):
		return true
	return areas[0].state == SNAPPING or areas[0].state == STATIC

func merge_groups():
	for area in get_overlapping_areas():
		if not area.is_in_group("Puyo"):
			return
		var puyo = area.get_script() as Puyo
		if puyo.flavor != flavor or puyo.flavor_group == flavor_group:
			return
		for p in flavor_group:
			p.flavor_group = puyo.flavor_group
		flavor_group = puyo.flavor_group.append_array(flavor_group)
		
func move_right(sub):
	if control != MAIN:
		return print("trying to control free puyo")
		
	var direction = position.direction_to(sub.position)
	var areas = []
	match direction:
		Vector2.UP, Vector2.LEFT:
			areas = get_node(sensor_right).get_overlapping_areas()
		Vector2.DOWN, Vector2.RIGHT:
			areas = get_node(sub.sensor_right).get_overlapping_areas()
		_:
			print(direction)
	if areas.size() > 0:
		return
	position.x += HORIZONTAL_STEP
	sub.position.x += HORIZONTAL_STEP
	if state == SNAPPING:
		position_delta = 0
		sub.position_delta = 0
		
func move_left(sub):
	if control != MAIN:
		return print("trying to control free puyo")
		
	var direction = position.direction_to(sub.position)
	var areas = []
	match direction:
		Vector2.UP, Vector2.RIGHT:
			areas = get_node(sensor_left).get_overlapping_areas()
		Vector2.DOWN, Vector2.LEFT:
			areas = get_node(sub.sensor_left).get_overlapping_areas()
		_:
			print(direction)
	if areas.size() > 0:
		return
	position.x -= HORIZONTAL_STEP
	sub.position.x -= HORIZONTAL_STEP
	if state == SNAPPING:
		position_delta = 0
		sub.position_delta = 0
			
		
func rotate_right(sub):
	pass
	
func rotate_left(sub):
	pass

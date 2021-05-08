extends Node

const BALLON_FACES =[
	preload("res://asset/game/balloon/smile_1.png"),
	preload("res://asset/game/balloon/smile_2.png"),
	preload("res://asset/game/balloon/smile_3.png"),
	preload("res://asset/game/balloon/smile_4.png")
]

const BALLON_POPING_FRAGMENT =[
	preload("res://asset/game/poping/cicle.png"),
	preload("res://asset/game/poping/star.png")
]

onready var _rng = RandomNumberGenerator.new()
onready var _bg = $bg
onready var _spawn_position = $balloon_spawn_point
onready var _cloud_spawn_point = $cloud_spawn_point
onready var _timer = $Timer
onready var _score = $Label

onready var _screen_size = get_viewport().get_visible_rect().size

var score = 0
var missed = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	spawn_initial_cloud()

func _on_Timer_timeout():
	spawn_balloon(get_random_x())
	if _rng.randf() <= 0.1:
		spawn_cloud(get_random_y())

func spawn_initial_cloud():
	_rng.randomize()
	for i in 5:
		var _pos = Vector2(_rng.randf_range(-900, _screen_size.x),_rng.randf_range(50 , _screen_size.y))
		spawn_cloud(_pos)

func spawn_balloon(from):
	var balloon = preload("res://asset/game/balloon/balloon.tscn").instance()
	balloon.set_appearance(BALLON_FACES[_rng.randf_range(0, BALLON_FACES.size())],Color(randf(), randf(), randf(), 1))
	balloon.lauching(_rng.randf_range(100 , 300),from)
	balloon.connect("on_ballon_pop",self,"_on_ballon_pop")
	balloon.connect("on_ballon_missed",self,"_on_ballon_missed")
	_spawn_position.add_child(balloon)

func spawn_cloud(from):
	var cloud = preload("res://asset/game/cloud/cloud.tscn").instance()
	cloud.position = from
	_cloud_spawn_point.add_child(cloud)

func spawn_poping_fragment(color,at):
	var poping = preload("res://asset/game/poping/poping.tscn").instance()
	poping.create_fragment(BALLON_POPING_FRAGMENT[_rng.randf_range(0, BALLON_POPING_FRAGMENT.size())],color,5)
	poping.position = at
	add_child(poping)

func _on_ballon_pop(color,pos):
	spawn_poping_fragment(color, pos)
	score += 1
	display_score()
 
func _on_ballon_missed():
	missed += 1
	display_score()

func display_score():
	_score.text = "Score : " + str(score) + "\nMissed : " + str(missed)

func get_random_x():
	_rng.randomize()
	var x = _spawn_position.rect_global_position.x
	var y = _spawn_position.rect_global_position.y
	var x_size = _spawn_position.rect_size.x 
	x = _rng.randf_range(x + 250 , x + x_size - 250)
	return Vector2(x,y)

func get_random_y():
	_rng.randomize()
	var x = _cloud_spawn_point.rect_global_position.x
	var y = _cloud_spawn_point.rect_global_position.y
	var y_size = _cloud_spawn_point.rect_size.y
	y = _rng.randf_range(y + 50 , y + y_size - 250)
	return Vector2(x,y)
	
func _on_TextureRect_gui_input(event):
	get_viewport().unhandled_input(event)


func _on_TextureButton_pressed():
	get_tree().change_scene("res://asset/menu/menu.tscn")

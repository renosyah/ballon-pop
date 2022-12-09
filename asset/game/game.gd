extends Node

const baloon = preload("res://asset/game/balloon/balloon.tscn")
const cloud = preload("res://asset/game/cloud/cloud.tscn")
const popping = preload("res://asset/game/poping/poping.tscn")

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
	randomize()
	spawn_initial_cloud()
	
func _on_Timer_timeout():
	spawn_balloon(get_random_x())
	
	if randf() > 0.8:
		spawn_cloud(get_random_y())
		
func spawn_initial_cloud():
	for i in 5:
		var _pos = Vector2(
			rand_range(-900, _screen_size.x),
			rand_range(50 , _screen_size.y)
		)
		spawn_cloud(_pos)
		
func spawn_balloon(from):
	var balloon_instance = baloon.instance()
	balloon_instance.set_appearance(
		BALLON_FACES[rand_range(0, BALLON_FACES.size())],
		Color(randf(), randf(), randf(), 1)
	)
	balloon_instance.connect("on_ballon_pop",self,"_on_ballon_pop")
	balloon_instance.connect("on_ballon_missed",self,"_on_ballon_missed")
	_spawn_position.add_child(balloon_instance)
	balloon_instance.lauching(rand_range(100 , 300),from)
	
func spawn_cloud(from):
	var cloud_instance = cloud.instance()
	_cloud_spawn_point.add_child(cloud_instance)
	cloud_instance.position = from
	
func spawn_poping_fragment(color, at):
	var popping_instance = popping.instance()
	popping_instance.texture = BALLON_POPING_FRAGMENT[
		rand_range(0, BALLON_POPING_FRAGMENT.size())
	]
	popping_instance.color = color
	popping_instance.amount = rand_range(4, 8)
	add_child(popping_instance)
	popping_instance.position = at
	
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
	var x = _spawn_position.rect_global_position.x
	var y = _spawn_position.rect_global_position.y
	var x_size = _spawn_position.rect_size.x 
	x = rand_range(x + 150 , x + x_size -150)
	return Vector2(x,y)

func get_random_y():
	var x = _cloud_spawn_point.rect_global_position.x
	var y = _cloud_spawn_point.rect_global_position.y
	var y_size = _cloud_spawn_point.rect_size.y
	y = rand_range(y + 50 , y + y_size - 250)
	return Vector2(x,y)

func _on_TextureButton_pressed():
	get_tree().change_scene("res://asset/menu/menu.tscn")

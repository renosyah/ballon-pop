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

var balloon_pools :Array = []
var popping_pools :Array = []

var score = 0
var missed = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	randomize()
	spawn_initial_cloud()
	pooling_balloon()
	pooling_poping()
	
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
		
func pooling_balloon():
	for i in range(20):
		var balloon_instance :Balloon = baloon.instance()
		balloon_instance.face_texture = BALLON_FACES[rand_range(0, BALLON_FACES.size())]
		balloon_instance.color = Color(randf(), randf(), randf(), 1)
		balloon_instance.connect("on_ballon_pop", self, "_on_ballon_pop")
		balloon_instance.connect("on_ballon_missed", self, "_on_ballon_missed")
		_spawn_position.add_child(balloon_instance)
		balloon_pools.append(balloon_instance)
	
func pooling_poping():
	for i in range(20):
		var popping_instance :Popping = popping.instance()
		popping_instance.texture = BALLON_POPING_FRAGMENT[
			rand_range(0, BALLON_POPING_FRAGMENT.size())
		]
		popping_instance.color = Color(randf(), randf(), randf(), 1)
		popping_instance.amount = rand_range(4, 8)
		add_child(popping_instance)
		popping_pools.append(popping_instance)
	
func spawn_balloon(from :Vector2):
	balloon_pools.shuffle()
	for balloon_pool in balloon_pools:
		if not balloon_pool.visible:
			balloon_pool.global_position = from
			balloon_pool.hp = int(rand_range(1,3))
			balloon_pool.speed = rand_range(100, 300)
			balloon_pool.launch()
			return
	
func spawn_poping_fragment(color :Color, from:Vector2):
	for popping_pool in popping_pools:
		if not popping_pool.is_emitting():
			popping_pool.global_position = from
			popping_pool.color = color
			popping_pool.pop()
			return
	
func spawn_cloud(from):
	var cloud_instance = cloud.instance()
	_cloud_spawn_point.add_child(cloud_instance)
	cloud_instance.position = from
	
func _on_ballon_pop(bal :Balloon):
	spawn_poping_fragment(bal.color, bal.global_position)
	score += 1
	display_score()
 
func _on_ballon_missed(bal :Balloon):
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

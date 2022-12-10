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

onready var _spawn_position = $balloon_spawn_point
onready var _timer = $Timer
onready var _score = $ui_panel/score
onready var _hp = $ui_panel/hp
onready var _lose_panel = $lose_panel
onready var _ui_panel = $ui_panel
onready var _hurt = $hurt
onready var _http_request = $HTTPRequest

var balloon_pools :Array = []
var popping_pools :Array = []

var score :int = 0
var hp :int = 10
var max_hp :int = 10

# Called when the node enters the scene tree for the first time.
func _ready():
	_lose_panel.visible = false
	_ui_panel.visible = true
	
	randomize()
	pooling_balloon()
	pooling_poping()
	display_score()
	
	_timer.wait_time = rand_range(0.5,1.5)
	_timer.start()
	
func _on_Timer_timeout():
	spawn_balloon(get_random_x())
	_timer.wait_time = rand_range(0.5,1.5)
	_timer.start()
	
func pooling_balloon():
	for i in range(20):
		var balloon_instance :Balloon = baloon.instance()
		balloon_instance.connect("on_ballon_pop", self, "_on_ballon_pop")
		balloon_instance.connect("on_ballon_missed", self, "_on_ballon_missed")
		_spawn_position.add_child(balloon_instance)
		balloon_pools.append(balloon_instance)
	
func pooling_poping():
	for i in range(20):
		var popping_instance :Popping = popping.instance()
		add_child(popping_instance)
		popping_pools.append(popping_instance)
	
func spawn_balloon(from :Vector2):
	balloon_pools.shuffle()
	for balloon_pool in balloon_pools:
		if not balloon_pool.visible:
			balloon_pool.global_position = from
			balloon_pool.face_texture = BALLON_FACES[rand_range(0, BALLON_FACES.size())]
			balloon_pool.color = Color(randf(), randf(), randf(), 1)
			balloon_pool.hp = int(rand_range(2, 6))
			balloon_pool.speed = rand_range(100, 300)
			balloon_pool.launch()
			return
	
func spawn_poping_fragment(color :Color, from:Vector2):
	for popping_pool in popping_pools:
		if not popping_pool.is_emitting():
			popping_pool.global_position = from
			popping_pool.color = color
			popping_pool.texture = BALLON_POPING_FRAGMENT[
				rand_range(0, BALLON_POPING_FRAGMENT.size())
			]
			popping_pool.amount = rand_range(4, 8)
			popping_pool.pop()
			return
			
func _on_ballon_pop(bal :Balloon):
	if bal.is_dead:
		score += 1
		display_score()
		spawn_poping_fragment(bal.color, bal.global_position)
 
func _on_ballon_missed(bal :Balloon):
	if _lose_panel.visible:
		return
		
	if hp < 2:
		WebGameModule.update_scoreboard(score)
		_lose_panel.visible = true
		_ui_panel.visible = false
		_timer.stop()
		
	else:
		hp -= 1
		_hurt.show_hurt()
		
	display_score()

func display_score():
	_score.text = "Score : " + str(score)
	_hp.text = "Hp : " + str(hp)

func get_random_x():
	var x = _spawn_position.rect_global_position.x
	var y = _spawn_position.rect_global_position.y
	var x_size = _spawn_position.rect_size.x 
	x = rand_range(x + 150 , x + x_size -150)
	return Vector2(x,y)

func _on_TextureButton_pressed():
	get_tree().change_scene("res://asset/menu/menu.tscn")

func _on_try_again_pressed():
	score = 0
	hp = max_hp
	display_score()
	_lose_panel.visible = false
	_ui_panel.visible = true
	_timer.wait_time = rand_range(0.5,1.5)
	_timer.start()
	

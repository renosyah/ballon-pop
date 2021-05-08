extends Node

onready var _rng = RandomNumberGenerator.new()
onready var _bg = $bg
onready var _cloud_spawn_point = $cloud_spawn_point
onready var _timer = $Timer

onready var _screen_size = get_viewport().get_visible_rect().size

# Called when the node enters the scene tree for the first time.
func _ready():
	spawn_initial_cloud()

func _on_Timer_timeout():
	if _rng.randf() <= 0.1:
		spawn_cloud(get_random_y())

func spawn_initial_cloud():
	_rng.randomize()
	for i in 5:
		var _pos = Vector2(_rng.randf_range(-900, _screen_size.x),_rng.randf_range(50 , _screen_size.y))
		spawn_cloud(_pos)

func spawn_cloud(from):
	var cloud = preload("res://asset/game/cloud/cloud.tscn").instance()
	cloud.position = from
	_cloud_spawn_point.add_child(cloud)

func get_random_y():
	_rng.randomize()
	var x = _cloud_spawn_point.rect_global_position.x
	var y = _cloud_spawn_point.rect_global_position.y
	var y_size = _cloud_spawn_point.rect_size.y
	y = _rng.randf_range(y + 50 , y + y_size - 50)
	return Vector2(x,y)

func _on_TextureRect_gui_input(event):
	get_viewport().unhandled_input(event)


func _on_TextureButton_pressed():
	get_tree().change_scene("res://asset/game/game.tscn")

extends Node

onready var _bg = $bg
onready var _cloud_spawn_point = $cloud_spawn_point
onready var _timer = $Timer
onready var _screen_size = get_viewport().get_visible_rect().size

# Called when the node enters the scene tree for the first time.
func _ready():
	randomize()
	spawn_initial_cloud()

func _on_Timer_timeout():
	if randf() > 0.8:
		spawn_cloud(get_random_y())
	
func spawn_initial_cloud():
	for i in 5:
		var _pos = Vector2(
			rand_range(-900, _screen_size.x),
			rand_range(50 , _screen_size.y)
		)
		spawn_cloud(_pos)

func spawn_cloud(from):
	var cloud = preload("res://asset/game/cloud/cloud.tscn").instance()
	cloud.position = from
	_cloud_spawn_point.add_child(cloud)

func get_random_y():
	var x = _cloud_spawn_point.rect_global_position.x
	var y = _cloud_spawn_point.rect_global_position.y
	var y_size = _cloud_spawn_point.rect_size.y
	y = rand_range(y + 50 , y + y_size - 50)
	return Vector2(x,y)


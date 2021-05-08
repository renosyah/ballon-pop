extends Node2D

onready var _rng = RandomNumberGenerator.new()
onready var _pos = $Position2D

var _texture : Texture
var _color : Color
var _size : int

# Called when the node enters the scene tree for the first time.
func _ready():
	_rng.randomize()
	for i in _size:
		var _scatter_x = _pos.position.x + _rng.randf_range(_rng.randf_range(-100,-50), _rng.randf_range(100,50))
		var _scatter_y = _pos.position.y + _rng.randf_range(_rng.randf_range(-100,-50), _rng.randf_range(100,50))
		var sprite = Sprite.new()
		sprite.texture = _texture
		sprite.position = Vector2(_scatter_x,_scatter_y)
		sprite.self_modulate = _color
		_pos.add_child(sprite)

func create_fragment(texture : Texture, color : Color, size : int):
	_texture = texture
	_color = color
	_size = size
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	for child in _pos.get_children():
		child.position.y += 100 * delta
		child.self_modulate.a -= 0.005


func _on_Timer_timeout():
	queue_free()

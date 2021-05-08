extends Area2D

signal on_ballon_pop(color, pos)
signal on_ballon_missed()

onready var _ballon = $Sprite
onready var _face = $Sprite/Sprite
onready var _audio = $AudioStreamPlayer2D

var speed = 200.0
var direction = Vector2.ZERO

var _is_popping = false
var _face_texture : Texture = preload("res://asset/game/balloon/smile_1.png")
var _color : Color = Color(randf(), randf(), randf(), 1)

func set_appearance(face_texture : Texture, color : Color):
	_face_texture = face_texture
	_color = color

func lauching(_speed : float, _from : Vector2):
	position = _from
	speed = _speed
	
# Called when the node enters the scene tree for the first time.
func _ready():
	_ballon.self_modulate = _color
	_face.texture = _face_texture

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	position.y -= speed * delta


func _on_balloon_input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton and event.is_action_pressed("left_click"):
		if _is_popping:
			return
		
		speed = 0
		_ballon.visible = false
		_audio.play()
		_is_popping = true
		emit_signal("on_ballon_pop", _color, global_position)

func _on_AudioStreamPlayer2D_finished():
	queue_free()


func _on_VisibilityNotifier2D_screen_exited():
	if _is_popping:
		return
	emit_signal("on_ballon_missed")
	queue_free()

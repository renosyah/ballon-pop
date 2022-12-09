extends Area2D
class_name Balloon

signal on_ballon_pop(baloon)
signal on_ballon_missed(baloon)

export var hp :int
export var speed :float
export var face_texture :Texture
export var color :Color

onready var _ballon = $Sprite
onready var _face = $Sprite/Sprite
onready var _audio = $AudioStreamPlayer2D

var is_dead: bool = false

# Called when the node enters the scene tree for the first time.
func _ready():
	is_dead = true
	visible = false
	set_process(false)
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	position.y -= speed * delta
	
func launch():
	_ballon.self_modulate = color
	_face.texture = face_texture
	is_dead = false
	visible = true
	set_process(true)

func set_dead():
	is_dead = true
	visible = false
	set_process(false)

func _on_balloon_input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton and event.is_action_pressed("left_click"):
		if is_dead:
			return
			
		hp -= 1
		
		if hp < 0:
			set_dead()
		
		_audio.play()
		emit_signal("on_ballon_pop", self)
		
func _on_VisibilityNotifier2D_screen_exited():
	if is_dead:
		return
		
	set_dead()
	emit_signal("on_ballon_missed", self)
	



extends Area2D
class_name Balloon

signal on_ballon_pop(baloon, click_pos)
signal on_ballon_missed(baloon)

const pop = preload("res://asset/game/balloon/balloon-pop.wav")
const gone = preload("res://asset/game/balloon/balloon-gone.wav")
const click = preload("res://asset/game/balloon/balloon-click.wav")

export var hp :int
export var speed :float
export var face_texture :Texture
export var color :Color

onready var _ballon = $Sprite
onready var _face = $Sprite/Sprite
onready var _audio = $AudioStreamPlayer2D
onready var _tween = $Tween

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
	if not _audio.playing:
		_audio.stream = pop
		_audio.play()
		
	is_dead = true
	visible = false
	set_process(false)
	
func make_pop(at :Vector2):
	if not _audio.playing:
		_audio.stream = click
		_audio.play()
		
	_tween.interpolate_property(_ballon,"scale" ,Vector2.ONE * 0.8, Vector2.ONE * 1, 0.4, Tween.TRANS_BOUNCE)
	_tween.start()
	
	emit_signal("on_ballon_pop", self, at)
	
func _on_balloon_input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton and event.is_action_pressed("left_click"):
		if is_dead:
			return
			
		hp -= 1
		
		if hp < 1:
			set_dead()
			
		make_pop(event.position)
		
func _on_VisibilityNotifier2D_screen_exited():
	if is_dead:
		return
		
	if not _audio.playing:
		_audio.stream = gone
		_audio.play()
	
	set_dead()
	emit_signal("on_ballon_missed", self)
	






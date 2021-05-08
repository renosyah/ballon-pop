extends Sprite

var speed = 150.0
var direction = Vector2.ZERO

# Called when the node enters the scene tree for the first time.
func _ready():
	var _scale = randf()
	scale.x = _scale
	scale.y = _scale
	speed = rand_range(50,100)
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	position.x -= speed * delta

func _on_VisibilityNotifier2D_screen_exited():
	yield()
	queue_free()
 

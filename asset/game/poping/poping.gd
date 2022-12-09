extends Node2D
class_name Popping

export var texture : Resource
export var color : Color
export var amount : int

onready var cpu_particles_2d = $CPUParticles2D
onready var timer = $Timer

# Called when the node enters the scene tree for the first time.
func _ready():
	pass
	
func is_emitting() -> bool:
	return not timer.is_stopped()
	
func pop():
	cpu_particles_2d.texture = texture
	cpu_particles_2d.color = color
	cpu_particles_2d.amount = amount
	cpu_particles_2d.emitting = true
	timer.start()
 

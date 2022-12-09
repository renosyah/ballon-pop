extends Node2D

export var texture : Resource
export var color : Color
export var amount : int

onready var cpu_particles_2d = $CPUParticles2D

# Called when the node enters the scene tree for the first time.
func _ready():
	cpu_particles_2d.texture = texture
	cpu_particles_2d.color = color
	cpu_particles_2d.amount = amount
	cpu_particles_2d.emitting = true
	
func _on_Timer_timeout():
	queue_free()

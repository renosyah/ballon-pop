extends Node

onready var _player_name = $VBoxContainer/player_name

# Called when the node enters the scene tree for the first time.
func _ready():
	_player_name.text = "Hello " + Global.player_name

func _on_TextureButton_pressed():
	get_tree().change_scene("res://asset/game/game.tscn")
	
func _on_scoreboard_pressed():
	get_tree().change_scene("res://asset/scoreboard/scoreboard.tscn")

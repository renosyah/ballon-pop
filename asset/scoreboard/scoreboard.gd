extends Node

onready var _http_request = $HTTPRequest
onready var holder = $VBoxContainer/ScrollContainer/VBoxContainer

var offset :int = 0
var limit :int = 10

# Called when the node enters the scene tree for the first time.
func _ready():
	get_scoreboard(offset, limit)
	
func get_scoreboard(offset, limit :int):
	var url = Global.base_url + "/api/score/list.php"
	var query = JSON.print({
		"search_by": "game_id",
		"search_value": str(Global.game_id),
		"order_by": "score",
		"order_dir": "desc",
		"offset": offset,
		"limit": limit,
	})
	var headers = ["Content-Type: application/json"]
	_http_request.request(url, headers, false, HTTPClient.METHOD_POST, query)
	
func _on_HTTPRequest_request_completed(result, response_code, headers, body):
	var json :JSONParseResult = JSON.parse(body.get_string_from_utf8())
	if not json.result is Dictionary:
		return
		
	for i in holder.get_children():
		holder.remove_child(i)
		i.queue_free()
	
	var pos :int = 1
	for i in json.result["data"]:
		var item = preload("res://asset/scoreboard/item/item.tscn").instance()
		item.num = pos
		item.player_name = i["player_name"]
		item.score = i["score"]
		holder.add_child(item)
		pos += 1
	
func _on_back_pressed():
	get_tree().change_scene("res://asset/menu/menu.tscn")

func _on_prev_pressed(): 
	if offset - limit < 0:
		return
		
	offset -= limit
	get_scoreboard(offset, limit)


func _on_next_pressed():
	offset += limit
	get_scoreboard(offset, limit)
	

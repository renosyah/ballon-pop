extends Node

const game_id = 4
const base_url = "http://192.168.100.162:8080"

var player_id :String = "guest001"
var player_name :String = "Guest"

var http_request :HTTPRequest

# Called when the node enters the scene tree for the first time.
func _ready():
	randomize()
	player_id = "random_" + str(rand_range(1, 1000))
	
	http_request = HTTPRequest.new()
	http_request.connect("request_completed", self, "_on_http_request_completed")
	add_child(http_request)
	
	if OS.has_feature('JavaScript'):
		player_id = JavaScript.eval("""
			var url_string = window.location.href;
			var url = new URL(url_string);
			url.searchParams.get('player_id');
		""")
		
		player_name = JavaScript.eval("""
				var url_string = window.location.href;
				var url = new URL(url_string);
				url.searchParams.get('player_name');
			""")

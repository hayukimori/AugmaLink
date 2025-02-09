extends Node

signal got_new_message(from: String, content: String)
@export var message_send_url: String = "http://"
@onready var http_request: HTTPRequest = $HTTPRequest


var websocket_url = "ws://127.0.0.1:8080" # Replace with actual server address and port
var socket := WebSocketPeer.new()

@export var user_id = "player123"


var registered: bool = false



func _ready():
	if socket.connect_to_url(websocket_url) != OK:
		print("Could not connect.")
		set_process(false)
	else:
		print("Connected to server")


func _process(_delta):
	socket.poll()

	await get_tree().process_frame
	if socket.get_ready_state() == WebSocketPeer.STATE_OPEN:
		if not registered:
			var register = JSON.stringify({"id": user_id})
			print(register)

			socket.send_text(register)

			registered = true
		
		while socket.get_available_packet_count():
			#print("Recv. >",socket.get_packet().get_string_from_ascii(),"<")
			got_new_message.emit("None", socket.get_packet().get_string_from_ascii())
			
	else:
		print("No state open")


func _exit_tree():
	socket.close()


func send_message(message_text: String):
	# Send "Ping!" to the server when Enter is pressed.
	
	if socket.get_ready_state() != WebSocketPeer.STATE_OPEN:
		print("You are currently not connected to the server.")
	else:
		#socket.send_text(message_text)
		var data = {"to": "py_cli", "message": message_text}
		var converted_data = JSON.stringify(data)
		socket.send_text(converted_data)




func old_send_message(message_text: String):
	var data = {
		"message": message_text
	}
	send_post(message_send_url, data)

func send_post(url: String, data: Dictionary):
	var json = JSON.stringify(data)
	var headers = ["Content-Type: application/json"]

	var error = http_request.request(url, headers, HTTPClient.METHOD_POST, json)
	if error != OK:
		print("Error sendind request:", error)


func _on_http_request_request_completed(result: int, response_code: int, _headers: PackedStringArray, body: PackedByteArray):
	if result == HTTPRequest.RESULT_SUCCESS:
		if response_code == 200: # OK
			var response = body.get_string_from_utf8()
			print("Server response: ", response)
		else:
			print("Error at response. Code: ", response_code)
	else:
		print("Fail to request. Rest: ", result)

extends Control

#signal quit_request

var message_left: PackedScene = load("res://resources/scenes/ui/message_app/message_left.tscn")
var message_right: PackedScene = load("res://resources/scenes/ui/message_app/message_right.tscn")

#enum ConnectionProtocols {TCP, WS}


@export_category("Mosquitto Connection")
#@export var current_connection_protocol: ConnectionProtocols
@export_enum("tcp://", "wss://") var connection_protocol: String = "tcp://"
@export var host: String = "localhost"
@export var port: int = 1883
@export var topic: String = "redot/examplechatroom"

#@onready var mqtt = $MQTT
@onready var messages_container: VBoxContainer = $Panel/ScrollContainer/MessagesContainer
@onready var scroll_container: ScrollContainer = $Panel/ScrollContainer
@onready var message_input_line_edit: LineEdit = $TextInputArea/Panel/MessageInput_LineEdit
@onready var send_button: Button = $TextInputArea/Panel/Send
@onready var nickname: LineEdit = $nickname

var start_server_calls: bool = false


func add_message(message: Control):
	messages_container.add_child(message)
	await get_tree().process_frame

	#scroll_container.ensure_control_visible(message)

	# tween
	var tween = create_tween()
	tween.tween_property(scroll_container, "scroll_vertical", scroll_container.get_v_scroll_bar().max_value, 0.3)


func _ready():
	# Connect signal to func _on_mqtt_received_message
	$MQTT.received_message.connect(_on_mqtt_received_message)
	print("Connected to _on_mqtt_received_message")



func load_message_received(message_text):
	# Instantiates a message scene (left side)
	var target_scene = message_left.instantiate()
	target_scene.message_text = message_text
	add_message(target_scene)


func load_message_send(message_text):
	# Instantiates a message scene (right side)
	var target_scene = message_right.instantiate()
	target_scene.message_text = message_text
	add_message(target_scene)


func append_message_to_chat(message_dict: Dictionary) -> void:
	if message_dict["user_id"] == nickname.text:
		load_message_send(message_dict['message'])
	else:
		load_message_received(message_dict['message'])


func _on_message_input_line_edit_text_submitted(new_text: String):
	send_message_mqtt(new_text)
	message_input_line_edit.clear()


func _on_quit_button_pressed():
	queue_free()


func send_message_mqtt(message: String):
	# Convers message to JSON/Dict format
	var message_dict: Dictionary = {
		"user_id": nickname.text,
		"message": message
	}

	# Send message to topic (ChatRoom)
	var message_json: String = JSON.stringify(message_dict)
	$MQTT.publish(topic, message_json)



func connect_mqtt():
	# Create a random client id to connect mqtt server
	randomize()
	$MQTT.client_id = "s%d" % randi()
	$MQTT.set_user_pass(nickname.text, "")

	var broker_address = "%s%s:%s" % [connection_protocol, host, port]
	var ret_val = $MQTT.connect_to_broker(broker_address)

	# (i don't really know what this line does.)
	$MQTT.set_last_will("godot/myname/mywill", "goodbye world", false)

	if not ret_val:
		printerr("Couldn't connect to broker address: %s" % [broker_address])
	
	
	# Wait for timer (2s) and subscribe to chat room (topic)
	await get_tree().create_timer(2).timeout
	var qos = 0
	var new_topic = topic.strip_edges()

	$MQTT.subscribe(new_topic, qos)

 
##################################################
################ DEBUG SINGALS ###################
##################################################
func _on_mqtt_broker_connected():
	print("Broker connected")

func _on_mqtt_broker_connection_failed():
	printerr("Fail to connect to broker")

func _on_mqtt_broker_disconnected():
	print("Broker disconnected.")
##################################################


func _on_mqtt_received_message(current_topic, message):
	print("received message on topic: ", current_topic)
	print(current_topic, message)

	# Message now is a json, needs to convert to Dict again
	var msg_as_dict: Dictionary = JSON.parse_string(message)

	# Add to visual chat.
	if msg_as_dict != null:
		append_message_to_chat(msg_as_dict)
	

func _on_connect_btn_pressed():
	connect_mqtt()

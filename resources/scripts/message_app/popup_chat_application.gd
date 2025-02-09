extends Control

@export_category("Showable Info")
@export var username: String = "username"
@export var timestamp: String = "NOW"
@export var message: String = "No message."

@onready var app_icon_button: Button = $top_side/app_icon_button
@onready var user_profile_picture: Button = $top_side/user_profile_picture

@onready var quit_button: Button = $buttons_side/quit_button
@onready var open_button: Button = $buttons_side/open_button

@onready var message_label: Label = $base_panel/message_label
@onready var username_label: Label = $top_side/username_label
@onready var timestamp_label: Label = $top_side/timestamp_label


func _ready():
	await get_tree().process_frame

	username_label.text = username
	timestamp_label.text = timestamp
	message_label.text = message
	
	quit_button.pressed.connect(close_popup)

func open_app():
	pass

func close_popup():
	queue_free()

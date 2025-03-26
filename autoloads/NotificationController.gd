extends Node

@export var main_controller: NotificationAreaController


func new_notification(application_name: String, app_icon: ImageTexture, content: String, persistent: bool = false) -> void:
	main_controller.new_notification(application_name, app_icon, content, persistent)


func test_notification():
	var c_name = "Chat Application"
	var c_content = "Lorem Ipsum"
	var c_texture = ImageTexture.new()

	new_notification(c_name, c_texture, c_content)

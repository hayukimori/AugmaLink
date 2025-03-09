extends Control

@onready var notifications_list_vbox = $NotificationsList

var notification_base: PackedScene = preload("res://resources/scenes/ui/notification_manager/side_noitification.tscn")


func new_notification(application_name: String, app_icon: Texture, content: String) -> void:
	
	var notification_object: Button = notification_base.instantiate()
	
	notification_object.application_name = application_name
	notification_object.application_icon = app_icon
	notification_object.content = content

	notifications_list_vbox.add_child(notification_object)


func test_notification():
	var c_name = "Chat Application"
	var c_content = "Lorem Ipsum"
	var c_texture = Texture.new()

	new_notification(c_name, c_texture, c_content)

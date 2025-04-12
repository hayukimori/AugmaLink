extends Node


func _ready() -> void:
	call_fake_popup()


func call_fake_popup() -> void:
	var popup_scene: PackedScene = load("res://resources/scenes/applications/popup_chat_application.tscn")

	var user_image: ImageTexture = UserSettingsManager.getUserImageTexture()
	var username: String = UserSettingsManager.getCurrentUser().display_name

	var pscene: Control = popup_scene.instantiate()
	pscene.username = username
	pscene.message = "Hello, world!"
	pscene.user_image = user_image

	add_child(pscene)    

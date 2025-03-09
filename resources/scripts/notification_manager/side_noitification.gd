extends Button

@export var application_name: String
@export var application_icon: Texture
@export var content: String

@onready var left_icon_btn: Button = $Icon


func _ready() -> void:
	text = content
	
	if application_icon != null:
		left_icon_btn.icon = application_icon

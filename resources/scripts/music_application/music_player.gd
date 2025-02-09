extends Control

@export_category("App configurations")
@export var song_name: String
@export var artist_name: String

@export_category("Being implemented")
@export var song_path: String = ""

@onready var application_button: Button = $base_panel/application_button
@onready var song_name_label: Label = $base_panel/song_name_label
@onready var artist_name_label: Label = $base_panel/artist_name_label
@onready var next_button: Button = $base_panel/buttons/next_button
@onready var pause_button: Button = $base_panel/buttons/pause_button
@onready var previous_button: Button = $base_panel/buttons/previous_button
@onready var quit_button: Button = $base_panel/Control/quit_button
@onready var album_art: TextureRect = $album_art


# Most important
@onready var audio_stream_player: AudioStreamPlayer = $audio_stream_player

var metadata_info: MusicMeta.MusicMetadata

func _ready():
	await get_tree().process_frame
	quit_button.pressed.connect(_quit_pressed)
	
	next_button.pressed.connect(_skip_song)
	previous_button.pressed.connect(_previous_song)
	pause_button.pressed.connect(_pause_play)
	
	new_stream()


func _process(_delta: float):
	song_name_label.text = metadata_info.title if metadata_info != null else song_name
	artist_name_label.text = metadata_info.artist if metadata_info != null else artist_name
	


func load_mp3(path):
	var file = FileAccess.open(path, FileAccess.READ)
	var sound = AudioStreamMP3.new()
	if file == null:
		return null
	
	sound.data = file.get_buffer(file.get_length())
	return sound

func new_stream():
	var current_stream = load_mp3(song_path)
	if current_stream != null:
		audio_stream_player.stream = current_stream
		audio_stream_player.play()
	
		var current_metadata := MusicMeta.get_mp3_metadata(current_stream)
		if current_metadata.error != OK:
			print("Error getting metadata: ", current_metadata.error)
		metadata_info = current_metadata
	
		if metadata_info.cover != null:
			album_art.texture = metadata_info.cover
			print("changed art texture")

func _pause_play():
	var state = audio_stream_player.stream_paused
	audio_stream_player.stream_paused = !audio_stream_player.stream_paused

func _skip_song():
	pass

func _previous_song():
	pass

func _quit_pressed():
	queue_free()

func _on_audio_stream_player_finished() -> void:
	_skip_song()

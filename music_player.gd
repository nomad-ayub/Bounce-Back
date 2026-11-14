extends AudioStreamPlayer

var playlist: Array[AudioStream] = [
	preload("res://4530733548437504.wav"),
	preload("res://6717231924379648.wav")
]
var current_track: int = 0

func _ready() -> void:
	finished.connect(_on_track_finished)
	if playlist.size() > 0:
		stream = playlist[current_track]
		play()

func _on_track_finished() -> void:
	current_track = (current_track + 1) % playlist.size()
	stream = playlist[current_track]
	play()

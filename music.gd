extends Node

@onready var tracks := $AudioStreamPlayer

func _ready() -> void:
	tracks.stream.set_sync_stream_volume(0, -80)
	tracks.stream.set_sync_stream_volume(1, 0)

func crossfade_to_airborne(audio_stream: AudioStream) -> void:
	tracks.stream.set_sync_stream_volume(1, -80)
	tracks.stream.set_sync_stream_volume(0, 0)
		

func crossfade_to_grounded(audio_stream: AudioStream) -> void:
	tracks.stream.set_sync_stream_volume(0, -80)
	tracks.stream.set_sync_stream_volume(1, 0)

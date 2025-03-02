extends Node

@onready var tracks := $AudioStreamPlayer

func _ready() -> void:
	crossfade_to_grounded()

func crossfade_to_airborne() -> void:
	tracks.stream.set_sync_stream_volume(1, -80)
	tracks.stream.set_sync_stream_volume(0, 0)
		

func crossfade_to_grounded() -> void:
	tracks.stream.set_sync_stream_volume(0, -80)
	tracks.stream.set_sync_stream_volume(1, 0)

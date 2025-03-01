extends Node2D

signal start

func _on_start_trigger_body_entered(body: Node2D) -> void:
	start.emit()

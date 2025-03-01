extends Node2D

signal die

func _on_area_2d_body_entered(body: Node2D) -> void:
	die.emit()

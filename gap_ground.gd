extends Node2D

signal ground_touched

func _on_area_2d_ground_touch_body_entered(body: Node2D) -> void:
	ground_touched.emit()

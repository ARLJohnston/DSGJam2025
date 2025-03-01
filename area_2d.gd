extends Area2D

signal player_landed(points)

@onready var triple_zone = $Bullseye
@onready var double_zone = $Double
@onready var single_zone = $Single

func _ready() -> void:
	connect("body_entered", Callable(self, "_on_body_entered"))
	#_draw_landing_zone()

func _on_body_entered(body):
	if body.is_in_group("player"):
		var points = 0
		if triple_zone.get_node("CollisionShape2D").overlaps_body(body):
			points = 300
			print("Landed in Triple Zone! +300 points")
		elif double_zone.get_node("CollisionShape2D").overlaps_body(body):
			points = 200
			print("Landed in Double Zone! +200 points")
		elif single_zone.get_node("CollisionShape2D").overlaps_body(body):
			points = 100
			print("Landed in Single Zone! +100 points")
		
		emit_signal("player_landed", points)

#func _draw_landing_zone():
	#var triple_color = Color(1, 0, 0, 0.5) # Red
	#var double_color = Color(1, 1, 0, 0.5) # Yellow
	#var single_color = Color(0, 1, 0, 0.5) # Green
#
	#var triple_shape = triple_zone.get_node("CollisionShape2D").shape
	#var double_shape = double_zone.get_node("CollisionShape2D").shape
	#var single_shape = single_zone.get_node("CollisionShape2D").shape
#
	#if triple_shape is RectangleShape2D and double_shape is RectangleShape2D and single_shape is RectangleShape2D:
		#var triple_rect = Rect2(-triple_shape.extents, triple_shape.extents * 2)
		#var double_rect = Rect2(-double_shape.extents, double_shape.extents * 2)
		#var single_rect = Rect2(-single_shape.extents, single_shape.extents * 2)
#
		#var canvas = $LandingZoneVisual
		#canvas.clear()
		#canvas.draw_rect(single_rect, single_color, true)
		#canvas.draw_rect(double_rect, double_color, true)
		#canvas.draw_rect(triple_rect, triple_color, true)

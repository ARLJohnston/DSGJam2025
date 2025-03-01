extends Node2D

signal land

@onready var landing_zone = $LandingZone
@onready var triple_zone = $LandingZone/TripleZone
@onready var double_zone = $LandingZone/DoubleZone
@onready var single_zone = $LandingZone/SingleZone

var has_scored = false

func _ready() -> void:
	pass

func _on_area_2d_body_entered(body: Node2D) -> void: 
	if not has_scored:
		print("Landed in Triple Zone! +300 points")
		has_scored = true
		land.emit()

func _on_single_body_entered(body: Node2D) -> void:
	if not has_scored:
		print("Landed in Single Zone! +100 points")
		has_scored = true
		land.emit()

func _on_double_body_entered(body: Node2D) -> void:
	if not has_scored:
		print("Landed in Double Zone! +200 points")
		has_scored = true
		land.emit()

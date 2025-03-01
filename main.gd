extends Node2D

var player_spawn: Vector2;
var ground_x_init: float;
var landing_zone_x_init : float;
var level = 1;

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	player_spawn = $Player/CharacterBody2D.position;
	ground_x_init = $GapGround.position.x;  
	landing_zone_x_init = $LandingZone.position.x; 
	
	
	$UDeadMate.connect("die", _on_die)
	$GapGround/FinishLine.connect("win", _on_win)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_win() -> void:
	print("You win.")
	
	level = level + 1;
	$GapGround.position.x = ground_x_init + 100 + (level ** 5) 
	$LandingZone.has_scored = false 
	$LandingZone.position.x = landing_zone_x_init + 100 + (level ** 5) 
	_reset_player_pos()
	
func _on_die() -> void:
	print("You dead.")
	_reset_player_pos()

func _reset_player_pos() -> void:
	$Player/CharacterBody2D.position = player_spawn; 
	$Player/CharacterBody2D._reset()
	

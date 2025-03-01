extends Node2D

var player_spawn: Vector2;
var ground_spawn_x: float;
var level = 1;

var waiting_for_player_to_stop_after_ground_hit: bool = false;
var waiting_for_post_win_timer: bool = false

func _ready() -> void:
	player_spawn = $Player/CharacterBody2D.position;
	ground_spawn_x = $GapGround.position.x;  

	$UDeadMate.connect("die", _on_die)
	$GapGround.connect("ground_touched", _on_ground_touched)

func _process(delta: float) -> void:
	# Player touched the ground and we're waiting for them to stop moving.
	if waiting_for_player_to_stop_after_ground_hit and not waiting_for_post_win_timer:
		var player_velocity: Vector2 = $Player/CharacterBody2D.velocity;
		if player_velocity.length_squared() > 0.1:
			return
		
		print("You landed!")
		
		# Wait a while to let the player mentally process their landing.
		# TODO: Disable user inputs until after here.
		get_tree().create_timer(2.0).connect("timeout", _on_win)
		waiting_for_post_win_timer = true
		
func _on_win() -> void:
	print("You win.")
	
	level = level + 1;
	$GapGround.position.x = ground_spawn_x + 100 + (level ** 5) 
	$GapGround/LandingZone.has_scored = false 
	_reset_player_pos()
	
	waiting_for_player_to_stop_after_ground_hit = false;
	waiting_for_post_win_timer = false;

func _on_ground_touched() -> void:
	waiting_for_player_to_stop_after_ground_hit = true;
	
func _on_die() -> void:
	print("You dead.")
	_reset_player_pos()

func _reset_player_pos() -> void:
	$Player/CharacterBody2D.position = player_spawn; 
	$Player/CharacterBody2D._reset()
	

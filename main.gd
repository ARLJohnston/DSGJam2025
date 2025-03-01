extends Node2D

var player_spawn: Vector2;
var ground_spawn_x: float;

var level = 1;
var gap = 0;
var distance = 0;

var start_line_spawn_y: float;
var finish_line_spawn_y: float;

var started: bool = false;
var waiting_for_player_to_stop_after_ground_hit: bool = false;
var waiting_for_post_win_timer: bool = false

func _ready() -> void:
	player_spawn = $Player/CharacterBody2D.position;
	ground_spawn_x = $GapGround.position.x;  
	
	start_line_spawn_y = $FixedGround/StartLine.global_position.y;
	finish_line_spawn_y = $GapGround/FinishLine.global_position.y;

	$FixedGround.connect("start", _on_start)
	$GapGround.connect("ground_touched", _on_ground_touched)
	$DeathZone.connect("die", _on_die)
	
	_reset()

func _process(delta: float) -> void:
	_pin_line_marker_y($FixedGround/StartLine, start_line_spawn_y)
	_pin_line_marker_y($GapGround/FinishLine, finish_line_spawn_y)
	
	if started:
		distance = $Player/CharacterBody2D.global_position.x - $FixedGround/StartTrigger.global_position.x
		distance = max(0, distance);
		var distance_text = round(distance / 100);
		
		$CanvasLayer/DistanceLabel.text = "%dm" % distance_text
		
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

	# Scale the next "level" based on our previous distance but maintain the curve.
	var next_gap = -INF;
	while next_gap < distance:
		level = level + 1;
		next_gap = 100 + (level ** 4);
	$GapGround.position.x = ground_spawn_x + next_gap;
	
	$CanvasLayer/DistanceLabel.modulate = Color.GREEN;
	
	_reset()

func _on_ground_touched() -> void:
	waiting_for_player_to_stop_after_ground_hit = true;

func _on_start() -> void:
	if started:
		printerr("Start triggered after already started!")
		return
		
	print("You've started!")
	
	$CanvasLayer/DistanceLabel.modulate = Color.WHITE;
	
	started = true
	
func _on_die() -> void:
	print("You dead.")
	
	$CanvasLayer/DistanceLabel.modulate = Color.RED;
	
	_reset()

func _reset() -> void:
	$GapGround/LandingZone.has_scored = false
	
	gap = $GapGround/FinishLine.global_position.x - $FixedGround/StartLine.global_position.x
	var gap_text = round(gap / 100);
	$CanvasLayer/LevelLabel.text = "(%dm gap)" % gap_text
	
	$Player/CharacterBody2D.position = player_spawn; 
	$Player/CharacterBody2D._reset()
	
	started = false
	waiting_for_player_to_stop_after_ground_hit = false;
	waiting_for_post_win_timer = false;
	started = false
	
func _pin_line_marker_y(line: Sprite2D, spawn_y: float):
	"""Pin a line marker (start/end) to the player sprite so that it can
	always be seen."""
	var line_size = line.get_rect().size * line.scale
	
	var player_pos = $Player/CharacterBody2D.global_position;
	var player_start_delta = spawn_y - player_pos.y;
	
	if player_start_delta >= 0:
		line.global_position.y = player_pos.y;
	else:
		line.global_position.y = spawn_y;
	

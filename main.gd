extends Node2D

var player_spawn: Vector2;
var ground_spawn_x: float;

var level = 1;
var gap = 0;
var distance = 0;
var isk = 0; 
var last_isk_added = 0; 

var start_line_spawn_y: float;
var finish_line_spawn_y: float;

var started: bool = false;
var waiting_for_player_to_stop_after_ground_hit: bool = false;
var waiting_for_post_win_timer: bool = false

@onready var stars = $Parallax2D.get_children()
@onready var land_sound = $landed
@onready var money_sound = $money
var music: AudioStream

func _ready() -> void:
	for i in range(1, randi_range(100, 250)):
		var star = stars.pick_random()
		$Parallax2D.add_child(star.duplicate())
		
	for star in $Parallax2D.get_children():
		star.position = Vector2(randi_range(10, 1980), randi_range(10, 1980))
		
	player_spawn = $Player/CharacterBody2D.position;
	ground_spawn_x = $GapGround.position.x;
	
	start_line_spawn_y = $FixedGround/StartLine.global_position.y;
	finish_line_spawn_y = $GapGround/FinishLine.global_position.y;

	$FixedGround.connect("start", _on_start)
	$GapGround.connect("ground_touched", _on_ground_touched)
	$DeathZone.connect("die", _on_die) 
	
	$ShopUI/ColorRect/MaxJumpPower.isk_updated.connect(_on_isk_updated) 
	$ShopUI/ColorRect/XJump.isk_updated.connect(_on_isk_updated) 
	$ShopUI/ColorRect/Thrusters.isk_updated.connect(_on_isk_updated) 
	$ShopUI/ColorRect/Jetpack.isk_updated.connect(_on_isk_updated) 
	
	_reset()

func _process(delta: float) -> void:
	_pin_line_marker_y($FixedGround/StartLine, start_line_spawn_y)
	_pin_line_marker_y($GapGround/FinishLine, finish_line_spawn_y)
	
	if started:
		# Keep ground underneath player incase they go miles away.
		var player_x = $Player/CharacterBody2D.global_position.x;
		var ground_follow_delta = $GapGround.global_position.x - player_x;
		if ground_follow_delta <= 0:
			$GapGround/Ground.global_position.x = player_x
		
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
		land_sound.play(0.0)
		
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
	 
	var landing_zone = $GapGround/LandingZone  
	var reward_isk = round(distance / 100 * 1.2)
	
	if ($GapGround/LandingZone.bullseye): 
		_inc_isk(reward_isk * 10, 10) 
		$GapGround/LandingZone.bullseye = false 
	elif ($GapGround/LandingZone.fivex): 
		_inc_isk(reward_isk * 5, 5)         
		$GapGround/LandingZone.fivex = false  
	elif ($GapGround/LandingZone.twox): 
		_inc_isk(reward_isk * 2, 2) 
		$GapGround/LandingZone.twox = false   
	else: 
		_inc_isk(reward_isk) 
	money_sound.play(0.0)
	
	
	$CanvasLayer/DistanceLabel.modulate = Color.GREEN;
	
	_reset()

func _on_ground_touched() -> void:
	$Player/CharacterBody2D.can_move = false;
	waiting_for_player_to_stop_after_ground_hit = true;
	Music.crossfade_to_grounded()
	

func _on_start() -> void:
	if started:
		printerr("Start triggered after already started!")
		return

	Music.crossfade_to_airborne()
	print("You've started!")
	
	$CanvasLayer/DistanceLabel.modulate = Color.WHITE;
	
	started = true
	
func _on_die() -> void:
	print("You dead.")
	
	_inc_isk(round((distance / 100) * 0.5));
	
	$CanvasLayer/DistanceLabel.modulate = Color.RED;
	
	Music.crossfade_to_grounded()
	_reset()

func _reset() -> void:
	$GapGround/Ground.position.x = 0;
	$GapGround/LandingZone.has_scored = false
	
	gap = $GapGround/FinishLine.global_position.x - $FixedGround/StartLine.global_position.x
	$CanvasLayer/LevelLabel.text = "(%dm gap)" % round(gap / 100);

	$CanvasLayer/IskLabel.text = "§%d ISK" % isk; 
	$ShopUI/ColorRect/IskLabel.text = "§%d ISK" % isk; 
	
	$Player/CharacterBody2D.position = player_spawn; 
	$Player/CharacterBody2D._reset()
	
	started = false
	waiting_for_player_to_stop_after_ground_hit = false;
	waiting_for_post_win_timer = false;
	started = false
 
func _multiply_process(isk_inc : int , multiplier : int): 
	
	$CanvasLayer/IskLabel/IskPlusLabel.animate_multiplier(isk_inc, multiplier)
	isk = isk - isk_inc + (isk_inc * multiplier) 
	$CanvasLayer/IskLabel.text = "§%d ISK" % isk; 
	$ShopUI/ColorRect/IskLabel.text = "§%d ISK" % isk;  
	
func _inc_isk(value: float, multiplier : int = 0) -> void:
	var isk_inc = round(distance / 100 * 1.2);
	isk += isk_inc; 
	$CanvasLayer/IskLabel.text = "§%d ISK" % isk; 
	$ShopUI/ColorRect/IskLabel.text = "§%d ISK" % isk; 
	 
	if (multiplier != 0): 
		$CanvasLayer/IskLabel/IskPlusLabel.animate(isk_inc);  
		get_tree().create_timer(2.0).timeout.connect(Callable(self, "_multiply_process").bind(isk_inc, multiplier))


	else:
		$CanvasLayer/IskLabel/IskPlusLabel.animate(isk_inc);
	
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
	
 
func _on_isk_updated(amount):
	isk = amount  
	$CanvasLayer/IskLabel.text = "§%d ISK" % isk; 
	$ShopUI/ColorRect/IskLabel.text = "§%d ISK" % isk; 


	

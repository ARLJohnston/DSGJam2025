extends CharacterBody2D
class_name Player;

@onready var jump_sound := $Jump

const BASE_MAX_ZOOM = 0.7;
const BASE_MIN_ZOOM = 0.2;

const SPEED = 800.0

var max_jump_charge = -2000
var jump_growth = 0
var jump_charge = 0
var jetpack_fuel = 0
var max_jetpack_fuel = 0
var thruster_fuel = 0
var max_thruster_fuel = 0
var jetpack_power = 0
var thruster_power = 0
var stretch_ratio = 1
var original_scale = Vector2()
var gravity = 980.0
var is_jumping = false
var can_move = true

var gradient_data = {
	0.0 : Color.GREEN,
	1.0 : Color.RED,
}
var gradient = Gradient.new() 

var x_jump_upgrade = 0 
var x_jump_used = 0 


func _ready() -> void:
	original_scale = $DirectionArrow.scale
	gradient.offsets = gradient_data.keys()
	gradient.colors = gradient_data.values() 
	
	SignalManager.x_jump_upgraded.connect(_on_x_jump_upgraded)
  
func _on_x_jump_upgraded(level):  
	print("jump upgraded")
	x_jump_upgrade = level 
	x_jump_used = x_jump_upgrade
	
func _reset() -> void:
	velocity = Vector2(0,0)
		
	jump_charge = 0
	jump_growth = -0.25 * max_jump_charge
	jetpack_fuel = max_jetpack_fuel
	thruster_fuel = max_thruster_fuel
	if max_thruster_fuel != 0:
		get_parent().get_parent().get_node("CanvasLayer/ThrusterFuel").value = (thruster_fuel/max_thruster_fuel)
	if max_jetpack_fuel != 0:
		get_parent().get_parent().get_node("CanvasLayer/JetpackFuel").value = (jetpack_fuel/max_jetpack_fuel)
	is_jumping = false
	can_move = true; 
	x_jump_used = x_jump_upgrade
	
	$Camera2D.zoom = Vector2(BASE_MAX_ZOOM, BASE_MAX_ZOOM);

func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity.y += gravity * delta
		if Input.is_action_pressed("ui_accept") and jetpack_fuel > 0:
			velocity.y -= jetpack_power
			jetpack_fuel -= delta
			if max_jetpack_fuel != 0:
				get_parent().get_parent().get_node("CanvasLayer/JetpackFuel").value = (jetpack_fuel/max_jetpack_fuel)
		
		if (Input.is_action_pressed("ui_left") or Input.is_action_pressed("ui_right")) and thruster_fuel > 0:
			thruster_fuel -= delta
			if max_thruster_fuel != 0:
				get_parent().get_parent().get_node("CanvasLayer/ThrusterFuel").value = (thruster_fuel/max_thruster_fuel)
			if Input.is_action_pressed("ui_left"):
				velocity.x -= thruster_power
			else:
				velocity.x += thruster_power

	if can_move:
		if Input.is_action_pressed("ui_accept") and is_on_floor():
			if jump_charge > max_jump_charge:
				jump_charge -= jump_growth * delta
				$DirectionArrow.visible = true
				$DirectionArrow.scale = original_scale
				stretch_ratio = abs(jump_charge / max_jump_charge)
				$DirectionArrow.apply_scale(Vector2(1, stretch_ratio))
				$DirectionArrow.modulate = gradient.sample(jump_charge / max_jump_charge)
			elif max_jump_charge == 0:
				jump_charge -= jump_growth * delta
				$DirectionArrow.visible = true
				$DirectionArrow.scale = original_scale
				stretch_ratio = abs(jump_charge / -10000)
				$DirectionArrow.apply_scale(Vector2(1, stretch_ratio))
				$DirectionArrow.modulate = gradient.sample(jump_charge / max_jump_charge)
				

		if Input.is_action_just_released("ui_accept") and is_on_floor():
			jump() 
	 
	if (not is_on_floor() && Input.is_action_just_pressed("ui_accept")): 
		x_jump_used -= 1 
		if (x_jump_used >= 0): 
			last_jump()

	if (is_on_floor()):
		var move_direction := Input.get_axis("ui_left", "ui_right")
		if can_move and move_direction and !($DirectionArrow.visible):
			velocity.x = move_direction * SPEED
		else:
			velocity.x = move_toward(velocity.x, 0, SPEED) 

	var zoom = remap((1.0 - remap(velocity.length(), 0, 3000, 0, 1)), 0, 1, BASE_MIN_ZOOM, BASE_MAX_ZOOM);
	zoom = clamp(lerp($Camera2D.zoom.x, zoom, delta), BASE_MIN_ZOOM, BASE_MAX_ZOOM);
	$Camera2D.zoom = Vector2(zoom, zoom);
	move_and_slide()

func jump():
	jump_sound.play(0.0)
	is_jumping = true
	var angle = $DirectionArrow.rotation
	var direction = Vector2(cos(angle), sin(angle)).normalized()
	velocity = Vector2(0.0 , jump_charge).rotated(angle)

	jump_charge = 0
	$DirectionArrow.scale = original_scale
	stretch_ratio = 1
	$DirectionArrow.visible = false

	await get_tree().create_timer(0.5).timeout
	is_jumping = false
 
func last_jump():  
	is_jumping = true
	var jump_charge = 1000
	var direction = deg_to_rad(45)
	var leap_vector = Vector2.UP.rotated(direction) * jump_charge
	velocity += leap_vector

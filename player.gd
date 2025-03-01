extends CharacterBody2D
class_name Player;

const BASE_MAX_ZOOM = 0.7;
const BASE_MIN_ZOOM = 0.2;

const SPEED = 800.0
var jump_charge = 0
const MAX_JUMP_CHARGE = -5000
const JUMP_GROWTH = 1250
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


func _ready() -> void:
	original_scale = $DirectionArrow.scale
	gradient.offsets = gradient_data.keys()
	gradient.colors = gradient_data.values()

func _reset() -> void:
	jump_charge = 0
	velocity = Vector2(0,0)
	is_jumping = false
	$Camera2D.zoom = Vector2(BASE_MAX_ZOOM, BASE_MAX_ZOOM);
	can_move = true;

func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity.y += gravity * delta

	if can_move:
		if Input.is_action_pressed("ui_accept") and is_on_floor() and jump_charge > MAX_JUMP_CHARGE:
			jump_charge -= JUMP_GROWTH * delta
			$DirectionArrow.visible = true
			$DirectionArrow.scale = original_scale
			stretch_ratio = abs(jump_charge / MAX_JUMP_CHARGE)
			$DirectionArrow.apply_scale(Vector2(1, stretch_ratio))
			$DirectionArrow.modulate = gradient.sample(jump_charge / MAX_JUMP_CHARGE)

		if Input.is_action_just_released("ui_accept") and is_on_floor():
			jump()

	if (is_on_floor()):
		var move_direction := Input.get_axis("ui_left", "ui_right")
		if can_move and move_direction:
			velocity.x = move_direction * SPEED
		else:
			velocity.x = move_toward(velocity.x, 0, SPEED)

	var zoom = remap((1.0 - remap(velocity.length(), 0, 3000, 0, 1)), 0, 1, BASE_MIN_ZOOM, BASE_MAX_ZOOM);
	zoom = clamp(lerp($Camera2D.zoom.x, zoom, delta), BASE_MIN_ZOOM, BASE_MAX_ZOOM);
	$Camera2D.zoom = Vector2(zoom, zoom);
	move_and_slide()

func jump():
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

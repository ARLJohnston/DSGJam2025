extends CharacterBody2D

const SPEED = 800.0
var jump_charge = 0
const MAX_JUMP_CHARGE = -10000
const JUMP_GROWTH = 2500
var stretch_ratio = 1
var original_scale = Vector2()

func _ready() -> void:
	original_scale = $DirectionArrow.scale

func _physics_process(delta: float) -> void:

	if not is_on_floor():
		velocity += get_gravity() * delta
		velocity.x = move_toward(velocity.x, 0, 10 * delta)

	if Input.is_action_pressed("ui_accept") and is_on_floor() and jump_charge > MAX_JUMP_CHARGE:
		jump_charge -= JUMP_GROWTH * delta
		$DirectionArrow.visible = true
		$DirectionArrow.scale = original_scale
		stretch_ratio = abs(jump_charge / MAX_JUMP_CHARGE)
		$DirectionArrow.apply_scale(Vector2(stretch_ratio, 1))

	if Input.is_action_just_released("ui_accept"):
		var angle = $DirectionArrow.rotation
		var direction = Vector2(cos(angle), sin(angle)).normalized()

		velocity = direction * abs(jump_charge)

		jump_charge = 0
		$DirectionArrow.scale = original_scale
		stretch_ratio = 1
		$DirectionArrow.visible = false

	var move_direction := Input.get_axis("ui_left", "ui_right")
	if move_direction:
		velocity.x = move_direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()

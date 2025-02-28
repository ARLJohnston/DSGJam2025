extends CharacterBody2D


const SPEED = 300.0

var jump_charge = 0  
const MAX_JUMP_CHARGE = -1000 
const JUMP_GROWTH = 250
var stretch_ratio = 1  
var original_scale = 0

func _ready() -> void: 
	original_scale = $DirectionArrow.scale

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor(): 
		velocity += get_gravity() * delta 
		if (velocity.x > 0):  
			velocity.x -= 10 * delta
		

	# Handle jump.
	if Input.is_action_pressed("ui_accept") && is_on_floor() && jump_charge > MAX_JUMP_CHARGE:
		jump_charge -= JUMP_GROWTH * delta 
		$DirectionArrow.visible = true  
		$DirectionArrow.scale = original_scale
		stretch_ratio = abs(jump_charge / MAX_JUMP_CHARGE)
		$DirectionArrow.apply_scale(Vector2(stretch_ratio,1))      
				   
	
	if Input.is_action_just_released("ui_accept"): 
		var angle = $DirectionArrow.rotation 
		var direction = Vector2(cos(angle),sin(angle))
		self.velocity.y = direction.y * jump_charge * -1
		self.velocity.x = direction.x * jump_charge * -1

		jump_charge = 0   
		#$DirectionArrow.apply_scale(Vector2(-stretch_ratio,1))   
		$DirectionArrow.scale = original_scale
		stretch_ratio = 1 
		$DirectionArrow.visible = false 
	 
	

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction := Input.get_axis("ui_left", "ui_right")
	if direction:
		velocity.x = direction * SPEED 
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()

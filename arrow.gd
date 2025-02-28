extends Sprite2D

var rotation_speed = - 0.25
const MAX_ANGLE = 0
const MIN_ANGLE =  - (PI / 2)
var current_angle = 0 
var going_up = true
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:  
   
	current_angle = current_angle + delta * rotation_speed 
	if (current_angle > MAX_ANGLE || current_angle < MIN_ANGLE):  
		rotation_speed *= -1 
	self.rotation += delta * rotation_speed  

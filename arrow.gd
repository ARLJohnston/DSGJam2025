extends Sprite2D

var rotation_speed = - 3
const MAX_ANGLE = (PI / 2) 
const MIN_ANGLE =  0


# Called when the node enters the scene tree for the first time.
func _ready() -> void: 
	self.visible = false  

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:    
	if (self.rotation > MAX_ANGLE || self.rotation < MIN_ANGLE):   
		rotation_speed *= -1    
	 
	if (self.visible):  
		self.rotation += delta * rotation_speed
		self.rotation = snappedf(self.rotation, 0.01)

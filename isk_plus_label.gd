extends Label
class_name IskPlusLabel

@onready var base_pos = self.position;

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	modulate = Color.TRANSPARENT;
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
 
func animate_multiplier(value : int, multiplier: int) -> void:  
	position = base_pos;
	text = "+§%d x %d ISK" % [value, multiplier];
	modulate = Color.WHITE;
	
	var tween = get_tree().create_tween().bind_node(self)
	tween.parallel().tween_property(self, "modulate", Color.TRANSPARENT, 2.0);
	tween.parallel().tween_property(self, "position", base_pos + Vector2(0, -80), 2.0);
			
			
	
	
func animate(value: int) -> void:
	position = base_pos;
	text = "+§%d ISK" % value;
	modulate = Color.WHITE;
	
	var tween = get_tree().create_tween().bind_node(self)
	tween.parallel().tween_property(self, "modulate", Color.TRANSPARENT, 2.0);
	tween.parallel().tween_property(self, "position", base_pos + Vector2(0, -80), 2.0);
	
func _reset() -> void:
	position = base_pos;

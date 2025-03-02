extends CanvasLayer
 
func _ready() -> void:
	self.visible = false 
	
func _on_open_shop_ui_pressed() -> void:
	self.visible = !self.visible


func _on_lets_play_button_pressed() -> void:
	self.visible = false

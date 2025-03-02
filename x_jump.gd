extends ReferenceRect
 

var upgrade_level : int   
const MAX_LEVEL = 3 
var cost = [2000,4000,6000]

enum MetalColor { BRONZE = 1, SILVER = 2, GOLD = 3 }


var metal_colors = {
	MetalColor.BRONZE: Color("#CD7F32"), 
	MetalColor.SILVER: Color("#C0C0C0"),   
	MetalColor.GOLD: Color("#FFD700")     
} 

func _ready() -> void:
	$BuyXJumpUpgrade.text = "Buy upgrade " + str(cost[upgrade_level]) 


func get_metal_color(value: int) -> Color:
	return metal_colors.get(value, Color(1, 1, 1)) 

func _on_buy_thrust_upgrade_pressed() -> void: 
	if (upgrade_level != MAX_LEVEL):
			$BuyXJumpUpgrade.text = "Buy upgrade " + str(cost[upgrade_level]) 
			
	if (upgrade_level < MAX_LEVEL):
		upgrade_level += 1 
		self.border_color = get_metal_color(upgrade_level)    
		match upgrade_level:
			1:
				$XJumpUpgradeLevelStar1.modulate = get_metal_color(MetalColor.BRONZE) 
			2:
				$XJumpUpgradeLevelStar2.modulate = get_metal_color(MetalColor.SILVER) 
			3:
				$XJumpUpgradeLevelStar3.modulate = get_metal_color(MetalColor.GOLD) 
			_:
				print("Invalid level")

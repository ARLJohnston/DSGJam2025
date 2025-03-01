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
	$BuyThrustUpgrade.text = "Buy upgrade " + str(cost[upgrade_level]) 
	$ThrustersUpgradeLevelStar1.material.set_shader_parameter("shine_enabled", false)   
	$ThrustersUpgradeLevelStar2.material.set_shader_parameter("shine_enabled", false) 
	$ThrustersUpgradeLevelStar3.material.set_shader_parameter("shine_enabled", false)

func get_metal_color(value: int) -> Color:
	return metal_colors.get(value, Color(1, 1, 1)) 

func _on_buy_thrust_upgrade_pressed() -> void: 
	if (upgrade_level != MAX_LEVEL):
			$BuyThrustUpgrade.text = "Buy upgrade " + str(cost[upgrade_level]) 
			
	if (upgrade_level < MAX_LEVEL):
		upgrade_level += 1 
		self.border_color = get_metal_color(upgrade_level)    
		match upgrade_level:
			1:
				$ThrustersUpgradeLevelStar1.modulate = get_metal_color(MetalColor.BRONZE) 
				$ThrustersUpgradeLevelStar1.material.set_shader_parameter("shine_enabled", true) 
			2:
				$ThrustersUpgradeLevelStar2.modulate = get_metal_color(MetalColor.SILVER) 
				$ThrustersUpgradeLevelStar2.material.set_shader_parameter("shine_enabled", true)
			3:
				$ThrustersUpgradeLevelStar3.modulate = get_metal_color(MetalColor.GOLD) 
				$ThrustersUpgradeLevelStar3.material.set_shader_parameter("shine_enabled", true)
			_:
				print("Invalid level")

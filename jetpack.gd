extends ReferenceRect
 

var upgrade_level : int   
const MAX_LEVEL = 3 
var cost = [2000,4000,6000]

enum MetalColor { BRONZE = 1, SILVER = 2, GOLD = 3 }

# Dictionary to store corresponding colors
var metal_colors = {
	MetalColor.BRONZE: Color("#CD7F32"),  # Bronze
	MetalColor.SILVER: Color("#C0C0C0"),  # Silver
	MetalColor.GOLD: Color("#FFD700")     # Gold
} 

func _ready() -> void:
	$BuyJetpackUpgrade.text = "Buy upgrade " + str(cost[upgrade_level]) 
	$JetpackUpgradeLevelStar1.material.set_shader_parameter("shine_enabled", false)   
	$JetpackUpgradeLevelStar2.material.set_shader_parameter("shine_enabled", false) 
	$JetpackUpgradeLevelStar3.material.set_shader_parameter("shine_enabled", false)

func get_metal_color(value: int) -> Color:
	return metal_colors.get(value, Color(1, 1, 1)) 




func _on_buy_jetpack_upgrade_pressed() -> void:
	if (upgrade_level != MAX_LEVEL):
			$BuyJetpackUpgrade.text = "Buy upgrade " + str(cost[upgrade_level]) 
			
	if (upgrade_level < MAX_LEVEL):
		upgrade_level += 1 
		self.border_color = get_metal_color(upgrade_level)    
		match upgrade_level:
			1:
				$JetpackUpgradeLevelStar1.modulate = get_metal_color(MetalColor.BRONZE) 
				$JetpackUpgradeLevelStar1.material.set_shader_parameter("shine_enabled", true) 
			2:
				$JetpackUpgradeLevelStar2.modulate = get_metal_color(MetalColor.SILVER) 
				$JetpackUpgradeLevelStar2.material.set_shader_parameter("shine_enabled", true)
			3:
				$JetpackUpgradeLevelStar3.modulate = get_metal_color(MetalColor.GOLD) 
				$JetpackUpgradeLevelStar3.material.set_shader_parameter("shine_enabled", true)
			_:
				print("Invalid level")

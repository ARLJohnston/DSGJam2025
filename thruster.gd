extends ReferenceRect
 
@onready var upgrade = $"../upgrade"
var upgrade_level : int = 0
const MAX_LEVEL = 3 
var cost = [100,900,3000]  
var current_isk : int

enum MetalColor { BRONZE = 1, SILVER = 2, GOLD = 3 }
signal isk_updated

var metal_colors = {
	MetalColor.BRONZE: Color("#CD7F32"), 
	MetalColor.SILVER: Color("#C0C0C0"),   
	MetalColor.GOLD: Color("#FFD700")     
} 
	
	
func _ready() -> void:
	$BuyThrustUpgrade.text = "Buy upgrade " + str(cost[upgrade_level])  
	current_isk =  get_parent().get_parent().get_parent().isk  
 
func _process(delta: float) -> void:  
	current_isk = get_parent().get_parent().get_parent().isk   
	if upgrade_level >= 0 and upgrade_level < cost.size():   
		var upgrade_cost = cost[upgrade_level]
		if (current_isk < upgrade_cost):
			$BuyThrustUpgrade.disabled = true  
		else: 
			$BuyThrustUpgrade.disabled = false  

func get_metal_color(value: int) -> Color:
	return metal_colors.get(value, Color(1, 1, 1)) 


func _on_buy_thrust_upgrade_pressed() -> void: 			
	var current_isk = get_parent().get_parent().get_parent().isk  
	var upgrade_cost = cost[upgrade_level] 

	
	if (current_isk >= upgrade_cost): 
				
		if (upgrade_level < MAX_LEVEL):
			$"../../../CanvasLayer/ThrusterFuel".value = 1
			upgrade_level += 1
			$"../../../Player/CharacterBody2D".max_thruster_fuel = upgrade_level
			$"../../../Player/CharacterBody2D".thruster_fuel = upgrade_level
			upgrade.play(0.0)
			current_isk -= upgrade_cost 
			emit_signal("isk_updated", current_isk) 
			self.border_color = get_metal_color(upgrade_level)    
			match upgrade_level:
				1:
					$ThrustersUpgradeLevelStar1.modulate = get_metal_color(MetalColor.BRONZE)
					$"../../../Player/CharacterBody2D".thruster_power = 10
				2:
					$ThrustersUpgradeLevelStar1.modulate = get_metal_color(MetalColor.SILVER) 
					$"../../../Player/CharacterBody2D".thruster_power = 15
				3:
					$ThrustersUpgradeLevelStar1.modulate = get_metal_color(MetalColor.GOLD) 
					$"../../../Player/CharacterBody2D".thruster_power = 20
				_:
					print("Invalid level")  
					
			if (upgrade_level != MAX_LEVEL):
				$BuyThrustUpgrade.text = "Buy upgrade " + str(cost[upgrade_level])

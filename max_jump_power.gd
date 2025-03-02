extends ReferenceRect
 

var upgrade_level : int = 0
const MAX_LEVEL = 3 
var cost = [30,90,270]  
var current_isk : int

enum MetalColor { BRONZE = 1, SILVER = 2, GOLD = 3 }
signal isk_updated

var metal_colors = {
	MetalColor.BRONZE: Color("#CD7F32"), 
	MetalColor.SILVER: Color("#C0C0C0"),   
	MetalColor.GOLD: Color("#FFD700")     
} 
	
	
func _ready() -> void:
	$BuyMaxJumpPowerUpgrade.text = "Buy upgrade " + str(cost[upgrade_level])  
	current_isk =  get_parent().get_parent().get_parent().isk  
 
func _process(delta: float) -> void:  
	current_isk = get_parent().get_parent().get_parent().isk   
	if upgrade_level >= 0 and upgrade_level < cost.size():   
		var upgrade_cost = cost[upgrade_level]
		if (current_isk < upgrade_cost):
			$BuyMaxJumpPowerUpgrade.disabled = true  
		else: 
			$BuyMaxJumpPowerUpgrade.disabled = false  

func get_metal_color(value: int) -> Color:
	return metal_colors.get(value, Color(1, 1, 1)) 


func _on_buy_max_jump_power_upgrade_pressed() -> void: 
	var current_isk = get_parent().get_parent().get_parent().isk  
	var upgrade_cost = cost[upgrade_level] 
	
	print(upgrade_level)
	print(upgrade_cost)
	
	if (true): 
				
		if (upgrade_level < MAX_LEVEL):
			upgrade_level += 1  
			current_isk -= upgrade_cost 
			emit_signal("isk_updated", current_isk) 
			self.border_color = get_metal_color(upgrade_level)    
			match upgrade_level:
				1:
					$MaxJumpPowerUpgradeLevelStar1.modulate = get_metal_color(MetalColor.BRONZE) 
				2:
					$MaxJumpPowerUpgradeLevelStar2.modulate = get_metal_color(MetalColor.SILVER) 
				3:
					$MaxJumpPowerUpgradeLevelStar3.modulate = get_metal_color(MetalColor.GOLD) 
				_:
					print("Invalid level")  
					
			if (upgrade_level != MAX_LEVEL):
				$BuyMaxJumpPowerUpgrade.text = "Buy upgrade " + str(cost[upgrade_level])

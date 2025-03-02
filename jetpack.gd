extends ReferenceRect
 
@onready var upgrade = $"../upgrade"
var upgrade_level : int = 0
const MAX_LEVEL = 3 
var cost = [150,1300,5000]  
var current_isk : int

enum MetalColor { BRONZE = 1, SILVER = 2, GOLD = 3 }
signal isk_updated

var metal_colors = {
	MetalColor.BRONZE: Color("#CD7F32"), 
	MetalColor.SILVER: Color("#C0C0C0"),   
	MetalColor.GOLD: Color("#FFD700")     
} 
	
	
func _ready() -> void:
	$BuyJetpackUpgrade.text = "Buy upgrade " + str(cost[upgrade_level])  
	current_isk =  get_parent().get_parent().get_parent().isk  
 
func _process(delta: float) -> void:  
	current_isk = get_parent().get_parent().get_parent().isk   
	if upgrade_level >= 0 and upgrade_level < cost.size():   
		var upgrade_cost = cost[upgrade_level]
		if (current_isk < upgrade_cost):
			$BuyJetpackUpgrade.disabled = true  
		else: 
			$BuyJetpackUpgrade.disabled = false  

func get_metal_color(value: int) -> Color:
	return metal_colors.get(value, Color(1, 1, 1)) 

func _on_buy_jetpack_upgrade_pressed() -> void:
	var current_isk = get_parent().get_parent().get_parent().isk  
	var upgrade_cost = cost[upgrade_level] 
	

	if (current_isk >= upgrade_cost): 
		$"../../../CanvasLayer/JetpackFuel".value = 1
		if (upgrade_level < MAX_LEVEL):
			upgrade_level += 1
			$"../../../Player/CharacterBody2D".max_jetpack_fuel = upgrade_level
			$"../../../Player/CharacterBody2D".jetpack_fuel = upgrade_level
			upgrade.play(0.0)
			current_isk -= upgrade_cost 
			emit_signal("isk_updated", current_isk) 
			self.border_color = get_metal_color(upgrade_level)    
			match upgrade_level:
				1:
					$JetpackUpgradeLevelStar1.modulate = get_metal_color(MetalColor.BRONZE) 
					$"../../../Player/CharacterBody2D".jetpack_power = 20
				2:
					$JetpackUpgradeLevelStar2.modulate = get_metal_color(MetalColor.SILVER) 
					$"../../../Player/CharacterBody2D".jetpack_power = 25
				3:
					$JetpackUpgradeLevelStar3.modulate = get_metal_color(MetalColor.GOLD) 
					$"../../../Player/CharacterBody2D".jetpack_power = 30
				_:
					print("Invalid level")  
					
			if (upgrade_level != MAX_LEVEL):
				$BuyJetpackUpgrade.text = "Buy upgrade " + str(cost[upgrade_level])

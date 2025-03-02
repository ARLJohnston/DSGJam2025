extends ReferenceRect

@onready var upgrade = $"../upgrade"

const COST_MULTIPLIER = 1.5

var current_multiplier : float = 1.0
var current_isk : int
var cost : int = 30

signal isk_updated
	
	
func _ready() -> void:
	$BuyMaxJumpPowerUpgrade.text = "Buy upgrade " + str(cost)  
	current_isk =  get_parent().get_parent().get_parent().isk  
 
func _process(delta: float) -> void:  
	current_isk = get_parent().get_parent().get_parent().isk   
	if (current_isk < cost):
		$BuyMaxJumpPowerUpgrade.disabled = true  
	else: 
		$BuyMaxJumpPowerUpgrade.disabled = false  


func _on_buy_max_jump_power_upgrade_pressed() -> void: 
	var current_isk = get_parent().get_parent().get_parent().isk  
	

	if (current_isk >= cost): 
		upgrade.play()
		current_multiplier *= 1.1
		print(current_multiplier)
		$JumpMultiplier.text = "Current mult: %.2f" % current_multiplier
		current_isk -= cost 
		emit_signal("isk_updated", current_isk)
		self.border_color = Color(randf(), randf(), randf(), 1)
		$"../../../Player/CharacterBody2D".max_jump_charge *= 1.1
		$"../../../Player/CharacterBody2D".jump_growth *= 1.05
		cost *= COST_MULTIPLIER
		$BuyMaxJumpPowerUpgrade.text = "Buy upgrade " + str(cost)

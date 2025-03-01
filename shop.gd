extends Node2D

enum SHOPITEMS {
	JETPACK,
	THRUSTERS,
	OTHERSTUFF
}

const DESCRIPTIONS = {
	SHOPITEMS.JETPACK: "Jetpack",
	SHOPITEMS.THRUSTERS: "Thrusters",
	SHOPITEMS.OTHERSTUFF: "Other Stuff"
}

var shop_items = [
	SHOPITEMS.JETPACK,
	SHOPITEMS.THRUSTERS
]

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	rearrange_store()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func rearrange_store():
	#$Background/ItemText.text = "hello"
	var amount = 0
	#for item in shop_items:
		#$MenuLeft.remove_child(item['node']) 
	#var scrolling = menu_right_scroll_top
	for item in shop_items:
		var item_node = $Background/ItemText.duplicate()
		var in_list_item = {
			'kind': item,
			'node': item_node
		}
		#menu_right_items.push_back(in_list_item)
		#if amount < max_amount_vertically:
		$".".add_child(item_node)
		print("shuold be added")
		item_node.position.y += 35 * amount
		item_node.set_visible(true)
		item_node.text = DESCRIPTIONS[item] + " $99"
		#amount += 1
		#if amount == max_amount_vertically:
			#var more_indicator = $MenuRight/Item.duplicate()
			#more_indicator.text = "..."
			#more_indicator.set_visible(true)
			#more_indicator.position.y += 35 * amount
			#$MenuRight.add_child(more_indicator)
	#amount = 0
	#for adquirance in adquirances:
		#var item_node = $MenuLeft/Item.duplicate()
		#item_node.visible = true
		#item_node.position.y += 35 * amount
		#item_node.text = get_item_name(adquirance.type) + " x" + str(adquirance.amount)
		#var in_list_item = {
			#'kind': adquirance.type,
			#'amount': adquirance.amount,
			#'node': item_node
		#}
		#menu_left_items.push_back(in_list_item)
		#$MenuLeft.add_child(item_node)
		#amount += 1

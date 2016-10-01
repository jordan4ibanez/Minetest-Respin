local test = true

if test == true then

return
end

minetest.register_on_punchnode(function(pos, node, puncher, pointed_thing)
	local wield = puncher:get_wielded_item()
	local inv = puncher:get_inventory("main")
	local stack = inv:get_stack("main", 1)
	stack:set_name("poop")
	return(stack)
end)
minetest.override_item("default:dirt_with_grass", {
    on_rightclick = function(pos, node, clicker, itemstack, pointed_thing)
		print(dump(itemstack:to_table()))
		local meta = "fast"
		local meta = meta.."burrow"
		local meta = meta.."landscape"
		itemstack:set_metadata(meta)
		return(itemstack)
    end,
})


--have a gui that tells you what perks that an item has in it's meta data

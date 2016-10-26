--clouds
minetest.register_ore({
    ore_type       = "sheet",
    ore            = "heaven:cloud",
    wherein        = "air",
    clust_scarcity = 1,
    clust_num_ores = 8,
    clust_size     = 8,
    height_min     = 25000, --25000
    height_max     = 31000, --31000
})

minetest.register_node("heaven:cloud", {
	description = "Heavenly Cloud",
	tiles = {"heaven_cloud.png"},
	paramtype = "light",
	sunlight_propagates = true,
	is_ground_content = false,
	groups = {snappy = 3, choppy = 2, oddly_breakable_by_hand = 3, wool = 1},
	sounds = default.node_sound_defaults(),
})


minetest.register_ore({
    ore_type       = "scatter",
    ore            = "default:mese",
    wherein        = "heaven:cloud",
    clust_scarcity = 8*8*8,
    clust_num_ores = 16,
    clust_size     = 3,
    height_min     = 25000,
    height_max     = 31000,
})


minetest.register_ore({
    ore_type       = "scatter",
    ore            = "default:mese",
    wherein        = "heaven:cloud",
    clust_scarcity = 8*8*8,
    clust_num_ores = 16,
    clust_size     = 3,
    height_min     = 25000,
    height_max     = 31000,
})
minetest.override_item("default:mese", {
	on_punch = function(pos, node, puncher, pointed_thing)
		local item = puncher:get_wielded_item()
		if item:to_string() ~= "" then
			if item:to_table().name == "default:torch" then
				heaven_portal_check(pos)
			end
		end
	end,
})

function heaven_portal_check(pos)
	local y_top = 0
	for y = 1,5 do
		if minetest.get_node({x=pos.x,y=pos.y+y,z=pos.z}).name == "default:mese" then
			y_top = y
			break
		end
	end
	local y_bottom = 0
	if y_top == 0 then
		for y = -1,-5,-1 do
			if minetest.get_node({x=pos.x,y=pos.y+y,z=pos.z}).name == "default:mese" then
				y_bottom = y
				break
			end
		end	
	end
	if y_bottom == 0 then
		for y = y_top-1,1,-1 do
			minetest.set_node({x=pos.x,y=pos.y+y,z=pos.z}, {name="default:glass"})
		end
	elseif y_top == 0 then
		for y = -1,y_bottom+1,-1 do
			minetest.set_node({x=pos.x,y=pos.y+y,z=pos.z}, {name="default:glass"})
		end	
	end
end

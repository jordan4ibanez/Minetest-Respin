--you can use a sponge as a water storage device, or simply to displace water
--wet sponge + bucket = water bucket, water bucket + dry sponge = wet sponge

minetest.register_node("sponge:sponge", {
	description = "Sponge",
	tiles = {"sponge.png"},
	is_ground_content = true,
	groups = {snappy = 3},
	drop = 'sponge:sponge',
	on_destruct = function(pos)
		sponge_function_destroy(pos)
	end,
	on_dig = function(pos, node, player)
		sponge_function_destroy(pos)
		minetest.node_dig(pos, node, player)
	end,
})

--wet sponge can be put into empty bucket to get water bucket
--can be punched to place water around it
minetest.register_node("sponge:sponge_wet", {
	description = "Sponge (Wet)",
	tiles = {"sponge_wet.png"},
	is_ground_content = true,
	groups = {snappy = 3},
	drop = 'sponge:sponge_wet',
	on_destruct = function(pos)
		sponge_function_destroy(pos)
	end,
	on_dig = function(pos, node, player)
		sponge_function_destroy(pos)
		minetest.node_dig(pos, node, player)
	end,
})


minetest.register_abm{
	nodenames = {"sponge:sponge","sponge:sponge_wet"},
	neighbors = {"group:water"},
	interval = 1,
	chance = 1,
	action = function(pos)
		sponge_function(pos)
	end,
}

minetest.register_node("sponge:fake_air", {
	drawtype = "airlike",
	walkable = false,
	buildable_to = true,
	diggable = false,
	pointable = false,
	paramtype = "light",
	sunlight_propagates = true,
})

minetest.register_craft({
	type = "shapeless",
	output = "bucket:bucket_water",
	recipe = {"sponge:sponge_wet", "bucket:bucket_empty"},
	replacements = {
		{"sponge:sponge_wet", "sponge:sponge"}
	}
})
minetest.register_craft({
	type = "shapeless",
	output = "sponge:sponge_wet",
	recipe = {"sponge:sponge", "bucket:bucket_water"},
	replacements = {
		{"bucket:bucket_water", "bucket:bucket_empty"}
	}
})

--suck up water
sponge_function = function(pos)
	--minetest.sound_play("sponge_absorb", {
	--	pos = pos,
	--	max_hear_distance = 10,
	--	gain = 10.0,
	--})
	local radius = 2
	local min = {x=pos.x-radius,y=pos.y-radius,z=pos.z-radius}
	local max = {x=pos.x+radius,y=pos.y+radius,z=pos.z+radius}
	local vm = minetest.get_voxel_manip()	
	local emin, emax = vm:read_from_map(min,max)
	local area = VoxelArea:new{MinEdge=emin, MaxEdge=emax}
	local data = vm:get_data()
	
	local air = minetest.get_content_id("sponge:fake_air")
	local sponge_wet = minetest.get_content_id("sponge:sponge_wet")
	--minetest.get_name_from_content_id(content_id)
	
	for x = -radius,radius  do
		for z = -radius,radius  do
			for y = -radius,radius  do
				local p_pos = area:index(pos.x+x,pos.y+y,pos.z+z)
				local name = minetest.get_name_from_content_id(data[p_pos])
				if minetest.get_item_group(name, "water") ~= 0 or name == "air" then
					data[p_pos] = air
				end
				if name == "sponge:sponge" then
					data[p_pos] = sponge_wet
				end
			end
		end
	end

	vm:set_data(data)
	vm:calc_lighting()
	vm:write_to_map()
	vm:update_map()
end

--replace with normal air nodes
sponge_function_destroy = function(pos)
	local radius = 2
	local min = {x=pos.x-radius,y=pos.y-radius,z=pos.z-radius}
	local max = {x=pos.x+radius,y=pos.y+radius,z=pos.z+radius}
	local vm = minetest.get_voxel_manip()	
	local emin, emax = vm:read_from_map(min,max)
	local area = VoxelArea:new{MinEdge=emin, MaxEdge=emax}
	local data = vm:get_data()
	
	local air = minetest.get_content_id("air")
	local sponge_wet = minetest.get_content_id("sponge:sponge_wet")
	--minetest.get_name_from_content_id(content_id)
	
	for x = -radius,radius  do
		for z = -radius,radius  do
			for y = -radius,radius  do
				local p_pos = area:index(pos.x+x,pos.y+y,pos.z+z)
				local name = minetest.get_name_from_content_id(data[p_pos])
				if name == "sponge:fake_air" then
					data[p_pos] = air
				end
			end
		end
	end
	vm:update_liquids()
	vm:set_data(data)
	vm:calc_lighting()
	vm:write_to_map()
	vm:update_map()
end

minetest.register_decoration({
	deco_type = "simple",
	place_on = "default:dirt_with_grass",
	spawn_by = "default:tree",
	sidelen = 16,
	fill_ratio = 0.0008,
	decoration = "sponge:sponge",
	height = 1,
})

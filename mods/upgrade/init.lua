minetest.register_craftitem("upgrade:rsamble", {
	description = "",
	inventory_image = ".png",
})

--make upgrades wear like tools

--makes a radius of shovel/pick digs
minetest.register_craftitem("upgrade:borer_1", {
	description = "Borer Upgrade 1",
	inventory_image = "borer_1.png",
})
minetest.register_craftitem("upgrade:borer_2", {
	description = "Borer Upgrade 2",
	inventory_image = "borer_2.png",
})
minetest.register_craftitem("upgrade:borer_3", {
	description = "Borer Upgrade 3",
	inventory_image = "borer_3.png",
})

--auto mine veins - make it so borers have this lumped on to the loop
minetest.register_craftitem("upgrade:vein_miner", {
	description = "",
	inventory_image = ".png",
})

--auto cook items - shovel/pick
minetest.register_craftitem("upgrade:auto_smelt", {
	description = "Autosmelt Upgrade",
	inventory_image = ".png",
})

--regenerate health when mining
minetest.register_craftitem("upgrade:hp_boost", {
	description = "",
	inventory_image = ".png",
})

--place a ladder when digging straight down
minetest.register_craftitem("upgrade:", {
	description = "",
	inventory_image = ".png",
})

-- fill all buckets in inventory when collecting a single node of water
minetest.register_craftitem("upgrade:bucket_vacuum", {
	description = "",
	inventory_image = ".png",
})

-- auto replace items in hand with similar type when item breaks
minetest.register_craftitem("upgrade:auto_renew", {
	description = "",
	inventory_image = ".png",
})

-- auto replaces the best tool into hand if mining with inneficient tool
minetest.register_craftitem("upgrade:auto_speed", {
	description = "",
	inventory_image = ".png",
})

-- auto gives tools health back based on their durability on every node dug
minetest.register_craftitem("upgrade:durability", {
	description = "",
	inventory_image = ".png",
})

-- auto places a torch from inventory if light level is below a certain number
minetest.register_craftitem("upgrade:auto_torch", {
	description = "",
	inventory_image = ".png",
})

borer_function = function(pos,digger,radius,item)

	local min = {x=pos.x-radius,y=pos.y-radius,z=pos.z-radius}
	local max = {x=pos.x+radius,y=pos.y+radius,z=pos.z+radius}
	local vm = minetest.get_voxel_manip()	
	local emin, emax = vm:read_from_map(min,max)
	local area = VoxelArea:new{MinEdge=emin, MaxEdge=emax}
	local data = vm:get_data()
	
	local typer = ""
	if string.match(item, "pick_") then
		typer = "cracky"
	elseif  string.match(item, "shovel_") then
		typer = "crumbly"
	end
	
	local air = minetest.get_content_id("air")
	for x = -radius,radius  do
		for z = -radius,radius  do
			for y = -radius,radius  do
				local p_pos = area:index(pos.x+x,pos.y+y,pos.z+z)
				local pos2 = {x=pos.x+x,y=pos.y+y,z=pos.z+z}
				local name = minetest.get_name_from_content_id(data[p_pos])
				
				
				
				if placed == nil or placed == "" then
					if minetest.get_item_group(name, typer) > 0 then 
					--if string.match(name, "stone_with_") then
						data[p_pos] = air
						local item = minetest.get_node_drops(name)[1]
						minetest.add_item({x=pos.x+x,y=pos.y+y,z=pos.z+z}, item)	
					end
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

-- hard coded for simplicity sake

minetest.register_on_dignode(function(pos, oldnode, digger)
	local item = digger:get_wielded_item():to_string()
	--find if item is pick/axe/shovel
	local inv = digger:get_inventory()
	
	if inv:contains_item("main", "upgrade:borer_1") then
		borer_function(pos,digger,1,item)
	elseif inv:contains_item("main", "upgrade:borer_2") then
		borer_function(pos,digger,2,item)
	elseif inv:contains_item("main", "upgrade:borer_3") then
		borer_function(pos,digger,3,item)
	end
	
end)

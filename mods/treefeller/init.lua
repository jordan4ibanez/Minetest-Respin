minetest.register_on_dignode(function(pos, oldnode, digger)
	local item = digger:get_wielded_item():to_string()
	if string.match(item, "axe_") then
		if minetest.get_item_group(oldnode.name, "tree") ~= 0 then
			treefeller_loop(pos,digger)
		end
	end
end)


--have this recursively check for tree/leaves around it (1 node radius)
treefeller_loop = function(pos,digger)

	local min = {x=pos.x-1,y=pos.y-1,z=pos.z-1}
	local max = {x=pos.x+1,y=pos.y+1,z=pos.z+1}
	local vm = minetest.get_voxel_manip()	
	local emin, emax = vm:read_from_map(min,max)
	local area = VoxelArea:new{MinEdge=emin, MaxEdge=emax}
	local data = vm:get_data()
	
	local air = minetest.get_content_id("air")
	
	--minetest.get_name_from_content_id(content_id)
	
	for x = -1,1  do
		for z = -1,1  do
			for y = -1,1  do
				local p_pos = area:index(pos.x+x,pos.y+y,pos.z+z)
				local pos2 = {x=pos.x+x,y=pos.y+y,z=pos.z+z}
				local name = minetest.get_name_from_content_id(data[p_pos])
				
				
				
				if placed == nil or placed == "" then
					if minetest.get_item_group(name, "tree") ~= 0 then
						data[p_pos] = air
						
						minetest.after(0,function(pos2)
							treefeller_loop(pos2)
						end, pos2)
						minetest.add_item({x=pos.x+x,y=pos.y+y,z=pos.z+z}, name)
						--treecapitator.wear_tool(inv)
						--if inv:room_for_item("main", name) == true then
						--	inv:add_item("main", name)
						--else
						--	minetest.add_item({x=pos.x+x,y=pos.y+y,z=pos.z+z}, name)
						--end
						
					--elseif minetest.get_item_group(name, "leaves") ~= 0 then
					--	data[p_pos] = air
					--	minetest.after(0,function(pos2)
					--		treefeller_loop(pos2)
					--	end, pos2)
					--	minetest.add_item({x=pos.x+x,y=pos.y+y,z=pos.z+z}, name)
						--treecapitator.wear_tool(inv)
						--do random drops
						--if math.random() > 0.9 then
						--	local drop = minetest.registered_items[name]["drop"]
						--	local tablelength = tablelength(drop.items)
						--	local droplist = drop.items[math.random(1,tablelength)]
						--	
						--	local drop_item = droplist.items[1]
						--		
						--	if inv:room_for_item("main", drop_item) == true then
						--		inv:add_item("main", drop_item)
						--	else
						--		minetest.add_item({x=pos.x+x,y=pos.y+y,z=pos.z+z}, drop_item)
						--	end
						--end

					--elseif minetest.get_item_group(name, "leafdecay") ~= 0 then
					--	data[p_pos] = air
					--	minetest.after(0,function(pos2)
					--		treefeller_loop(pos2)
					--	end, pos2)
					--	minetest.add_item({x=pos.x+x,y=pos.y+y,z=pos.z+z}, name)
						--treecapitator.wear_tool(inv)
						--if inv:room_for_item("main", name) == true then
						--	inv:add_item("main", name)
						--else
						--	minetest.add_item({x=pos.x+x,y=pos.y+y,z=pos.z+z}, name)
						--end	
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

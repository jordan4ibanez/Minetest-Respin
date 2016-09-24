
borer_function = function(pos,digger,radius,item,autoladder,vein_miner,auto_smelt)
	print("\n\n\n\nMAKE THIS AUTOSMELT TOO!")
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
	local ladder = minetest.get_content_id("default:ladder")
	for x = -radius,radius  do
		for z = -radius,radius  do
			for y = -radius,radius  do
				local p_pos = area:index(pos.x+x,pos.y+y,pos.z+z)
				local pos2 = {x=pos.x+x,y=pos.y+y,z=pos.z+z}
				local name = minetest.get_name_from_content_id(data[p_pos])
				
				
				if placed == nil or placed == "" then
					if minetest.get_item_group(name, typer) > 0 then 
						if vein_miner == true then
							minetest.after(0,function(pos)
								upgrade_veinminer_loop(pos)
							end, pos2)
						end
						--autoladder
						if autoladder == true and x == 0 and z == 0 then
							data[p_pos] = ladder
						else
							data[p_pos] = air
						end
						local item = minetest.get_node_drops(name)[1]
						minetest.add_item({x=pos.x+x,y=pos.y+y,z=pos.z+z}, item)
						if auto_smelt == true then
							auto_smelt_function(name, {x=pos.x+x,y=pos.y+y,z=pos.z+z})
						end
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

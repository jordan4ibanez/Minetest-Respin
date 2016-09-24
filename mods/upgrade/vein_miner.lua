--have this recursively check for ore around it (1 node radius)
upgrade_veinminer_loop = function(pos,digger)

	local min = {x=pos.x-1,y=pos.y-1,z=pos.z-1}
	local max = {x=pos.x+1,y=pos.y+1,z=pos.z+1}
	local vm = minetest.get_voxel_manip()	
	local emin, emax = vm:read_from_map(min,max)
	local area = VoxelArea:new{MinEdge=emin, MaxEdge=emax}
	local data = vm:get_data()
	
	local air = minetest.get_content_id("air")
	for x = -1,1  do
		for z = -1,1  do
			for y = -1,1  do
				local p_pos = area:index(pos.x+x,pos.y+y,pos.z+z)
				local pos2 = {x=pos.x+x,y=pos.y+y,z=pos.z+z}
				local name = minetest.get_name_from_content_id(data[p_pos])
				
				if placed == nil or placed == "" then
					if string.match(name, "stone_with_") then
						data[p_pos] = air
						
						minetest.after(0,function(pos2)
							upgrade_veinminer_loop(pos2)
						end, pos2)
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

local treefeller_rad = 5
treefeller_tool_damage = {}

minetest.register_on_dignode(function(pos, oldnode, digger)
	if digger == nil then
		return
	end
	local itemname = digger:get_wielded_item():to_string()
	local item = digger:get_wielded_item()
	if string.match(itemname, "axe_") then
		if minetest.get_item_group(oldnode.name, "tree") ~= 0 then
			treefeller_loop(pos,digger,pos,item)
		end
	end
end)


--have this recursively check for tree/leaves around it (1 node radius)
treefeller_loop = function(pos,digger,origin,item)
	if pos.x >= origin.x + treefeller_rad or pos.x <= origin.x - treefeller_rad then
		return
	end
	if pos.y >= origin.y + treefeller_rad or pos.y <= origin.y - treefeller_rad then
		return
	end	
	if pos.z >= origin.z + treefeller_rad or pos.z <= origin.z - treefeller_rad then
		return
	end
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
				local meta = minetest.get_meta(pos2)
				local is_tree = meta:get_string("tree")
				
				if placed == nil or placed == "" then
					if minetest.get_item_group(name, "tree") ~= 0 then
						if is_tree == "" then

							local wield_item = digger:get_wielded_item()
							
							--if hand then just return
							if wield_item:to_string() == "" then
								return
							end
							
							--find if wielded item is the same as the original item
							if wield_item:to_table().name ~= item:to_table().name then
								return
							end
							
							local uses = minetest.registered_items[item:to_table().name].tool_capabilities.groupcaps.choppy.uses

							
							wield_item:add_wear(65535/(uses*3))
							
							digger:set_wielded_item(wield_item)
							
							minetest.add_item({x=pos.x+x,y=pos.y+y,z=pos.z+z}, name)
							minetest.after(0,function(pos2,digger,origin,item)
								treefeller_loop(pos2,digger,origin,item)
							end, pos2,digger,origin,item)
							
							
							data[p_pos] = air
						end
						
						
						
						--the rest of this is hidden functionality 
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
	return(item)
end
--placed trees have meta, so they don't get destroyed
--useful for building things from tree, like tree wall, with tree farm inside
--it's a bit ridiculous to do this though
for name,definition in pairs(minetest.registered_nodes) do
	if definition.groups.tree ~= nil then
		minetest.override_item(name, {
			on_place = function(itemstack, placer, pointed_thing)
				
				--patch in buildable_to function
				local replace = minetest.registered_nodes[minetest.get_node(pointed_thing.under).name].buildable_to
				minetest.rotate_node(itemstack, placer, pointed_thing)
				if replace == true then
					local meta = minetest.get_meta(pointed_thing.under)
					meta:set_string("tree", "true")
				elseif replace == false then
					local meta = minetest.get_meta(pointed_thing.above)
					meta:set_string("tree", "true")
				end
				
			end
		})
	end
end


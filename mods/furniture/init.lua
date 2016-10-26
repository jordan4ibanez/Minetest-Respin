furniture = {}

function furniture.stand(player, pos)
	local player_pos = player:getpos()
	local dist = vector.distance(player_pos, pos)
	if dist > 0.7 then
		local name = player:get_player_name()
		default.player_attached[name] = false
		default.player_set_animation(player, "stand" , 30)
	else
		minetest.after(0.5, furniture.stand, player, pos)
	end
end

function furniture.register_seat(node_name)
	minetest.register_abm({
		nodenames = {node_name},
		interval = 1,
		chance = 1,
		action = function(pos, node)
			local objs = minetest.get_objects_inside_radius(pos, 0.7)
			for k,v in pairs(objs) do
				local keys = v:get_player_control()
				if keys.sneak == true and default.player_attached[name] ~= true then
					local name = v:get_player_name()
					v:setpos(pos)
					default.player_attached[name] = true
					default.player_set_animation(v, "sit" , 0)
					minetest.after(0.5, furniture.stand, v, pos)
				end
			end
		end
	})
end

function furniture.register_wooden(name, def)
	local node_def = minetest.registered_nodes[name]
	if not node_def then
		if minetest.get_current_modname() ~= "furniture" then
			minetest.log("warning", "["..minetest.get_current_modname().."] node "..name.." not found in function furniture.register_wooden")
		end
		return
	end
	local subname = name:split(':')[2]
	if not def.description then
		def.description = node_def.description
	end
	if not def.description_chair then
		def.description_chair = def.description.." Chair"
	end
	if not def.description_stool then
		def.description_stool = def.description.." Stool"
	end
	if not def.description_table then
		def.description_table = def.description.." Table"
	end
	if not def.tiles then
		def.tiles = node_def.tiles
	end
	if not def.tiles_chair then
		local tile = def.tiles[1]
		def.tiles_chair = {tile, tile, tile.."^("..tile.."^[transformR90^furniture_chair_modify.png^[makealpha:255,0,255)"}
	end
	if not def.tiles_table then
		local tile = def.tiles[1]
		def.tiles_table = {tile, tile, tile.."^("..tile.."^[transformR90^furniture_table_modify.png^[makealpha:255,0,255)"}
	end
	if not def.groups then
		local groups = table.copy(node_def.groups)
		groups.wood = 0
		groups.planks = 0
		def.groups = groups
	end
	if not def.sounds then
		def.sounds = node_def.sounds
	end
	if not def.stick then
		def.stick = "group:stick"
	end

	minetest.register_node(":furniture:chair_"..subname, {
		description = def.description_chair,
		tiles = def.tiles_chair,
		paramtype = "light",
		paramtype2 = "facedir",
		drawtype = "nodebox",
		node_box = {
			type = "fixed",
			fixed = {
				{-0.3125, -0.5, 0.1875, -0.1875, 0.5, 0.3125},
				{0.1875, -0.5, 0.1875, 0.3125, 0.5, 0.3125},
				{-0.3125, -0.5, -0.3125, -0.1875, -0.0625, -0.1875},
				{0.1875, -0.5, -0.3125, 0.3125, -0.0625, -0.1875},
				{-0.3125, -0.0625, -0.3125, 0.3125, 0.0625, 0.3125},
				{-0.1875, 0.1875, 0.25, 0.1875, 0.4375, 0.3125}
			},
		},
		selection_box = {
			type = "fixed",
			fixed = {
				{-0.3125, -0.5, -0.3125, 0.3125, 0.0625, 0.3125},
				{-0.3125, 0.0625, 0.1875, 0.3125, 0.5, 0.3125}
			}
		},
		sounds = def.sounds,
		groups = def.groups,
		on_rotate = function(pos, node, user, mode, new_param2)
			if mode ~= 1 then
				return false
			end
		end
	})

	minetest.register_node(":furniture:stool_"..subname, {
		description = def.description_stool,
		tiles = def.tiles_chair,
		paramtype = "light",
		drawtype = "nodebox",
		node_box = {
			type = "fixed",
			fixed = {
				{-0.3125, -0.5, 0.1875, -0.1875, -0.0625, 0.3125},
				{0.1875, -0.5, 0.1875, 0.3125, -0.0625, 0.3125},
				{-0.3125, -0.5, -0.3125, -0.1875, -0.0625, -0.1875},
				{0.1875, -0.5, -0.3125, 0.3125, -0.0625, -0.1875},
				{-0.3125, -0.0625, -0.3125, 0.3125, 0.0625, 0.3125}
			},
		},
		selection_box = {
			type = "fixed",
			fixed = {-0.3125, -0.5, -0.3125, 0.3125, 0.0625, 0.3125}
		},
		sounds = def.sounds,
		groups = def.groups
	})

	local fence_group = table.copy(def.groups)
	fence_group.fence = 1

	minetest.register_node(":furniture:table_"..subname, {
		description = def.description_table,
		tiles = def.tiles_table,
		paramtype = "light",
		drawtype = "nodebox",
		node_box = {
			type = "connected",
			fixed = {{-0.125, -0.5, -0.125, 0.125, 0.375, 0.125}, {-0.5, 0.375, -0.5, 0.5, 0.5, 0.5}},
			connect_front = {{-0.0625, 0.1875, -0.5, 0.0625, 0.3125, -0.125}, {-0.0625, -0.3125, -0.5, 0.0625, -0.1875, -0.125}},
			connect_left = {{-0.5, 0.1875, -0.0625, -0.125, 0.3125, 0.0625}, {-0.5, -0.3125, -0.0625, -0.125, -0.1875, 0.0625}},
			connect_back = {{-0.0625, 0.1875, 0.125, 0.0625, 0.3125, 0.5}, {-0.0625, -0.3125, 0.125, 0.0625, -0.1875, 0.5}},
			connect_right = {{0.125, 0.1875, -0.0625, 0.5, 0.3125, 0.0625}, {0.125, -0.3125, -0.0625, 0.5, -0.1875, 0.0625}}
		},
		connects_to = {"group:fence"},
		sounds = def.sounds,
		groups = fence_group
	})

	if def.handle_crafts ~= false then
		minetest.register_craft({
			output = "furniture:chair_"..subname,
			recipe = {
				{def.stick, ""},
				{name, name},
				{def.stick, def.stick}
			}
		})

		minetest.register_craft({
			output = "furniture:chair_"..subname,
			recipe = {
				{"", def.stick},
				{name, name},
				{def.stick, def.stick}
			}
		})

		minetest.register_craft({
			output = "furniture:stool_"..subname,
			recipe = {
				{name, name},
				{def.stick, def.stick}
			}
		})

		minetest.register_craft({
			output = "furniture:table_"..subname,
			recipe = {
				{name, name, name},
				{"", name, ""},
				{"", name, ""}
			}
		})
	end

	minetest.register_abm({
		nodenames = {"furniture:chair_"..subname, "furniture:stool_"..subname},
		interval = 1,
		chance = 1,
		action = function(pos, node)
			local objs = minetest.get_objects_inside_radius(pos, 0.7)
			for k,v in pairs(objs) do
				local keys = v:get_player_control()
				if keys.sneak == true and default.player_attached[name] ~= true then
					local name = v:get_player_name()
					v:setpos(pos)
					default.player_attached[name] = true
					default.player_set_animation(v, "sit" , 0)
					minetest.after(0.5, furniture.stand, v, pos)
				end
			end
		end
	})
end

function furniture.register_stone(name, def)
	local node_def = minetest.registered_nodes[name]
	if not node_def then
		if minetest.get_current_modname() ~= "furniture" then
			minetest.log("warning", "["..minetest.get_current_modname().."] node "..name.." not found in function furniture.register_stone")
		end
		return
	end
	local subname = name:split(':')[2]
	if not def.description then
		def.description = node_def.description
	end
	if not def.description_stool then
		def.description_stool = def.description.." Stool"
	end
	if not def.description_table then
		def.description_table = def.description.." Table"
	end
	if not def.tiles then
		def.tiles = node_def.tiles
	end
	if not def.groups then
		local groups = table.copy(node_def.groups)
		groups.stone = 0
		def.groups = groups
	end
	if not def.sounds then
		def.sounds = node_def.sounds
	end

	minetest.register_node(":furniture:stool_"..subname, {
		description = def.description_stool,
		tiles = def.tiles,
		paramtype = "light",
		drawtype = "nodebox",
		node_box = {
			type = "fixed",
			fixed = {-0.3125, -0.5, -0.3125, 0.3125, 0.0625, 0.3125}
		},
		sounds = def.sounds,
		groups = def.groups
	})

	local wall_group = table.copy(def.groups)
	wall_group.wall = 1

	minetest.register_node(":furniture:table_"..subname, {
		description = def.description_table,
		tiles = def.tiles,
		paramtype = "light",
		drawtype = "nodebox",
		node_box = {
			type = "connected",
			fixed = {{-0.25, -0.5, -0.25, 0.25, 0.3125, 0.25}, {-0.5, 0.3125, -0.5, 0.5, 0.5, 0.5}},
			connect_front = {-0.1875, -0.5, -0.5, 0.1875, 0.3125, -0.25},
			connect_left = {-0.5, -0.5, -0.1875, -0.25, 0.3125, 0.1875},
			connect_back = {-0.1875, -0.5, 0.25, 0.1875, 0.3125, 0.5},
			connect_right = {0.25, -0.5, -0.1875, 0.5, 0.3125, 0.1875}
		},
		connects_to = {"group:wall"},
		sounds = def.sounds,
		groups = wall_group
	})

	if def.handle_crafts ~= false then
		minetest.register_craft({
			output = "furniture:stool_"..subname,
			recipe = {
				{name, name},
				{name, name}
			}
		})

		minetest.register_craft({
			output = "furniture:table_"..subname,
			recipe = {
				{name, name, name},
				{"", name, ""},
				{"", name, ""}
			}
		})
	end

	minetest.register_abm({
		nodenames = {"furniture:stool_"..subname},
		interval = 1,
		chance = 1,
		action = function(pos, node)
			local objs = minetest.get_objects_inside_radius(pos, 0.7)
			for k,v in pairs(objs) do
				local keys = v:get_player_control()
				if keys.sneak == true and default.player_attached[name] ~= true then
					local name = v:get_player_name()
					v:setpos(pos)
					default.player_attached[name] = true
					default.player_set_animation(v, "sit" , 0)
					minetest.after(0.5, furniture.stand, v, pos)
				end
			end
		end
	})
end

function furniture.register_wool(name, def)
	local node_def = minetest.registered_nodes[name]
	if not node_def then
		if minetest.get_current_modname() ~= "furniture" then
			minetest.log("warning", "["..minetest.get_current_modname().."] node "..name.." not found in function furniture.register_stone")
		end
		return
	end
	local subname = name:split(':')[2]
	if not def.description then
		def.description = node_def.description
	end
	if not def.description_chair then
		def.description_chair = def.description.." Chair"
	end
	if not def.description_stool then
		def.description_stool = def.description.." Stool"
	end
	if not def.tiles then
		def.tiles = node_def.tiles
	end
	if not def.groups then
		def.groups = node_def.groups
	end
	if not def.sounds then
		def.sounds = node_def.sounds
	end
	if not def.stick then
		def.stick = "group:stick"
	end

	local update = function(pos, node, node_north, node_east, node_south, node_west)
		if node.param2 == 0 or node.param2 == 2 then
			if node_west == false then node_west = minetest.get_node({x = pos.x - 1, y = pos.y, z = pos.z}) end
			if node_east == false then node_east = minetest.get_node({x = pos.x + 1, y = pos.y, z = pos.z}) end
			local connect = 0
			if node_west.param2 == node.param2 and
					(node_west.name == "furniture:chair_"..subname or node_west.name == "furniture:chair_middle_"..subname or
					node_west.name == "furniture:chair_right_"..subname or node_west.name == "furniture:chair_left_"..subname) then
				connect = 1
			end
			if node_east.param2 == node.param2 and
					(node_east.name == "furniture:chair_"..subname or node_east.name == "furniture:chair_middle_"..subname or
					node_east.name == "furniture:chair_right_"..subname or node_east.name == "furniture:chair_left_"..subname) then
				connect = connect + 2
			end
			if connect == 0 then
				minetest.swap_node(pos, {name = "furniture:chair_"..subname, param2 = node.param2})
			elseif connect == 1 then
				if node.param2 == 0 then
					minetest.swap_node(pos, {name = "furniture:chair_left_"..subname, param2 = node.param2})
				else
					minetest.swap_node(pos, {name = "furniture:chair_right_"..subname, param2 = node.param2})
				end
			elseif connect == 2 then
				if node.param2 == 0 then
					minetest.swap_node(pos, {name = "furniture:chair_right_"..subname, param2 = node.param2})
				else
					minetest.swap_node(pos, {name = "furniture:chair_left_"..subname, param2 = node.param2})
				end
			else
				minetest.swap_node(pos, {name = "furniture:chair_middle_"..subname, param2 = node.param2})
			end
		elseif node.param2 == 1 or node.param2 == 3 then
			if node_north == false then node_north = minetest.get_node({x = pos.x, y = pos.y, z = pos.z + 1}) end
			if node_south == false then node_south = minetest.get_node({x = pos.x, y = pos.y, z = pos.z - 1}) end
			local connect = 0
			if node_north.param2 == node.param2 and
					(node_north.name == "furniture:chair_"..subname or node_north.name == "furniture:chair_middle_"..subname or
					node_north.name == "furniture:chair_right_"..subname or node_north.name == "furniture:chair_left_"..subname) then
				connect = 1
			end
			if node_south.param2 == node.param2 and
					(node_south.name == "furniture:chair_"..subname or node_south.name == "furniture:chair_middle_"..subname or
					node_south.name == "furniture:chair_right_"..subname or node_south.name == "furniture:chair_left_"..subname) then
				connect = connect + 2
			end
			if connect == 0 then
				minetest.swap_node(pos, {name = "furniture:chair_"..subname, param2 = node.param2})
			elseif connect == 1 then
				if node.param2 == 1 then
					minetest.swap_node(pos, {name = "furniture:chair_left_"..subname, param2 = node.param2})
				else
					minetest.swap_node(pos, {name = "furniture:chair_right_"..subname, param2 = node.param2})
				end
			elseif connect == 2 then
				if node.param2 == 1 then
					minetest.swap_node(pos, {name = "furniture:chair_right_"..subname, param2 = node.param2})
				else
					minetest.swap_node(pos, {name = "furniture:chair_left_"..subname, param2 = node.param2})
				end
			else
				minetest.swap_node(pos, {name = "furniture:chair_middle_"..subname, param2 = node.param2})
			end
		end
	end

	local dig_node = function(pos, oldnode)
		local air = {name = "air", param2 = nil}
		if oldnode.param2 == 0 or oldnode.param2 == 2 then
			local west = {x = pos.x - 1, y = pos.y, z = pos.z}
			local east = {x = pos.x + 1, y = pos.y, z = pos.z}
			local node_west = minetest.get_node(west)
			local node_east = minetest.get_node(east)
			if node_west.param2 == oldnode.param2 and
					(node_west.name == "furniture:chair_"..subname or node_west.name == "furniture:chair_middle_"..subname or
					node_west.name == "furniture:chair_right_"..subname or node_west.name == "furniture:chair_left_"..subname) then
				update(west, node_west, false, air, false, false)
			end
			if node_east.param2 == oldnode.param2 and
					(node_east.name == "furniture:chair_"..subname or node_east.name == "furniture:chair_middle_"..subname or
					node_east.name == "furniture:chair_right_"..subname or node_east.name == "furniture:chair_left_"..subname) then
				update(east, node_east, false, false, false, air)
			end
		else
			local north = {x = pos.x, y = pos.y, z = pos.z + 1}
			local south = {x = pos.x, y = pos.y, z = pos.z - 1}
			local node_north = minetest.get_node(north)
			local node_south = minetest.get_node(south)
			if node_north.param2 == oldnode.param2 and
					(node_north.name == "furniture:chair_"..subname or node_north.name == "furniture:chair_middle_"..subname or
					node_north.name == "furniture:chair_right_"..subname or node_north.name == "furniture:chair_left_"..subname) then
				update(north, node_north, false, false, air, false)
			end
			if node_south.param2 == oldnode.param2 and
					(node_south.name == "furniture:chair_"..subname or node_south.name == "furniture:chair_middle_"..subname or
					node_south.name == "furniture:chair_right_"..subname or node_south.name == "furniture:chair_left_"..subname) then
				update(south, node_south, air, false, false, false)
			end
		end
	end

	local rotate = function(pos, node, new_param2)
		local north = {x = pos.x, y = pos.y, z = pos.z + 1}
		local east = {x = pos.x + 1, y = pos.y, z = pos.z}
		local south = {x = pos.x, y = pos.y, z = pos.z - 1}
		local west = {x = pos.x - 1, y = pos.y, z = pos.z}
		local node_north = minetest.get_node(north)
		local node_east = minetest.get_node(east)
		local node_south = minetest.get_node(south)
		local node_west = minetest.get_node(west)
		new_node = {name = node.name, param2 = new_param2}
		update(pos, new_node, node_north, node_east, node_south, node_west)
		if node_north.name == "furniture:chair_"..subname or node_north.name == "furniture:chair_middle_"..subname or
				node_north.name == "furniture:chair_right_"..subname or node_north.name == "furniture:chair_left_"..subname then
			update(north, node_north, false, false, new_node, false)
		end
		if node_east.name == "furniture:chair_"..subname or node_east.name == "furniture:chair_middle_"..subname or
				node_east.name == "furniture:chair_right_"..subname or node_east.name == "furniture:chair_left_"..subname then
			update(east, node_east, false, false, false, new_node)
		end
		if node_south.name == "furniture:chair_"..subname or node_south.name == "furniture:chair_middle_"..subname or
				node_south.name == "furniture:chair_right_"..subname or node_south.name == "furniture:chair_left_"..subname then
			update(south, node_south, new_node, false, false, false)
		end
		if node_west.name == "furniture:chair_"..subname or node_west.name == "furniture:chair_middle_"..subname or
				node_west.name == "furniture:chair_right_"..subname or node_west.name == "furniture:chair_left_"..subname then
			update(west, node_west, false, new_node, false, false)
		end
	end

	minetest.register_node(":furniture:chair_"..subname, {
		description = def.description_chair,
		tiles = def.tiles,
		paramtype = "light",
		paramtype2 = "facedir",
		drawtype = "nodebox",
		node_box = {
			type = "fixed",
			fixed = {
				{-0.5, -0.5, -0.3125, 0.5, 0, 0.5},
				{-0.5, 0, 0.3125, 0.5, 0.5, 0.5},
				{-0.5, 0, -0.3125, -0.3125, 0.1875, 0.3125},
				{0.3125, 0, -0.3125, 0.5, 0.1875, 0.3125}
			}
		},
		sounds = def.sounds,
		groups = def.groups,
		after_place_node = function(pos, placer, itemstack, pointed_thing)
			local node = minetest.get_node(pos)
			update(pos, node, false, false, false, false)
			if node.param2 == 0 or node.param2 == 2 then
				local west = {x = pos.x - 1, y = pos.y, z = pos.z}
				local east = {x = pos.x + 1, y = pos.y, z = pos.z}
				local node_west = minetest.get_node(west)
				local node_east = minetest.get_node(east)
				if node_west.param2 == node.param2 and
						(node_west.name == "furniture:chair_"..subname or node_west.name == "furniture:chair_middle_"..subname or
						node_west.name == "furniture:chair_right_"..subname or node_west.name == "furniture:chair_left_"..subname) then
					update(west, node_west, false, false, false, false)
				end
				if node_east.param2 == node.param2 and
						(node_east.name == "furniture:chair_"..subname or node_east.name == "furniture:chair_middle_"..subname or
						node_east.name == "furniture:chair_right_"..subname or node_east.name == "furniture:chair_left_"..subname) then
					update(east, node_east, false, false, false, false)
				end
			else
				local north = {x = pos.x, y = pos.y, z = pos.z + 1}
				local south = {x = pos.x, y = pos.y, z = pos.z - 1}
				local node_north = minetest.get_node(north)
				local node_south = minetest.get_node(south)
				if node_north.param2 == node.param2 and
						(node_north.name == "furniture:chair_"..subname or node_north.name == "furniture:chair_middle_"..subname or
						node_north.name == "furniture:chair_right_"..subname or node_north.name == "furniture:chair_left_"..subname) then
					update(north, node_north, false, false, false, false)
				end
				if node_south.param2 == node.param2 and
						(node_south.name == "furniture:chair_"..subname or node_south.name == "furniture:chair_middle_"..subname or
						node_south.name == "furniture:chair_right_"..subname or node_south.name == "furniture:chair_left_"..subname) then
					update(south, node_south, false, false, false, false)
				end
			end
		end,
		after_dig_node = function(pos, oldnode, oldmetadata, digger)
			dig_node(pos, oldnode)
		end,
		on_rotate = function(pos, node, user, mode, new_param2)
			if mode == 1 then
				rotate(pos, node, new_param2)
			else
				minetest.swap_node(pos, {name = "furniture:chair_middle_"..subname, param2 = node.param2})
			end
			return true
		end
	})

	local nocgroup = table.copy(def.groups)
	nocgroup.not_in_creative_inventory = 1

	minetest.register_node(":furniture:chair_middle_"..subname, {
		description = def.description_chair,
		tiles = def.tiles,
		paramtype = "light",
		paramtype2 = "facedir",
		drawtype = "nodebox",
		node_box = {
			type = "fixed",
			fixed = {
				{-0.5, -0.5, -0.3125, 0.5, 0, 0.5},
				{-0.5, 0, 0.3125, 0.5, 0.5, 0.5}
			}
		},
		drop = "furniture:chair_"..subname,
		sounds = def.sounds,
		groups = nocgroup,
		after_dig_node = function(pos, oldnode, oldmetadata, digger)
			dig_node(pos, oldnode)
		end,
		on_rotate = function(pos, node, user, mode, new_param2)
			if mode == 1 then
				rotate(pos, node, new_param2)
			else
				minetest.swap_node(pos, {name = "furniture:chair_right_"..subname, param2 = node.param2})
			end
			return true
		end
	})

	minetest.register_node(":furniture:chair_right_"..subname, {
		description = def.description_chair,
		tiles = def.tiles,
		paramtype = "light",
		paramtype2 = "facedir",
		drawtype = "nodebox",
		node_box = {
			type = "fixed",
			fixed = {
				{-0.5, -0.5, -0.3125, 0.5, 0, 0.5},
				{-0.5, 0, 0.3125, 0.5, 0.5, 0.5},
				{-0.5, 0, -0.3125, -0.3125, 0.1875, 0.3125}
			}
		},
		drop = "furniture:chair_"..subname,
		sounds = def.sounds,
		groups = nocgroup,
		after_dig_node = function(pos, oldnode, oldmetadata, digger)
			dig_node(pos, oldnode)
		end,
		on_rotate = function(pos, node, user, mode, new_param2)
			if mode == 1 then
				rotate(pos, node, new_param2)
			else
				minetest.swap_node(pos, {name = "furniture:chair_left_"..subname, param2 = node.param2})
			end
			return true
		end
	})

	minetest.register_node(":furniture:chair_left_"..subname, {
		description = def.description_chair,
		tiles = def.tiles,
		paramtype = "light",
		paramtype2 = "facedir",
		drawtype = "nodebox",
		node_box = {
			type = "fixed",
			fixed = {
				{-0.5, -0.5, -0.3125, 0.5, 0, 0.5},
				{-0.5, 0, 0.3125, 0.5, 0.5, 0.5},
				{0.3125, 0, -0.3125, 0.5, 0.1875, 0.3125}
			}
		},
		drop = "furniture:chair_"..subname,
		sounds = def.sounds,
		groups = nocgroup,
		after_dig_node = function(pos, oldnode, oldmetadata, digger)
			dig_node(pos, oldnode)
		end,
		on_rotate = function(pos, node, user, mode, new_param2)
			if mode == 1 then
				rotate(pos, node, new_param2)
			else
				minetest.swap_node(pos, {name = "furniture:chair_"..subname, param2 = node.param2})
			end
			return true
		end
	})

	minetest.register_node(":furniture:stool_"..subname, {
		description = def.description_stool,
		tiles = def.tiles,
		paramtype = "light",
		drawtype = "nodebox",
		node_box = {
			type = "fixed",
			fixed = {-0.3125, -0.5, -0.3125, 0.3125, 0.0625, 0.3125}
		},
		sounds = def.sounds,
		groups = def.groups
	})

	if def.handle_crafts ~= false then
		minetest.register_craft({
			output = "furniture:chair_"..subname,
			recipe = {
				{name, "", name},
				{name, name, name},
				{def.stick, def.stick, def.stick}
			}
		})

		minetest.register_craft({
			output = "furniture:stool_"..subname,
			recipe = {
				{name, name},
				{def.stick, def.stick}
			}
		})
	end

	minetest.register_abm({
		nodenames = {"furniture:chair_"..subname, "furniture:chair_middle_"..subname, "furniture:chair_right_"..subname,
				"furniture:chair_left_"..subname, "furniture:stool_"..subname},
		interval = 1,
		chance = 1,
		action = function(pos, node)
			local objs = minetest.get_objects_inside_radius(pos, 0.7)
			for k,v in pairs(objs) do
				local keys = v:get_player_control()
				if keys.sneak == true and default.player_attached[name] ~= true then
					local name = v:get_player_name()
					v:setpos(pos)
					default.player_attached[name] = true
					default.player_set_animation(v, "sit" , 0)
					minetest.after(0.5, furniture.stand, v, pos)
				end
			end
		end
	})
end

furniture.register_wooden("default:wood", {description = "Wooden"})
furniture.register_wooden("default:junglewood", {description="Junglewood"})
furniture.register_wooden("default:pine_wood", {description="Pine Wood"})
furniture.register_wooden("default:acacia_wood", {description="Acacia Wood"})
furniture.register_wooden("default:aspen_wood", {description="Aspen Wood"})

furniture.register_stone("default:cobble", {})
furniture.register_stone("default:mossycobble", {})
furniture.register_stone("default:desert_cobble", {})

if minetest.get_modpath("wool") then
	local color_table = {
		"white", "grey", "black", "red", "yellow", "green", "cyan", "blue",
		"magenta", "orange", "violet", "brown", "pink", "dark_grey", "dark_green"
	}

	for _,v in ipairs(color_table) do
		furniture.register_wool("wool:"..v, {})
	end
end

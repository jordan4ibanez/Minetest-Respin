
--
-- 3d torch part
--

torch_particle_table = {}

local function torch_particles(pos)
	if torch_particle_table[pos] == nil then
		local id = minetest.add_particlespawner({
			amount = 5,
			time = 0,
			minpos = {x=pos.x-0.1,y=pos.y+0.1,z=pos.z-0.1},
			maxpos = {x=pos.x+0.1,y=pos.y+0.1,z=pos.z+0.1},
			minvel = {x=0, y=0.3, z=0},
			maxvel = {x=0, y=0.5, z=0},
			minacc = {x=0, y=0, z=0},
			maxacc = {x=0, y=0, z=0},
			minexptime = 1,
			maxexptime = 1,
			minsize = 2,
			maxsize = 2,
			collisiondetection = false,
			vertical = false,
			texture = "torch_smoke.png",
		})
		
		if torch_particle_table[pos.x] == nil then
			torch_particle_table[pos.x] = {}
		end
		if torch_particle_table[pos.x][pos.y] == nil then
			torch_particle_table[pos.x][pos.y] = {}
		end
		if torch_particle_table[pos.x][pos.y][pos.z] == nil then
			torch_particle_table[pos.x][pos.y][pos.z] = id
		end
	end
end
local function destroy_torch_particles(pos)
	if torch_particle_table[pos.x][pos.y][pos.z] ~= nil then
		print(torch_particle_table[pos.x][pos.y][pos.z])
		minetest.delete_particlespawner(torch_particle_table[pos.x][pos.y][pos.z])
	end
end
minetest.register_lbm({
	name = "torches:remove_fire",
	nodenames = {"default:torch", "default:torch_wall"},
	run_at_every_load = true,
	action = function(pos, node)
		torch_particles(pos)
	end,
})

minetest.register_node(":default:torch", {
	description = "Torch",
	drawtype = "mesh",
	mesh = "torch_floor.obj",
	inventory_image = "default_torch_on_floor.png",
	wield_image = "default_torch_on_floor.png",
	tiles = {{
		    name = "default_torch_on_floor_animated.png",
		    animation = {type = "vertical_frames", aspect_w = 16, aspect_h = 16, length = 3.3}
	}},
	paramtype = "light",
	paramtype2 = "wallmounted",
	sunlight_propagates = true,
	walkable = false,
	liquids_pointable = false,
	light_source = 13,
	groups = {choppy=2, dig_immediate=3, flammable=1, attached_node=1, torch=1},
	drop = "default:torch",
	selection_box = {
		type = "wallmounted",
		wall_top = {-1/16, -2/16, -1/16, 1/16, 0.5, 1/16},
		wall_bottom = {-1/16, -0.5, -1/16, 1/16, 2/16, 1/16},
	},
	sounds = default.node_sound_wood_defaults(),
	on_place = function(itemstack, placer, pointed_thing)
		local above = pointed_thing.above
		local under = pointed_thing.under
		local wdir = minetest.dir_to_wallmounted({x = under.x - above.x, y = under.y - above.y, z = under.z - above.z})
		local fakestack = itemstack
		local retval = false
		if wdir <= 1 then
			retval = fakestack:set_name("default:torch")
		else
			retval = fakestack:set_name("default:torch_wall")
		end
		if not retval then
			return itemstack
		end
		--patch in buildable_to function
		local replace = minetest.registered_nodes[minetest.get_node(pointed_thing.under).name].buildable_to
		if replace == true then
			torch_particles(pointed_thing.under)
		elseif replace == false then
			torch_particles(pointed_thing.above)
		end
		itemstack, retval = minetest.item_place(fakestack, placer, pointed_thing, wdir)

		itemstack:set_name("default:torch")

		return itemstack
	end,
	after_destruct = function(pos, oldnode)
		destroy_torch_particles(pos)
	end,
	on_dig = function(pos, node, player)
		destroy_torch_particles(pos)
		minetest.node_dig(pos, node, player)
	end,
})

minetest.register_node(":default:torch_wall", {
	drawtype = "mesh",
	mesh = "torch_wall.obj",
	tiles = {{
		    name = "default_torch_on_floor_animated.png",
		    animation = {type = "vertical_frames", aspect_w = 16, aspect_h = 16, length = 3.3}
	}},
	paramtype = "light",
	paramtype2 = "wallmounted",
	sunlight_propagates = true,
	walkable = false,
	light_source = 13,
	groups = {choppy=2, dig_immediate=3, flammable=1, not_in_creative_inventory=1, attached_node=1, torch=1},
	drop = "default:torch",
	selection_box = {
		type = "wallmounted",
		wall_top = {-0.1, -0.1, -0.1, 0.1, 0.5, 0.1},
		wall_bottom = {-0.1, -0.5, -0.1, 0.1, 0.1, 0.1},
		wall_side = {-0.5, -0.3, -0.1, -0.2, 0.3, 0.1},
	},
	sounds = default.node_sound_wood_defaults(),
	after_destruct = function(pos, oldnode)
		destroy_torch_particles(pos)
	end,
	on_dig = function(pos, node, player)
		destroy_torch_particles(pos)
		minetest.node_dig(pos, node, player)
	end,
})

minetest.register_lbm({
	name = "torches:convert_wallmounted",
	nodenames = {"default:torch", "torches:floor", "torches:wall"},
	action = function(pos, node)
		if node.param2 >= 2 then
			minetest.set_node(pos, {name = "default:torch_wall",
				param2 = node.param2})
		else
			minetest.set_node(pos, {name = "default:torch",
				param2 = node.param2})
		end
	end
})

--
-- torch wield light
--

if not minetest.is_yes(minetest.setting_get("torches_wieldlight_enable") or true) then
	return
end
local torchlight_update_interval = minetest.setting_get("torches_wieldlight_interval") or 0.25

minetest.register_node("torches:torchlight", {
	drawtype = "airlike",
	groups = {not_in_creative_inventory = 1},
	walkable = false,
	paramtype = "light",
	sunlight_propagates = true,
	light_source = 11,
	pointable = false,
	buildable_to = true,
	drops = {},
})

-- state tables
local torchlight = {}
local playerlist = {}

local function wields_torch(player)
	if not player then
		return false
	end
	local item = player:get_wielded_item()
	if not item then
		return false
	end
	return item:get_name() == "default:torch"
end

local function wielded_torch(name)
	if not torchlight[name] then
		return false
	end
	return true
end

local function is_torchlight(pos)
	local node = minetest.get_node(pos)
	return node.name == "torches:torchlight"
end

local function remove_torchlight(pos)
	if is_torchlight(pos) then
		minetest.swap_node(pos, {name = "air"})
	end
end

local function place_torchlight(pos)
	local name = minetest.get_node(pos).name
	if name == "torches:torchlight" then
		return true
	end
	if (minetest.get_node_light(pos) or 0) > 11 then
		-- no reason to place torch here, so save a bunch
		-- of node updates this way
		return false
	end
	if name == "air" then
		minetest.swap_node(pos, {name = "torches:torchlight"})
		return true
	end
	return false
end

local function get_torchpos(player)
	return vector.add({x = 0, y = 1, z = 0}, vector.round(player:getpos()))
end

minetest.register_on_joinplayer(function(player)
	local name = player:get_player_name()
	playerlist[name] = true
end)

minetest.register_on_leaveplayer(function(player)
	local name = player:get_player_name()
	-- don't look at wielded() here, it's likely invalid
	if torchlight[name] then
		remove_torchlight(torchlight[name])
		torchlight[name] = nil
	end
	playerlist[name] = nil
end)

minetest.register_on_shutdown(function()
	for i, _ in pairs(torchlight) do
		remove_torchlight(torchlight[i])
	end
end)

local function update_torchlight(dtime)
	for name, _ in pairs(playerlist) do
		local player = minetest.get_player_by_name(name)
		local wielded = wielded_torch(name)
		local wields = wields_torch(player)

		if not wielded and wields then
			local torchpos = get_torchpos(player)
			if place_torchlight(torchpos) then
				torchlight[name] = vector.new(torchpos)
			end
		elseif wielded and not wields then
			remove_torchlight(torchlight[name])
			torchlight[name] = nil
		elseif wielded and wields then
			local torchpos = get_torchpos(player)
			if not vector.equals(torchpos, torchlight[name]) or
					not is_torchlight(torchpos) then
				if place_torchlight(torchpos) then
					remove_torchlight(torchlight[name])
					torchlight[name] = vector.new(torchpos)
				elseif vector.distance(torchlight[name], torchpos) > 2 then
					-- player went into some node
					remove_torchlight(torchlight[name])
					torchlight[name] = nil
				end
			end
		end
	end
	minetest.after(torchlight_update_interval, update_torchlight)
end

minetest.after(torchlight_update_interval, update_torchlight)


world_assistant = {}

minetest.register_on_punchnode(function(pos, node, puncher, pointed_thing)
	local mod_name  = minetest.registered_items[node.name].mod_origin
	local node_name = minetest.registered_items[node.name].description

	local tool = ""
	if minetest.registered_items[node.name].groups ~= nil then
		if minetest.registered_items[node.name].groups.crumbly then
			tool = "Shovel"
		elseif  minetest.registered_items[node.name].groups.cracky then
			tool = "Pick"
		elseif  minetest.registered_items[node.name].groups.choppy  then
			tool = "Axe"
		else
			tool = "Hand"
		end
	end
	
	local text = node_name.."\nMod: "..mod_name.."\nTool: "..tool
	
	--create blank hud table
	if world_assistant[puncher:get_player_name()] == nil then
		world_assistant[puncher:get_player_name()] = {}
	end

	--remove all old huds
	if world_assistant[puncher:get_player_name()]["id1"] ~= nil then
		puncher:hud_remove(world_assistant[puncher:get_player_name()]["id1"])
	end
	if world_assistant[puncher:get_player_name()]["background"] ~= nil then
		puncher:hud_remove(world_assistant[puncher:get_player_name()]["background"])
	end
	
	--reset the hud remove timer
	world_assistant[puncher:get_player_name()]["time"] = 0
	
	local background = puncher:hud_add({
			hud_elem_type = "image",
			position = {x = 0.5, y = 0.06},
			scale = {
				x = -26,
				y = -12
			},
		text = "world_assistant_background.png",
		})
	local id = puncher:hud_add({
		hud_elem_type = "text",
		position = {x = 0.5, y = 0.06},
		number = 0xFFFFFF,
		scale = {
			x = -100,
			y = -100
		},
	text = text,
	})
	
	world_assistant[puncher:get_player_name()]["id1"] = id
	world_assistant[puncher:get_player_name()]["background"] = background

end)
minetest.register_globalstep(function(dtime)
	for _,player in ipairs(minetest.get_connected_players()) do
		if world_assistant[player:get_player_name()] ~= nil then
			world_assistant[player:get_player_name()]["time"] = world_assistant[player:get_player_name()]["time"] + dtime
			if world_assistant[player:get_player_name()]["time"] > 2 then
				--remove all old huds
				if world_assistant[player:get_player_name()]["id1"] ~= nil then
					player:hud_remove(world_assistant[player:get_player_name()]["id1"])
				end
				if world_assistant[player:get_player_name()]["background"] ~= nil then
					player:hud_remove(world_assistant[player:get_player_name()]["background"])
				end			
			end
		end
	end
end)


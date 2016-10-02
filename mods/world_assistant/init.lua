world_assistant = {}



--[[
minetest.register_globalstep(function(dtime)
	for _,player in ipairs(minetest.get_connected_players()) do
		local pos = player:getpos()
		local lookdir = player:get_look_dir()
		--this isn't even close to perfect
		for i = 1,2 do
			local node = minetest.get_node({x=pos.x+(lookdir.x*i),y=pos.y+1.75+(lookdir.y*i),z=pos.z+(lookdir.z*i)}).name
			if node ~= "air" and minetest.registered_items[node].pointable == true then
				if node_help[player:get_player_name()] == nil then
					node_help[player:get_player_name()] = {}
					node_help[player:get_player_name()]["id"] = 0
					node_help[player:get_player_name()]["node"] = "air"
				end
				if node_help[player:get_player_name()]["id"] ~= nil then
					if node_help[player:get_player_name()]["node"] ~= node then

						player:hud_remove(node_help[player:get_player_name()]["id"])
						
						local text = ""
						--print(dump(minetest.registered_items[node]))
						text = text.."Mod:  "..minetest.registered_items[node].mod_origin.."\n"
						text = text.."Node: "..minetest.registered_items[node].description.."\n"
						if minetest.registered_items[node].groups.crumbly > 0 then
							text = text.."Tool: Shovel\n"
						elseif  minetest.registered_items[node].groups.cracky > 0 then
							text = text.."Tool: Pick\n"
						elseif  minetest.registered_items[node].groups.choppy > 0 then
							text = text.."Tool: Axe\n"
						end
						local id = player:hud_add({
							hud_elem_type = "text",
							position = {x = 0.5, y = 0.1},
							scale = {
								x = -100,
								y = -100
							},
						text = text,
						})
						node_help[player:get_player_name()]["id"] = id
						node_help[player:get_player_name()]["node"] = node
						return
					end
				end
			end
		end
		
		if node_help[player:get_player_name()] ~= nil then
			if node_help[player:get_player_name()]["id"] ~= nil then
				player:hud_remove(node_help[player:get_player_name()]["id"])
				node_help[player:get_player_name()]["node"] = ""
				node_help[player:get_player_name()]["id"] = nil
			end
		end
		
	end
end)
]]--		

--[[
--start registering things
minetest.register_on_punchnode(function(pos, node, puncher, pointed_thing)
		--try to understand the node (they seem to talk chinese)
		local node = minetest.get_node_or_nil(pointed_thing.under)
		local name = node.name
		--send what we know from the lolling node
		local id1 = puncher:hud_add({
			hud_elem_type = "image",
			position = {x = 0.5, y = 0.02},
			scale = {
				x = -26,
				y = -12
			},
		text = "NodeExplorer_HUD.png",
		})
		local id2 = puncher:hud_add({
			hud_elem_type = "text",
			position = {x = 0.5, y = 0.03},
			scale = {
				x = -100,
				y = -100
			},
		text = "  You have touched: \n''" .. name .. "''."
		})
		--then remove it
	minetest.after(1.1, function(name)
	puncher:hud_remove(id1)
	puncher:hud_remove(id2)
	end)	
end)
]]--

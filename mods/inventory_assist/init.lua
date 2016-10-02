inventory_assist = {}

minetest.register_globalstep(function(dtime)
	for _,player in ipairs(minetest.get_connected_players()) do
		--create blank table
		if inventory_assist[player:get_player_name()] == nil then
			inventory_assist[player:get_player_name()] = {}
		end
		
		local item = player:get_wielded_item():to_table()
		
		-- only check if on the same index as last time
		if inventory_assist[player:get_player_name()]["wield_index"] == player:get_wield_index() then
			if inventory_assist[player:get_player_name()]["item"] ~= "" and item == nil then
				if inventory_assist[player:get_player_name()]["count"] == 1 then
					--only replenish if mining or building
					if player:get_player_control().RMB == true or player:get_player_control().LMB == true then
						--replenish item
						local inv = player:get_inventory()
						if inv:contains_item("main",  inventory_assist[player:get_player_name()]["item"]) == true then
							local typer = minetest.registered_items[inventory_assist[player:get_player_name()]["item"]].type
							local count = 0
							if typer == "tool" then
								count = 1
							else
								count = 99
							end
							local stack = inv:remove_item("main", inventory_assist[player:get_player_name()]["item"].." "..count)
							player:set_wielded_item(stack)
							return(inv)
						end
					end
				end
			end
					
		end
		-- do new settings
		if item ~= nil then
			inventory_assist[player:get_player_name()]["item"] = item.name
			inventory_assist[player:get_player_name()]["count"] = item.count
			inventory_assist[player:get_player_name()]["wield_index"] =  player:get_wield_index()
		end
	end
end)

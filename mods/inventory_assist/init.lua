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
					local controls = player:get_player_control()
					if controls.RMB == true or controls.LMB == true then
						--replenish item
						local inv = player:get_inventory()
						if inv:contains_item("main",  inventory_assist[player:get_player_name()]["item"]) == true then
							local pos = player:getpos()
							minetest.sound_play("replenish_item", {
								pos = pos,
								max_hear_distance = 3,
								gain = 1.0,
							})
							local typer = minetest.registered_items[inventory_assist[player:get_player_name()]["item"]].type
							local count = 0
							if typer == "tool" then
								count = 1
							else
								count = 99
							end
							local stack = inv:remove_item("main", inventory_assist[player:get_player_name()]["item"].." "..count)
							player:set_wielded_item(stack)
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

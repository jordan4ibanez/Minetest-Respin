
function old_update_player_too_many_items(player)
	recipe_page[player:get_player_name()] = 1
	local formspec = "size[14,8.5]bgcolor[#080808BB;true]background[5,5;1,1;gui_formbg.png;true]listcolors[#00000069;#5A5A5A;#141318;#30434C;#FFF]list[current_player;main;0,4.25;8,1;]list[current_player;main;0,5.5;8,3;8]list[current_player;craft;1.75,0.5;3,3;]list[current_player;craftpreview;5.75,1.5;1,1;]image[4.75,1.5;1,1;gui_furnace_arrow_bg.png^[transformR270]listring[current_player;main]listring[current_player;craft]image[0,4.25;1,1;gui_hb_bg.png]image[1,4.25;1,1;gui_hb_bg.png]image[2,4.25;1,1;gui_hb_bg.png]image[3,4.25;1,1;gui_hb_bg.png]image[4,4.25;1,1;gui_hb_bg.png]image[5,4.25;1,1;gui_hb_bg.png]image[6,4.25;1,1;gui_hb_bg.png]image[7,4.25;1,1;gui_hb_bg.png]"
	local count = player_pages[player:get_player_name()] * (8*6) + 1
	for y = 0,7 do
		for x = 1,6 do
			--create a partial display of items to not crash
			if not too_many_items_table[count] then
				break
			end
			formspec = formspec.."item_image_button["..tostring(x+7)..","..tostring(y)..";1,1;"..too_many_items_table[count]..";"..too_many_items_table[count]..";]"
			count = count + 1
		end
	end
	--navigation buttons
	--page length 
	local page = (player_pages[player:get_player_name()]+1).."/"..(math.ceil(total_items/((8*6) + 1)))
	formspec = formspec.."label[10.75,8.25;"..page.."]"
	formspec = formspec.."button[9,8;1.5,1;PREV;PREV]"
	formspec = formspec.."button[12,8;1.5,1;NEXT;NEXT]"
	player:set_inventory_formspec(formspec)
end



--show the item recipe
function old_show_recipe_too_many_items(player, item)

	print(dump(item))
	local formspec = "size[14,8.5]bgcolor[#080808BB;true]background[5,5;1,1;gui_formbg.png;true]listcolors[#00000069;#5A5A5A;#141318;#30434C;#FFF]list[current_player;main;0,4.25;8,1;]list[current_player;main;0,5.5;8,3;8]list[current_player;craft;1.75,0.5;3,3;]list[current_player;craftpreview;5.75,1.5;1,1;]image[4.75,1.5;1,1;gui_furnace_arrow_bg.png^[transformR270]listring[current_player;main]listring[current_player;craft]image[0,4.25;1,1;gui_hb_bg.png]image[1,4.25;1,1;gui_hb_bg.png]image[2,4.25;1,1;gui_hb_bg.png]image[3,4.25;1,1;gui_hb_bg.png]image[4,4.25;1,1;gui_hb_bg.png]image[5,4.25;1,1;gui_hb_bg.png]image[6,4.25;1,1;gui_hb_bg.png]image[7,4.25;1,1;gui_hb_bg.png]"
	local count = 1
	
	player_item_recipe[player:get_player_name()] = item
	
	
	recipe_selection = recipe_page[player:get_player_name()] -- get the player's selection of craft recipe
	if not item then
		return
	end
	
	for y = 1,3 do
		for x = 1,3 do
			--print(dump(recipe[recipe_selection]["items"]))
			--print(dump(recipe[recipe_selection]["items"][count]))
			if recipe[recipe_selection] then
				if recipe[recipe_selection]["items"][count] then
				
					local group_test = recipe[recipe_selection]["items"][count]:gsub("group:", "")
					
					local item = recipe[recipe_selection]["items"][count]
					print(dump(item))
					
					if too_many_items_group_items[group_test] then
						
						if not player_item_recipe_table[player:get_player_name()][group_test] then
							player_item_recipe_table[player:get_player_name()][group_test] = 1
						end
						item = too_many_items_group_items[group_test][player_item_recipe_table[player:get_player_name()][group_test]]
					end
					print(item)
					--read below purposely made error
				
					--if item group then get items in too_many_items_group_items[group] and cycle them using table length
					
					formspec = formspec.."item_image_button["..tostring(x + 0.75)..","..tostring(y-0.5)..";1,1;"..item..";"..item..";]"
				end
			end
			count = count + 1
		end
	end
	--print(dump())
	--output
	formspec = formspec.."item_image_button["..tostring(5.75)..","..tostring(1.5)..";1,1;"..item..";"..item..";]"
	
	--navigate recipes
	formspec = formspec.."button[1.5,3.4;1.5,1;PREVRECIPE;PREV]"
	formspec = formspec.."button[3.5,3.4;1.5,1;NEXTRECIPE;NEXT]"	
	--navigation buttons
	--page length 
	local page = (player_pages[player:get_player_name()]+1).."/"..(math.ceil(total_items/((8*6) + 1)))
	formspec = formspec.."label[10.75,8.25;"..page.."]"
	formspec = formspec.."button[9,8;1.5,1;PREV;PREV]"
	formspec = formspec.."button[12,8;1.5,1;NEXT;NEXT]"
	player:set_inventory_formspec(formspec)
end

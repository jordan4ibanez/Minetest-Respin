player_hurt_table = {}
--play sound on player hurt
minetest.register_on_player_hpchange(function(player, hp_change)
	local health = player:get_hp()
	if health > 0 and hp_change < 0 then
		minetest.sound_play("player_hurt", {
			pos = pos,
			max_hear_distance = 10,
			gain = 0.5,
		})
	elseif health <= 0 and hp_change <= 0 and player_hurt_table[player:get_player_name()] == nil then
		minetest.sound_play("player_death", {
			pos = pos,
			max_hear_distance = 10,
			gain = 0.5,
		})
		--prevent spamming of death sound
		player_hurt_table[player:get_player_name()] = true
	end
end)
--reset the player hurt table to allow hurt sound to play again
minetest.register_on_respawnplayer(function(player)
	if player_hurt_table[player:get_player_name()] ~= nil then
		player_hurt_table[player:get_player_name()] = nil
	end
end)

--throw items everywhere
minetest.register_on_dieplayer(function(player)
	local pos = player:getpos()
	local inv = player:get_inventory()
	local main_count = inv:get_size("main")
	local craft_count = inv:get_size("craft")

	if pos == nil or inv == nil or main_count == nil or craft_count == nil then
		return
	end
	
	for i = 1,main_count do
		local stack = inv:get_stack("main", i)
		inv:set_stack("main", i, "")
		local item = minetest.add_item(pos, stack)
		if item ~= nil then
			item:setvelocity({x=math.random(-5,5),y=math.random(3,7),z=math.random(-5,5)})
		end
	end
	for i = 1,craft_count do
		local stack = inv:get_stack("craft", i)
		inv:set_stack("craft", i, "")
		local item = minetest.add_item(pos, stack)
		if item ~= nil then
			item:setvelocity({x=math.random(-5,5),y=math.random(3,7),z=math.random(-5,5)})
		end
	end
end)

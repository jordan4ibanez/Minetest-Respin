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
	print("\n\n\n\n\nMAKE PLAYER SMALLER TO SIMULATE LAYING DOWN LIKE IN BED")
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

--figure out some way to enable the minimap
minetest.register_on_joinplayer(function(player)
	minetest.after(1, function()
		minetest.setting_set("enable_minimap", "true")
	end)
end)

--add food particles
function core.item_eat(hp_change, replace_with_item)
	return function(itemstack, user, pointed_thing)  -- closure
		local pos = user:getpos()
		local vel = user:get_player_velocity()
		pos.y = pos.y + item_drop_settings.player_collect_height
		local itemname = itemstack:get_name()
		local texture  = minetest.registered_items[itemname].inventory_image
		minetest.add_item(pos, drop)
		  minetest.add_particlespawner({
			 amount = 20,
			 time = 0.1,
			 minpos = {x=pos.x, y=pos.y, z=pos.z},
			 maxpos = {x=pos.x, y=pos.y, z=pos.z},
			 minvel = {x=vel.x-1, y=vel.y+1, z=vel.z-1},
			 maxvel = {x=vel.x+1, y=vel.y+2, z=vel.z+1},
			 minacc = {x=0, y=-5, z=0},
			 maxacc = {x=0, y=-9, z=0},
			 minexptime = 1,
			 maxexptime = 1,
			 minsize = 1,
			 maxsize = 2,
			 collisiondetection = true,
			 vertical = false,
			 texture = texture,
		})
		minetest.sound_play("bite_item_drop", {
			pos = pos,
			max_hear_distance = 100,
			gain = 10.0,
		})
		return core.do_item_eat(hp_change, replace_with_item, itemstack, user, pointed_thing)
	end
end

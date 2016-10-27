minetest.override_item("default:dirt", {
	groups = {crumbly=3, soil=1},
	soil = {
		base = "default:dirt",
		dry = "farming:soil",
		wet = "farming:soil_wet"
	}
})

minetest.override_item("default:dirt_with_grass", {
	groups = {crumbly=3, soil=1},
	soil = {
		base = "default:dirt_with_grass",
		dry = "farming:soil",
		wet = "farming:soil_wet"
	}
})

minetest.override_item("default:dirt_with_dry_grass", {
	groups = {crumbly=3, soil=1},
	soil = {
		base = "default:dirt_with_dry_grass",
		dry = "farming:soil",
		wet = "farming:soil_wet"
	}
})

minetest.register_node("farming:soil", {
	description = "Soil",
	tiles = {"default_dirt.png^farming_soil.png", "default_dirt.png"},
	drop = "default:dirt",
	groups = {crumbly=3, not_in_creative_inventory=1, soil=2, grassland = 1, field = 1},
	sounds = default.node_sound_dirt_defaults(),
	drawtype = "nodebox",
	paramtype = "light",
	node_box = {
		type = "fixed",
		fixed = {
			{-0.5, -0.5, -0.5, 0.5, 0.4, 0.5},
		},
	},
	soil = {
		base = "default:dirt",
		dry = "farming:soil",
		wet = "farming:soil_wet"
	}
})

minetest.register_node("farming:soil_wet", {
	description = "Wet Soil",
	tiles = {"default_dirt.png^farming_soil_wet.png", "default_dirt.png^farming_soil_wet_side.png"},
	drop = "default:dirt",
	groups = {crumbly=3, not_in_creative_inventory=1, soil=3, wet = 1, grassland = 1, field = 1},
	sounds = default.node_sound_dirt_defaults(),
	drawtype = "nodebox",
	paramtype = "light",
	node_box = {
		type = "fixed",
		fixed = {
			{-0.5, -0.5, -0.5, 0.5, 0.4, 0.5},
		},
	},
	soil = {
		base = "default:dirt",
		dry = "farming:soil",
		wet = "farming:soil_wet"
	}
})

minetest.override_item("default:desert_sand", {
	groups = {crumbly=3, falling_node=1, sand=1, soil = 1},
	soil = {
		base = "default:desert_sand",
		dry = "farming:desert_sand_soil",
		wet = "farming:desert_sand_soil_wet"
	}
})
minetest.register_node("farming:desert_sand_soil", {
	description = "Desert Sand Soil",
	drop = "default:desert_sand",
	tiles = {"farming_desert_sand_soil.png", "default_desert_sand.png"},
	groups = {crumbly=3, not_in_creative_inventory = 1, falling_node=1, sand=1, soil = 2, desert = 1, field = 1},
	sounds = default.node_sound_sand_defaults(),
	drawtype = "nodebox",
	paramtype = "light",
	node_box = {
		type = "fixed",
		fixed = {
			{-0.5, -0.5, -0.5, 0.5, 0.4, 0.5},
		},
	},
	soil = {
		base = "default:desert_sand",
		dry = "farming:desert_sand_soil",
		wet = "farming:desert_sand_soil_wet"
	}
})

minetest.register_node("farming:desert_sand_soil_wet", {
	description = "Wet Desert Sand Soil",
	drop = "default:desert_sand",
	tiles = {"farming_desert_sand_soil_wet.png", "farming_desert_sand_soil_wet_side.png"},
	groups = {crumbly=3, falling_node=1, sand=1, not_in_creative_inventory=1, soil=3, wet = 1, desert = 1, field = 1},
	sounds = default.node_sound_sand_defaults(),
	drawtype = "nodebox",
	paramtype = "light",
	node_box = {
		type = "fixed",
		fixed = {
			{-0.5, -0.5, -0.5, 0.5, 0.4, 0.5},
		},
	},
	soil = {
		base = "default:desert_sand",
		dry = "farming:desert_sand_soil",
		wet = "farming:desert_sand_soil_wet"
	}
})

minetest.register_node("farming:straw", {
	description = "Straw",
	tiles = {"farming_straw.png"},
	is_ground_content = false,
	groups = {snappy=3, flammable=4, fall_damage_add_percent=-30},
	sounds = default.node_sound_leaves_defaults(),
})

minetest.register_abm({
	label = "Farming soil",
	nodenames = {"group:field"},
	interval = 15,
	chance = 4,
	action = function(pos, node)
		local n_def = minetest.registered_nodes[node.name] or nil
		local wet = n_def.soil.wet or nil
		local base = n_def.soil.base or nil
		local dry = n_def.soil.dry or nil
		if not n_def or not n_def.soil or not wet or not base or not dry then
			return
		end

		pos.y = pos.y + 1
		local nn = minetest.get_node_or_nil(pos)
		if not nn or not nn.name then
			return
		end
		local nn_def = minetest.registered_nodes[nn.name] or nil
		pos.y = pos.y - 1
		
		if nn_def and nn_def.walkable and minetest.get_item_group(nn.name, "plant") == 0 then
			minetest.set_node(pos, {name = base})
			return
		end
		-- check if there is water nearby
		local wet_lvl = minetest.get_item_group(node.name, "wet")
		if minetest.find_node_near(pos, 3, {"group:water"}) then
			-- if it is dry soil and not base node, turn it into wet soil
			if wet_lvl == 0 then
				minetest.set_node(pos, {name = wet})
			end
		else
			-- only turn back if there are no unloaded blocks (and therefore
			-- possible water sources) nearby
			if not minetest.find_node_near(pos, 3, {"ignore"}) then
				-- turn it back into base if it is already dry
				if wet_lvl == 0 then
					-- only turn it back if there is no plant/seed on top of it
					if minetest.get_item_group(nn.name, "plant") == 0 and minetest.get_item_group(nn.name, "seed") == 0 then
						minetest.set_node(pos, {name = base})
					end
					
				-- if its wet turn it back into dry soil
				elseif wet_lvl == 1 then
					minetest.set_node(pos, {name = dry})
				end
			end
		end
	end,
})


for i = 1, 5 do		
	minetest.override_item("default:dry_grass_"..i, {drop = {
		max_items = 1,
		items = {
			{items = {'farming:seed_cotton'},rarity = i * 6},
		}
	}})
end
for i = 1, 5 do		
	minetest.override_item("default:grass_"..i, {drop = {
		max_items = 1,
		items = {
			{items = {'farming:seed_wheat'},rarity = i * 3},
		}
	}})
end
	
minetest.override_item("default:junglegrass", {drop = {
	max_items = 1,
	items = {
		{items = {'farming:seed_cotton'},rarity = 8},
	}
}})

--pumpkins
minetest.register_node("farming:pumpkin", {
	description = ("Pumpkin"),
	paramtype2 = "facedir",
	tiles = {"farming_pumpkin_top.png", "farming_pumpkin_top.png", "farming_pumpkin_side.png", "farming_pumpkin_side.png", "farming_pumpkin_side.png", "farming_pumpkin_side.png"},
	groups = {choppy=2, oddly_breakable_by_hand=2, flammable=2, plant=1},
	sounds = default.node_sound_wood_defaults(),
	on_punch = function(pos, node, puncher)
		local tool = puncher:get_wielded_item():get_name()
		if tool and string.match(tool, "sword") then
			node.name = "farming:jackolantern"
			minetest.set_node(pos, node)
			local item = minetest.add_item(pos, "farming:pumpkin_seed")
			item:setvelocity({x=math.random(-2,2),y=math.random(2,3),z=math.random(-2,2)})
			if math.random(1, 5) == 1 then
				local item = minetest.add_item(pos, "farming:pumpkin_seed")
				item:setvelocity({x=math.random(-2,2),y=math.random(2,3),z=math.random(-2,2)})
			end
		end
	end
})
minetest.register_node("farming:jackolantern", {
	description = ("Jackolantern"),
	paramtype2 = "facedir",
	tiles = {"farming_pumpkin_top.png", "farming_pumpkin_top.png", "farming_pumpkin_side.png", "farming_pumpkin_side.png", "farming_pumpkin_side.png", "farming_pumpkin_face.png"},
	groups = {choppy=2, oddly_breakable_by_hand=2, flammable=2},
	sounds = default.node_sound_wood_defaults(),
	on_punch = function(pos, node, puncher)
		local tool = puncher:get_wielded_item():get_name()
		if tool and string.match(tool, "torch") then
			node.name = "farming:jackolantern_lit"
			minetest.set_node(pos, node)
		end
	end
})
minetest.register_node("farming:jackolantern_lit", {
	description = ("Jackolantern Lit"),
	paramtype2 = "facedir",
	light_source = LIGHT_MAX-2,
	tiles = {"farming_pumpkin_top.png", "farming_pumpkin_top.png", "farming_pumpkin_side.png", "farming_pumpkin_side.png", "farming_pumpkin_side.png", "farming_pumpkin_face_light.png"},
	groups = {choppy=2, oddly_breakable_by_hand=2, flammable=2},
	sounds = default.node_sound_wood_defaults(),
})
--pumpin plant
for i = 1,5 do
	local drop = ""
	minetest.register_node("farming:pumpkin_plant_"..i, {
		description = "farming:pumpkin_plant_"..i,
		tiles = {"pumpkin_plant_"..i..".png","pumpkin_plant_"..i..".png","pumpkin_plant_"..i..".png","pumpkin_plant_"..i..".png","pumpkin_plant_"..i..".png","pumpkin_plant_"..i..".png^[transformFX"},
		drop = drop,
		groups = {snappy = 3, attached_node = 1, plant = 1, dig_immediate = 3},
		sounds = default.node_sound_dirt_defaults(),
		drawtype = "nodebox",
		paramtype = "light",
		paramtype2 = "facedir",
		sunlight_propagates = true,
		walkable = false,
		node_box = {
			type = "fixed",
			fixed = {
				{-0.5, -0.5, 0, 0.5, 0.5, 0},
			},
		},
		selection_box = {
				type = "fixed",
				fixed = {-0.5, -0.5, -0.5, 0.5, -5/16, 0.5},
			},
	})
	
	minetest.register_abm{
		nodenames = {"farming:pumpkin_plant_"..i},
		--neighbors = {"farming:soil","farming:soil_wet"},
		interval = 1,
		chance = 1,
		action = function(pos)
			local node_below = minetest.get_node({x=pos.x,y=pos.y-1,z=pos.z}).name
			if i < 5 then
				if node_below == "farming:soil" or node_below == "farming:soil_wet" then
					minetest.set_node(pos,{name="farming:pumpkin_plant_"..i+1})
				end
			else
				local left  = minetest.get_node({x=pos.x-1,y=pos.y,z=pos.z}).name
				local right = minetest.get_node({x=pos.x+1,y=pos.y,z=pos.z}).name
				local front = minetest.get_node({x=pos.x,y=pos.y,z=pos.z+1}).name
				local back  = minetest.get_node({x=pos.x,y=pos.y,z=pos.z-1}).name
				
				if      left == "air" then
					minetest.set_node(pos,{name="farming:pumpkin_plant_"..i+1,param2 = 0})
					minetest.set_node({x=pos.x-1,y=pos.y,z=pos.z}, {name="farming:pumpkin"})
				elseif right == "air" then
					minetest.set_node(pos,{name="farming:pumpkin_plant_"..i+1,param2 = 2})
					minetest.set_node({x=pos.x+1,y=pos.y,z=pos.z}, {name="farming:pumpkin"})
				elseif front == "air" then
					minetest.set_node(pos,{name="farming:pumpkin_plant_"..i+1,param2 = 1})
					minetest.set_node({x=pos.x,y=pos.y,z=pos.z+1}, {name="farming:pumpkin"})
				elseif  back == "air" then
					minetest.set_node(pos,{name="farming:pumpkin_plant_"..i+1,param2 = 3})
					minetest.set_node({x=pos.x,y=pos.y,z=pos.z-1}, {name="farming:pumpkin"})
				end
			end
		end,
	}
end
--fully grown pumpkin plant
minetest.register_node("farming:pumpkin_plant_6", {
	description = "farming:pumpkin_plant_6",
	tiles = {"pumpkin_plant_6.png","pumpkin_plant_6.png","pumpkin_plant_6.png","pumpkin_plant_6.png","pumpkin_plant_6.png","pumpkin_plant_6.png^[transformFX"},
	drop = "farming:pumpkin_seed",
	groups = {snappy = 3, attached_node = 1, plant = 1, dig_immediate = 3},
	sounds = default.node_sound_dirt_defaults(),
	drawtype = "nodebox",
	paramtype = "light",
	paramtype2 = "facedir",
	sunlight_propagates = true,
	walkable = false,
	node_box = {
		type = "fixed",
		fixed = {
			{-0.5, -0.5, 0, 0.5, 0.5, 0},
		},
	},
	selection_box = {
			type = "fixed",
			fixed = {-0.5, -0.5, -0.5, 0.5, -5/16, 0.5},
		},
})

minetest.register_craftitem("farming:pumpkin_seed", {
	description = "Pumpkin Seed",
	inventory_image = "farming_pumpkin_seed.png",
	on_place = function(itemstack, placer, pointed_thing)
		local pointed_node = minetest.get_node(pointed_thing.under).name
		local above_node = minetest.get_node(pointed_thing.above).name
		if pointed_thing.under.x == pointed_thing.above.x and pointed_thing.under.z == pointed_thing.above.z then
			if pointed_node == "farming:soil" or pointed_node == "farming:soil_wet" then
				if above_node == "air" then
					minetest.set_node(pointed_thing.above, {name="farming:pumpkin_plant_1"})
					itemstack:take_item()
					return(itemstack)
				end
			end
		end
	end,
})

minetest.register_craft({
	type = "shapeless",
	output = "farming:pumpkin_seed 3",
	recipe = {"farming:pumpkin"},
})

minetest.register_craft({
	type = "shapeless",
	output = "farming:pumpkin_seed 1",
	recipe = {"farming:jackolantern"},
})
minetest.register_craft({
	type = "shapeless",
	output = "farming:jackolantern",
	recipe = {"farming:jackolantern_lit"},
})

--make pumpkins spawn
minetest.register_decoration({
	deco_type = "simple",
	place_on = "default:dirt_with_grass",
	sidelen = 16,
	fill_ratio = 0.001,
	--biomes = {"grassland"},
	decoration = "farming:pumpkin",
	height = 1,
})

--pumpkin pie
minetest.register_craft({
	output = "farming:pumpkin_pie",
	recipe = {
		{"farming:flour","farming:flour", "farming:flour"},
		{"farming:sugar", "farming:pumpkin", "farming:sugar"},
		{"farming:flour", "farming:flour", "farming:flour"}
	}
})
minetest.register_craftitem("farming:pumpkin_pie", {
	description = "Pumpkin Pie",
	inventory_image = "pumpkin_pie.png",
	on_use = minetest.item_eat(8),
})

--cake
local cake_count = 0
for i = 1,8 do
	--correct plural description
	local description = ""
	if i > 1 then
		description = "Cake ("..i.." Slices)"
	else
		description = "Cake (1 Slice)"
	end
	minetest.register_node("farming:cake_"..i, {
		description = description,
		tiles = {"cake_top.png","cake_bottom.png","cake_side.png","cake_side.png","cake_side.png","cake_side.png"},
		drop = "farming:cake_slice "..i,
		sounds = default.node_sound_defaults(),
		groups = { dig_immediate = 2, cake = 1, attached_node = 1},
		sounds = default.node_sound_dirt_defaults(),
		drawtype = "nodebox",
		paramtype = "light",
		paramtype2 = "facedir",
		sunlight_propagates = false,
		node_box = {
			type = "fixed",
			fixed = {
				{-0.5, -0.5, -0.5+((8-i)/8), 0.5, 0, 0.5},
			},
		},
		on_rightclick = function(pos, node, player, itemstack, pointed_thing)
			if i > 1 then
				local param2 = minetest.get_node(pos).param2
				minetest.set_node(pos, {name="farming:cake_"..i-1,param2=param2})
			else
				minetest.remove_node(pos)
			end
			player:set_hp(player:get_hp()+4)
			local pos2 = player:getpos()
			minetest.sound_play("bite_item_drop", {
				pos = pos2,
				max_hear_distance = 20,
				gain = 1.0,
			})
			minetest.add_particlespawner({
				 amount = 20,
				 time = 0.1,
				 minpos = {x=pos2.x, y=pos2.y+1.5, z=pos2.z},
				 maxpos = {x=pos2.x, y=pos2.y+1.5, z=pos2.z},
				 minvel = {x=-1, y=1, z=-1},
				 maxvel = {x=1, y=2, z=1},
				 minacc = {x=0, y=-5, z=0},
				 maxacc = {x=0, y=-9, z=0},
				 minexptime = 1,
				 maxexptime = 1,
				 minsize = 1,
				 maxsize = 2,
				 collisiondetection = true,
				 vertical = false,
				 texture = "heart.png",
			})
		end
	})
	--make craftable from cake slices
	minetest.register_craftitem("farming:cake_slice", {
		description = "Slice of Cake",
		inventory_image = "cake_slice.png",
		on_use = minetest.item_eat(4),
	})
	local recipe = {}
	for h = 1,i do
		table.insert(recipe, "farming:cake_slice")
	end
	minetest.register_craft({
		type = "shapeless",
		output = "farming:cake_"..i,
		recipe = recipe,
	})
	--make slices craftable from cake
	minetest.register_craft({
		type = "shapeless",
		output = "farming:cake_slice "..i,
		recipe = {
			"farming:cake_"..i,
		},
	})	
	cake_count = cake_count + 1
end
--craft cake
minetest.register_craft({
	output = "farming:cake_8",
	recipe = {
		{"farming:flour", "farming:flour", "farming:flour"},
		{"farming:sugar", "bucket:bucket_water", "farming:sugar"},
		{"farming:flour", "farming:flour", "farming:flour"}
	},
	replacements = {
		{"bucket:bucket_water", "bucket:bucket_empty"}
	}
})

--cactus hurts
minetest.register_abm{
	nodenames = "default:cactus",
	interval = 0.25,
	chance = 1,
	action = function(pos)
		local ents = minetest.env:get_objects_inside_radius(pos, 2.5)
		for k, ent in pairs(ents) do
			local pos2 = ent:getpos()
			--if player touches cactus then hurt
			if ent:is_player() then
				local diff = {x=pos.x-pos2.x,y=pos.y-pos2.y,z=pos.z-pos2.z}
				if diff.y >= -0.5 and diff.y <= 2 then
					if math.abs(diff.x) < 0.85 and math.abs(diff.z) < 0.85 then
						ent:set_hp(ent:get_hp()-1)
					end
				end
			end
			--if it's an item then delete
			if not ent:is_player() and ent:get_luaentity().itemstring then
				local diff = {x=pos.x-pos2.x,y=pos.y-pos2.y,z=pos.z-pos2.z}
				if math.abs(diff.y) <= 0.75 then
					if math.abs(diff.x) < 0.85 and math.abs(diff.z) < 0.85 then
						ent:remove()
					end
				end
			end
			--do something for mobs
		end
	end,
}

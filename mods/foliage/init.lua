minetest.register_decoration({
	deco_type = "simple",
	place_on = "default:dirt_with_grass",
	sidelen = 16,
	fill_ratio = 0.1,
	--biomes = {"grassland"},
	decoration = "foliage:bnooper",
	height = 1,
})
minetest.register_decoration({
	deco_type = "simple",
	place_on = "default:dirt_with_grass",
	sidelen = 16,
	fill_ratio = 0.1,
	--biomes = {"grassland"},
	decoration = "foliage:groff",
	height = 1,
})

local woolfdur = {}
for y = 1,4 do
	for x = 1,1 do
		for z = 1,1 do
			if y < 4  and y > 1 then
				table.insert(woolfdur, {name = "foliage:woolfdur", param1=255, param2=0})
			elseif y > 1 then
				table.insert(woolfdur, {name = "default:junglegrass", param1=255, param2=0})
			else 
				table.insert(woolfdur, {name = "default:dirt_with_grass"})
			end
		end
	end
end
 
--[[ This will scatter the cuboid schematic all over the biome “cheese” which has been specified somewhere else in the code ]]
minetest.register_decoration({
	deco_type = "schematic",
	place_on = "default:dirt_with_grass",
	sidelen = 16,
	fill_ratio = 0.05,
	--biomes = {"cheese"},
	schematic = {
		size = {x=1, y=4, z=1},
		data = woolfdur,
	},
	-- Note that place_center_y is set to false. This is because we want the cuboids to appear as if they lie "on" the surface..
	flags = {place_center_x = true, place_center_y = false, place_center_z = true,force_placement=true},
})



minetest.register_node("foliage:woolfdur", {
	description = "Woolfdur Trunk",
	drawtype = "nodebox",
	tiles = {"woolfdur_trunk.png"},
	paramtype = "light",
	sunlight_propagates = true,
	groups = {snappy = 3, flora = 1, dig_immediate = 3, attached_node = 1},
	sounds = default.node_sound_leaves_defaults(),
	selection_box = {
		type = "fixed",
		fixed = {-0.15, -0.5, -0.15, 0.15, 0.5, 0.15},
	},
	node_box = {
		type = "fixed",
		fixed = {
				{-0.1, -0.5, -0.1, 0.1, 0.5, 0.1},
			},
		},
})
minetest.register_craft( {
	type = "shapeless",
	output = "default:stick 4",
	recipe = {"foliage:woolfdur"},
})
minetest.register_node("foliage:bnooper", {
	description = "Wild Bnooper",
	drawtype = "plantlike",
	waving = 1,
	tiles = {"bnooper.png"},
	inventory_image = "bnooper.png",
	wield_image = "bnooper.png",
	paramtype = "light",
	sunlight_propagates = true,
	walkable = false,
	buildable_to = true,
	groups = {snappy = 3, flora = 1, attached_node = 1, grass = 1, dig_immediate = 3},
	sounds = default.node_sound_leaves_defaults(),
	drop = "",
	selection_box = {
		type = "fixed",
		fixed = {-0.4, -0.5, -0.4, 0.4, 0.4, 0.4},
	},
})
minetest.register_node("foliage:groff", {
	description = "Wild Groff",
	drawtype = "plantlike",
	waving = 1,
	tiles = {"groff.png"},
	inventory_image = "groff.png",
	wield_image = "groff.png",
	paramtype = "light",
	sunlight_propagates = true,
	walkable = false,
	buildable_to = true,
	groups = {snappy = 3, flora = 1, attached_node = 1, grass = 1, dig_immediate = 3},
	sounds = default.node_sound_leaves_defaults(),
	drop = "",
	selection_box = {
		type = "fixed",
		fixed = {-0.15, -0.5, -0.15, 0.15, 0.5, 0.15},
	},
})
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

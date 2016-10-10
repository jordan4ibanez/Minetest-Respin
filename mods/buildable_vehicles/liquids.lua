--liquids
--oil
minetest.register_node("buildable_vehicles:oil_source", {
	description = "Oil Source",
	drawtype = "liquid",
	tiles = {
		{
			name = "default_water_source_animated.png^[colorize:#000000:245",
			animation = {
				type = "vertical_frames",
				aspect_w = 16,
				aspect_h = 16,
				length = 2.0,
			},
		},
	},
	special_tiles = {
		-- New-style water source material (mostly unused)
		{
			name = "default_water_source_animated.png^[colorize:#000000:245",
			animation = {
				type = "vertical_frames",
				aspect_w = 16,
				aspect_h = 16,
				length = 2.0,
			},
			backface_culling = false,
		},
	},
	alpha = 255,
	paramtype = "light",
	walkable = false,
	pointable = false,
	diggable = false,
	buildable_to = true,
	is_ground_content = false,
	liquid_renewable = false,
	drop = "",
	drowning = 1,
	liquidtype = "source",
	liquid_alternative_flowing = "buildable_vehicles:oil_flowing",
	liquid_alternative_source = "buildable_vehicles:oil_source",
	liquid_viscosity = 7,
	post_effect_color = {a = 255, r = 0, g = 0, b = 0},
	groups = {oil =  1, liquid = 3, flammable = 1},
})

minetest.register_node("buildable_vehicles:oil_flowing", {
	description = "Flowing Oil",
	drawtype = "flowingliquid",
	tiles = {"default_water.png^[colorize:#000000:200"},
	special_tiles = {
		{
			name = "default_water_flowing_animated.png^[colorize:#000000:245",
			backface_culling = false,
			animation = {
				type = "vertical_frames",
				aspect_w = 16,
				aspect_h = 16,
				length = 0.8,
			},
		},
		{
			name = "default_water_flowing_animated.png^[colorize:#000000:245",
			backface_culling = true,
			animation = {
				type = "vertical_frames",
				aspect_w = 16,
				aspect_h = 16,
				length = 0.8,
			},
		},
	},
	alpha = 255,
	paramtype = "light",
	paramtype2 = "flowingliquid",
	walkable = false,
	pointable = false,
	diggable = false,
	buildable_to = true,
	is_ground_content = false,
	drop = "",
	drowning = 1,
	liquidtype = "flowing",
	liquid_alternative_flowing = "buildable_vehicles:oil_flowing",
	liquid_alternative_source = "buildable_vehicles:oil_source",
	liquid_viscosity = 7,
	post_effect_color = {a = 255, r = 0, g = 0, b = 0},
	groups = {oil = 1, liquid = 3, flammable = 1,not_in_creative_inventory = 1},
})

--gasoline
minetest.register_node("buildable_vehicles:gasoline_source", {
	description = "Gasoline Source",
	drawtype = "liquid",
	tiles = {
		{
			name = "default_water_source_animated.png^[colorize:#ffff99:200",
			animation = {
				type = "vertical_frames",
				aspect_w = 16,
				aspect_h = 16,
				length = 2.0,
			},
		},
	},
	special_tiles = {
		-- New-style water source material (mostly unused)
		{
			name = "default_water_source_animated.png^[colorize:#ffff99:200",
			animation = {
				type = "vertical_frames",
				aspect_w = 16,
				aspect_h = 16,
				length = 2.0,
			},
			backface_culling = false,
		},
	},
	alpha = 150,
	paramtype = "light",
	walkable = false,
	pointable = false,
	diggable = false,
	buildable_to = true,
	is_ground_content = false,
	liquid_renewable = false,
	drop = "",
	drowning = 1,
	liquidtype = "source",
	damage_per_second = 1,
	liquid_alternative_flowing = "buildable_vehicles:gasoline_flowing",
	liquid_alternative_source = "buildable_vehicles:gasoline_source",
	liquid_viscosity = 1,
	post_effect_color = {a = 150, r = 100, g = 100, b = 60},
	groups = {oil =  1, liquid = 3, flammable = 1},
})

minetest.register_node("buildable_vehicles:gasoline_flowing", {
	description = "Flowing Gasoline",
	drawtype = "flowingliquid",
	tiles = {"default_water.png^[colorize:#ffff99:200"},
	special_tiles = {
		{
			name = "default_water_flowing_animated.png^[colorize:#ffff99:200",
			backface_culling = false,
			animation = {
				type = "vertical_frames",
				aspect_w = 16,
				aspect_h = 16,
				length = 0.8,
			},
		},
		{
			name = "default_water_flowing_animated.png^[colorize:#ffff99:200",
			backface_culling = true,
			animation = {
				type = "vertical_frames",
				aspect_w = 16,
				aspect_h = 16,
				length = 0.8,
			},
		},
	},
	alpha = 150,
	paramtype = "light",
	paramtype2 = "flowingliquid",
	walkable = false,
	pointable = false,
	diggable = false,
	buildable_to = true,
	is_ground_content = false,
	drop = "",
	drowning = 1,
	liquidtype = "flowing",
	damage_per_second = 1,
	liquid_alternative_flowing = "buildable_vehicles:gasoline_flowing",
	liquid_alternative_source = "buildable_vehicles:gasoline_source",
	liquid_viscosity = 1,
	post_effect_color = {a = 150, r = 100, g = 100, b = 60},
	groups = {oil = 1, liquid = 3, flammable = 1,not_in_creative_inventory = 1},
})

--diesel
minetest.register_node("buildable_vehicles:diesel_source", {
	description = "Diesel Source",
	drawtype = "liquid",
	tiles = {
		{
			name = "default_water_source_animated.png^[colorize:#ffbf00:200",
			animation = {
				type = "vertical_frames",
				aspect_w = 16,
				aspect_h = 16,
				length = 2.0,
			},
		},
	},
	special_tiles = {
		-- New-style water source material (mostly unused)
		{
			name = "default_water_source_animated.png^[colorize:#ffbf00:200",
			animation = {
				type = "vertical_frames",
				aspect_w = 16,
				aspect_h = 16,
				length = 2.0,
			},
			backface_culling = false,
		},
	},
	alpha = 200,
	paramtype = "light",
	walkable = false,
	pointable = false,
	diggable = false,
	buildable_to = true,
	is_ground_content = false,
	liquid_renewable = false,
	drop = "",
	drowning = 1,
	liquidtype = "source",
	damage_per_second = 1,
	liquid_alternative_flowing = "buildable_vehicles:diesel_flowing",
	liquid_alternative_source = "buildable_vehicles:diesel_source",
	liquid_viscosity = 1,
	post_effect_color = {a = 200, r = 100, g = 75, b = 0},
	groups = { liquid = 3},
})

minetest.register_node("buildable_vehicles:diesel_flowing", {
	description = "Flowing Coolant",
	drawtype = "flowingliquid",
	tiles = {"default_water.png^[colorize:#ffbf00:200"},
	special_tiles = {
		{
			name = "default_water_flowing_animated.png^[colorize:#ffbf00:200",
			backface_culling = false,
			animation = {
				type = "vertical_frames",
				aspect_w = 16,
				aspect_h = 16,
				length = 0.8,
			},
		},
		{
			name = "default_water_flowing_animated.png^[colorize:#ffbf00:200",
			backface_culling = true,
			animation = {
				type = "vertical_frames",
				aspect_w = 16,
				aspect_h = 16,
				length = 0.8,
			},
		},
	},
	alpha = 200,
	paramtype = "light",
	paramtype2 = "flowingliquid",
	walkable = false,
	pointable = false,
	diggable = false,
	buildable_to = true,
	is_ground_content = false,
	drop = "",
	drowning = 1,
	liquidtype = "flowing",
	damage_per_second = 1,
	liquid_alternative_flowing = "buildable_vehicles:diesel_flowing",
	liquid_alternative_source = "buildable_vehicles:diesel_source",
	liquid_viscosity = 1,
	post_effect_color = {a = 200, r = 100, g = 75, b = 0},
	groups = {liquid = 3, not_in_creative_inventory = 1, },
})

--coolant
minetest.register_node("buildable_vehicles:coolant_source", {
	description = "Coolant Source",
	drawtype = "liquid",
	tiles = {
		{
			name = "default_water_source_animated.png^[colorize:#7fff00:200",
			animation = {
				type = "vertical_frames",
				aspect_w = 16,
				aspect_h = 16,
				length = 2.0,
			},
		},
	},
	special_tiles = {
		-- New-style water source material (mostly unused)
		{
			name = "default_water_source_animated.png^[colorize:#7fff00:200",
			animation = {
				type = "vertical_frames",
				aspect_w = 16,
				aspect_h = 16,
				length = 2.0,
			},
			backface_culling = false,
		},
	},
	alpha = 200,
	paramtype = "light",
	walkable = false,
	pointable = false,
	diggable = false,
	buildable_to = true,
	is_ground_content = false,
	liquid_renewable = false,
	drop = "",
	drowning = 1,
	liquidtype = "source",
	damage_per_second = 1,
	liquid_alternative_flowing = "buildable_vehicles:coolant_flowing",
	liquid_alternative_source = "buildable_vehicles:coolant_source",
	liquid_viscosity = 1,
	post_effect_color = {a = 200, r = 50, g = 100, b = 0},
	groups = {water =  3, liquid = 3, flammable = 1, puts_out_fire = 1},
})

minetest.register_node("buildable_vehicles:coolant_flowing", {
	description = "Flowing Coolant",
	drawtype = "flowingliquid",
	tiles = {"default_water.png^[colorize:#7fff00:200"},
	special_tiles = {
		{
			name = "default_water_flowing_animated.png^[colorize:#7fff00:200",
			backface_culling = false,
			animation = {
				type = "vertical_frames",
				aspect_w = 16,
				aspect_h = 16,
				length = 0.8,
			},
		},
		{
			name = "default_water_flowing_animated.png^[colorize:#7fff00:200",
			backface_culling = true,
			animation = {
				type = "vertical_frames",
				aspect_w = 16,
				aspect_h = 16,
				length = 0.8,
			},
		},
	},
	alpha = 200,
	paramtype = "light",
	paramtype2 = "flowingliquid",
	walkable = false,
	pointable = false,
	diggable = false,
	buildable_to = true,
	is_ground_content = false,
	drop = "",
	drowning = 1,
	liquidtype = "flowing",
	damage_per_second = 1,
	liquid_alternative_flowing = "buildable_vehicles:coolant_flowing",
	liquid_alternative_source = "buildable_vehicles:coolant_source",
	liquid_viscosity = 1,
	post_effect_color = {a = 200, r = 50, g = 100, b = 0},
	groups = {water = 3, liquid = 3, flammable = 1,not_in_creative_inventory = 1, puts_out_fire = 1},
})

--make diesel an abm that freezes
minetest.register_node("buildable_vehicles:diesel_frozen", {
	description = "Frozen Diesel",
	tiles = {"default_ice.png^[colorize:#ffbf00:200"},
	is_ground_content = false,
	paramtype = "light",
	groups = {cracky = 3},
	sounds = default.node_sound_glass_defaults(),
	on_dig = function(pos, node, player)
		minetest.set_node(pos, {name="buildable_vehicles:diesel_source"})
	end,
})
minetest.register_abm({
	label = "Grass covered",
	nodenames = {"buildable_vehicles:diesel_source"},
	interval = 3,
	chance = 5,
	neighbors = {"default:ice","default:dirt_with_snow","default:snow"},
	action = function(pos, node)
		minetest.set_node(pos, {name="buildable_vehicles:diesel_frozen"})
	end
})
--buckets
bucket.register_liquid(
	"buildable_vehicles:oil_source",
	"buildable_vehicles:oil_flowing",
	"buildable_vehicles:bucket_oil",
	"bucket_oil.png",
	"Bucket of Oil",
	{oil_bucket = 1}
)
bucket.register_liquid(
	"buildable_vehicles:gasoline_source",
	"buildable_vehicles:gasoline_flowing",
	"buildable_vehicles:bucket_gasoline",
	"bucket_gasoline.png",
	"Bucket of Gasoline",
	{gasoline_bucket = 1}
)
bucket.register_liquid(
	"buildable_vehicles:diesel_source",
	"buildable_vehicles:diesel_flowing",
	"buildable_vehicles:bucket_diesel",
	"bucket_diesel.png",
	"Bucket of Diesel",
	{diesel_bucket = 1}
)
bucket.register_liquid(
	"buildable_vehicles:coolant_source",
	"buildable_vehicles:coolant_flowing",
	"buildable_vehicles:bucket_coolant",
	"bucket_coolant.png",
	"Bucket of Coolant",
	{coolant_bucket = 1}
)
--craft coolant
minetest.register_craft({
	type = "shapeless",
	output = "buildable_vehicles:bucket_coolant",
	recipe = {"bucket:bucket_water", "farming:sugar", "dye:green"},
})
--cook gasoline
minetest.register_craft({
	type = "cooking",
	cooktime = 60,
	output = "buildable_vehicles:bucket_gasoline",
	recipe = "buildable_vehicles:bucket_oil"
})
--craft diesel - this is a craft for now
--dye oil orange
minetest.register_craft({
	type = "shapeless",
	output = "buildable_vehicles:bucket_diesel",
	recipe = {"buildable_vehicles:bucket_oil", "dye:orange"},
})

--spawn oil in the ground
minetest.register_ore({
    ore_type       = "blob",
    ore            = "buildable_vehicles:oil_source",
    wherein        = "default:stone",
    clust_scarcity = 20*20*20,
    clust_num_ores = 64,
    clust_size     = 8,
    height_min     = -31000,
    height_max     = 0,
})

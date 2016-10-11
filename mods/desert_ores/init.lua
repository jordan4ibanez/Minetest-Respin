--desert ores
minetest.register_node("desert_ores:stone_with_coal", {
	description = "Desert Coal Ore",
	tiles = {"default_desert_stone.png^default_mineral_coal.png"},
	groups = {cracky = 3},
	drop = 'default:coal_lump',
	sounds = default.node_sound_stone_defaults(),
})

minetest.register_node("desert_ores:stone_with_iron", {
	description = "Desert Iron Ore",
	tiles = {"default_desert_stone.png^default_mineral_iron.png"},
	groups = {cracky = 2},
	drop = 'default:iron_lump',
	sounds = default.node_sound_stone_defaults(),
})


minetest.register_node("desert_ores:stone_with_copper", {
	description = "Desert Copper Ore",
	tiles = {"default_desert_stone.png^default_mineral_copper.png"},
	groups = {cracky = 2},
	drop = 'default:copper_lump',
	sounds = default.node_sound_stone_defaults(),
})

minetest.register_node("desert_ores:stone_with_gold", {
	description = "Desert Gold Ore",
	tiles = {"default_desert_stone.png^default_mineral_gold.png"},
	groups = {cracky = 2},
	drop = "default:gold_lump",
	sounds = default.node_sound_stone_defaults(),
})

--generation
minetest.register_ore({
		ore_type       = "scatter",
		ore            = "desert_ores:stone_with_coal",
		wherein        = "default:desert_stone",
		clust_scarcity = 8 * 8 * 8,
		clust_num_ores = 9,
		clust_size     = 3,
		--y_min          = 1025,
		--y_max          = 31000,
	})
minetest.register_ore({
		ore_type       = "scatter",
		ore            = "desert_ores:stone_with_iron",
		wherein        = "default:desert_stone",
		clust_scarcity = 9 * 9 * 9,
		clust_num_ores = 12,
		clust_size     = 3,
		--y_min          = 1025,
		--y_max          = 31000,
	})
	
	minetest.register_ore({
		ore_type       = "scatter",
		ore            = "desert_ores:stone_with_copper",
		wherein        = "default:desert_stone",
		clust_scarcity = 9 * 9 * 9,
		clust_num_ores = 5,
		clust_size     = 3,
		--y_min          = 1025,
		--y_max          = 31000,
	})
minetest.register_ore({
		ore_type       = "scatter",
		ore            = "desert_ores:stone_with_gold",
		wherein        = "default:desert_stone",
		clust_scarcity = 13 * 13 * 13,
		clust_num_ores = 5,
		clust_size     = 3,
		y_min          = 1025,
		y_max          = 31000,
	})

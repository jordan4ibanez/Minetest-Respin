minetest.register_node("buildable_vehicles:car_control_node", {
	description = "Control Node",
	tiles = {"wool_red.png"},
	groups = {cracky=3, stone=1},
	paramtype2 = "facedir",
	on_rightclick = function(pos, node, player, itemstack, pointed_thing)
		--minetest.remove_node(pos)
		local vessel = create_vessel(pos,node.param2)
		player:set_attach(vessel, "", {x=0,y=0,z=0}, {x=0,y=0,z=0})
		vessel:get_luaentity().controller = player:get_player_name()
	end,
	drawtype = "nodebox",
	paramtype = "light",
	node_box = {
		type = "fixed",
		fixed = {
			{-0.5, -0.5, -0.5, 0.5, 0, 0.5},
			{-0.5, 0, -0.5, 0.5, 0.5, 0},
		},
	}
})
minetest.register_node("buildable_vehicles:wheel", {
	description = "Wheel",
	tiles = {"wheel_top.png","wheel_top","wheel_top.png","wheel_top.png","wheel_side.png","wheel_side.png",},
	groups = {cracky=3, stone=1},
	paramtype2 = "facedir",
})
minetest.register_node("buildable_vehicles:carpart", {
	description = "Carpart",
	tiles = {"default_steel_block.png^[colorize:#000000:170"},
	is_ground_content = false,
	groups = {cracky = 1, level = 2},
	sounds = default.node_sound_stone_defaults(),
})
minetest.register_node("buildable_vehicles:window", {
	description = "Wheel",
	tiles = {"default_glass.png"},
	groups = {cracky=3, stone=1},
	paramtype2 = "facedir",
	drawtype = "nodebox",
	paramtype = "light",
	node_box = {
		type = "fixed",
		fixed = {
			{-0.5, -0.5, -0.5, 0.5, 0.5, -0.4},
		},
	}
})

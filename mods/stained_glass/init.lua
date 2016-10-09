local colors = {
{"white",     "#FFFFFF", "White"},
{"grey",      "#808080", "Grey"},
{"dark_grey", "#404040", "Dark Grey"},
{"black",     "#000000", "Black"},
{"cyan",      "#00FFFF", "Cyan"},
{"green",     "#008000", "Green"},
{"dark_green","#004000", "Dark Green"},
{"yellow",    "#FFFF00", "Yellow"},
{"orange",    "#FFA500", "Orange"},
{"brown",     "#614126", "Brown"},
{"pink",      "#FFC0CB", "Pink"},
{"magenta",   "#FF00FF", "Magenta"},
{"violet",    "#EE82EE", "Violet"},
{"blue",      "#0000ff", "Blue"},
{"red",       "#FF0000", "Red"}
}

--stained glass
for number,colortable in pairs(colors) do
	local def = minetest.registered_items["default:glass"]
	minetest.register_node("stained_glass:glass_"..colors[number][1], {
		description = colors[number][3].." "..def.description,
		drawtype = "glasslike_framed_optional",
		tiles = {def.tiles[1].."^[colorize:"..colortable[2]..":170",def.tiles[2].."^[colorize:"..colortable[2]..":170"},
		paramtype = "light",
		sunlight_propagates = true,
		is_ground_content = false,
		groups = {cracky = 3, oddly_breakable_by_hand = 3},
		sounds = default.node_sound_glass_defaults(),
	})
	--stain glass
	minetest.register_craft( {
		type = "shapeless",
		output = "stained_glass:glass_"..colors[number][1],
		recipe = {"default:glass",  "dye:"..colortable[1]},
	})
	--return glass to normal
	minetest.register_craft( {
		type = "shapeless",
		output = "default:glass",
		recipe = {"stained_glass:glass_"..colors[number][1]},
	})
end

--stained glasspane - use xpanes api
for number,colortable in pairs(colors) do

	xpanes.register_pane("pane_"..colors[number][1], {
		description = colors[number][3].." Glass Pane",
		textures = {"default_glass.png".."^[colorize:"..colortable[2]..":170","xpanes_pane_half.png".."^[colorize:"..colortable[2]..":170","xpanes_white.png".."^[colorize:"..colortable[2]..":170"},
		inventory_image = "default_glass.png".."^[colorize:"..colortable[2]..":170",
		wield_image = "default_glass.png".."^[colorize:"..colortable[2]..":170",
		sounds = default.node_sound_glass_defaults(),
		groups = {snappy=2, cracky=3, oddly_breakable_by_hand=3},
		recipe = {
			{"default:glass", "default:glass", "default:glass"},
			{"default:glass", "default:glass", "default:glass"}
		}
	})

	--stain glasspane
	minetest.register_craft( {
		type = "shapeless",
		output = "xpanes:pane_"..colors[number][1].."_flat",
		recipe = {"xpanes:pane_flat",  "dye:"..colortable[1]},
	})
	--return glasspane to normal
	minetest.register_craft( {
		type = "shapeless",
		output = "xpanes:pane_flat",
		recipe = {"xpanes:pane_"..colors[number][1].."_flat"},
	})
end

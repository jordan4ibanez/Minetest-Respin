
local colors = {{"white","#FFFFFF"},{"grey","#808080"},{"dark_grey","#404040"},{"black","#000000"},{"cyan","#00FFFF"},{"green","#008000"},{"dark_green","#004000"},
{"yellow","#FFFF00"},{"orange","#FFA500"},{"brown","#614126"},{"pink","#FFC0CB"},{"magenta","#FF00FF"},{"violet","#EE82EE"},{"blue", "#0000ff"},{"red","#FF0000"},}

--stained glass
for number,colortable in pairs(colors) do
	local def = minetest.registered_items["default:glass"]
	minetest.register_node("stained_glass:glass_"..colors[number][1], {
		description = colors[number][1]:gsub("^%l", string.upper).." "..def.description,
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

--Fired Clay
minetest.register_node("clay:fired_clay", {
	description = "Fired Clay",
	tiles = {"default_clay.png^[colorize:#996633:170"},
	groups = {cracky = 3, stone = 1},
	drop = 'default:cobble',
	legacy_mineral = true,
	sounds = default.node_sound_stone_defaults(),
})
minetest.register_craft({
	type = "cooking",
	cooktime = 2,
	output = "clay:fired_clay",
	recipe = "default:clay",
})


--Colored clay
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

for number,colortable in pairs(colors) do

	minetest.register_node("clay:fired_clay_"..colors[number][1], {
		description = colors[number][3].." Fired Clay",
		tiles = {"default_clay.png^[colorize:"..colors[number][2]..":200"},
		groups = {cracky = 3, stone = 1},
		sounds = default.node_sound_stone_defaults(),
	})
	--dye wood
	minetest.register_craft( {
		type = "shapeless",
		output = "clay:fired_clay_"..colors[number][1],
		recipe = {"clay:fired_clay",  "dye:"..colortable[1]},
	})
	--return wood to normal
	minetest.register_craft( {
		type = "shapeless",
		output = "clay:fired_clay",
		recipe = {"clay:fired_clay_"..colors[number][1]},
	})
end

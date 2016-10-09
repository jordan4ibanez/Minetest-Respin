local wood_table = {
"default:wood",
"default:junglewood",
"default:pine_wood",
"default:acacia_wood",
"default:aspen_wood"
}

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

--wood
for key,value in pairs(wood_table) do
	local def = minetest.registered_items[value]
	for number,colortable in pairs(colors) do
		minetest.register_node("colored_wood:"..string.gsub(value, "default:", "").."_"..colors[number][1], {
			description = colors[number][3].." "..def.description,
			paramtype2 = "facedir",
			place_param2 = 0,
			tiles = {def.tiles[1].."^[colorize:"..colortable[2]..":170"},
			is_ground_content = false,
			groups = {choppy = 2, oddly_breakable_by_hand = 2, flammable = 2, wood = 1},
			sounds = default.node_sound_wood_defaults(),
		})
		--dye wood
		minetest.register_craft( {
			type = "shapeless",
			output = "colored_wood:"..string.gsub(value, "default:", "").."_"..colors[number][1],
			recipe = {value,  "dye:"..colortable[1]},
		})
		--return wood to normal
		minetest.register_craft( {
			type = "shapeless",
			output = value,
			recipe = {"colored_wood:"..string.gsub(value, "default:", "").."_"..colors[number][1]},
		})
	end
end

--fences
for key,value in pairs(wood_table) do
	local value = "default:fence_"..string.gsub(value, "default:", "")
	local def = minetest.registered_items[value]
	for number,colortable in pairs(colors) do
		default.register_fence("colored_wood:"..string.gsub(value, "default:", "").."_"..colors[number][1], {
			description = colors[number][3].." "..def.description,
			texture = def.tiles[1].."^[colorize:"..colortable[2]..":170",
			inventory_image = def.inventory_image.."^[colorize:"..colortable[2]..":170",
			wield_image = def.wield_image.."^[colorize:"..colortable[2]..":170",
			material = string.gsub(value, "fence_", ""),
			groups = {choppy = 2, oddly_breakable_by_hand = 2, flammable = 2},
			sounds = default.node_sound_wood_defaults()
		})
		
		--dye fence
		minetest.register_craft( {
			type = "shapeless",
			output = "colored_wood:"..string.gsub(value, "default:", "").."_"..colors[number][1],
			recipe = {value,  "dye:"..colortable[1]},
		})
		--return fence to normal
		minetest.register_craft( {
			type = "shapeless",
			output = value,
			recipe = {"colored_wood:"..string.gsub(value, "default:", "").."_"..colors[number][1]},
		})
	end
end

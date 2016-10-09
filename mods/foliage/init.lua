minetest.register_decoration({
	deco_type = "simple",
	place_on = "default:dirt_with_grass",
	sidelen = 16,
	fill_ratio = 0.1,
	--biomes = {"grassland"},
	decoration = "default:glass",
	height = 1,
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
				if math.abs(diff.y) >= -0.5 and math.abs(diff.y) <= 2 then
					if math.abs(diff.x) > math.abs(diff.z) then
						--check if less than 0.85
						if math.abs(diff.x) < 0.85 then
							ent:set_hp(ent:get_hp()-1)
						end
					elseif math.abs(diff.x) < math.abs(diff.z) then
						if math.abs(diff.z) < 0.85 then
							ent:set_hp(ent:get_hp()-1)
						end
					end
				end
			end
			--if it's an item then delete
			if not ent:is_player() and ent:get_luaentity().itemstring then
				local diff = {x=pos.x-pos2.x,y=pos.y-pos2.y,z=pos.z-pos2.z}
				if math.abs(diff.y) <= 0.75 then
					if math.abs(diff.x) > math.abs(diff.z) then
						--check if less than 0.85
						if math.abs(diff.x) < 0.85 then
							ent:remove()
						end
					elseif math.abs(diff.x) < math.abs(diff.z) then
						if math.abs(diff.z) < 0.85 then
							ent:remove()
						end
					end
				end
			end
			--do something for mobs
		end
	end,
}

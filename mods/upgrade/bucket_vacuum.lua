-- do all buckets at once
local function check_protection(pos, name, text)
	if minetest.is_protected(pos, name) then
		minetest.log("action", (name ~= "" and name or "A mod")
			.. " tried to " .. text
			.. " at protected position "
			.. minetest.pos_to_string(pos)
			.. " with a bucket")
		minetest.record_protection_violation(pos, name)
		return true
	end
	return false
end

minetest.override_item("bucket:bucket_empty", {
	on_use = function(itemstack, user, pointed_thing)
		-- Must be pointing to node
		if pointed_thing.type ~= "node" then
			return
		end
		-- Check if pointing to a liquid source
		local node = minetest.get_node(pointed_thing.under)
		local liquiddef = bucket.liquids[node.name]
		local item_count = user:get_wielded_item():get_count()

		if liquiddef ~= nil
		and liquiddef.itemname ~= nil
		and node.name == liquiddef.source then
			if check_protection(pointed_thing.under,
					user:get_player_name(),
					"take ".. node.name) then
				return
			end

			-- default set to return filled bucket
			local giving_back = liquiddef.itemname

			-- check if holding more than 1 empty bucket
			if item_count > 1 then
				for i = 1,item_count-1 do
					print("Test")
					-- if space in inventory add filled bucked, otherwise drop as item
					local inv = user:get_inventory()
					if inv:room_for_item("main", {name=liquiddef.itemname}) then
						inv:add_item("main", liquiddef.itemname)
					else
						local pos = user:getpos()
						pos.y = math.floor(pos.y + 0.5)
						minetest.add_item(pos, liquiddef.itemname)
					end
					-- set to return empty buckets minus 1
					--giving_back = "bucket:bucket_empty "..tostring(item_count-item_count)
				end
				user:set_wielded_item(liquiddef.itemname)

			end

			minetest.add_node(pointed_thing.under, {name="air"})

			return ItemStack(giving_back)
		end
	end,
})

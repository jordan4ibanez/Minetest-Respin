local disable = true
if disable == true then
	return
end
print("\n\n\n\n\n\n\nFAIL")
minetest.register_craftitem("upgrade:rsamble", {
	description = "",
	inventory_image = ".png",
})


dofile(minetest.get_modpath("upgrade").."/bucket_vacuum.lua")
dofile(minetest.get_modpath("upgrade").."/vein_miner.lua")
dofile(minetest.get_modpath("upgrade").."/borer_function.lua")
--make upgrades wear like tools

--############## completed upgrades
-- fill all buckets in inventory when collecting a single node of water
minetest.register_craftitem("upgrade:bucket_vacuum", {
	description = "",
	inventory_image = ".png",
})
--auto mine veins - make it so borers have this lumped on to the loop
minetest.register_craftitem("upgrade:vein_miner", {
	description = "Vein Miner Upgrade",
	inventory_image = "upgrade_vein_miner.png",
})
--makes a radius of shovel/pick digs
minetest.register_craftitem("upgrade:borer_1", {
	description = "Borer Upgrade 1",
	inventory_image = "borer_1.png",
})
minetest.register_craftitem("upgrade:borer_2", {
	description = "Borer Upgrade 2",
	inventory_image = "borer_2.png",
})
minetest.register_craftitem("upgrade:borer_3", {
	description = "Borer Upgrade 3",
	inventory_image = "borer_3.png",
})

--##############

-- when right clicking with a tool give name, mod, and groups of the node
-- or make this a tool itself
minetest.register_craftitem("upgrade:node_knowledge", {
	description = "Auto Stair Upgrade",
	inventory_image = "auto_stair.png",
})


-- auto places slabs/stairs as you walk
minetest.register_craftitem("upgrade:auto_stair", {
	description = "Auto Stair Upgrade",
	inventory_image = "auto_stair.png",
})

--auto cook items - shovel/pick
minetest.register_craftitem("upgrade:auto_smelt", {
	description = "Autosmelt Upgrade",
	inventory_image = "upgrade_smelt.png",
})

--regenerate health when mining
minetest.register_craftitem("upgrade:hp_boost", {
	description = "",
	inventory_image = ".png",
})

--place a ladder when digging straight down
minetest.register_craftitem("upgrade:auto_ladder", {
	description = "",
	inventory_image = ".png",
})



-- auto replace items in hand with similar type when item breaks
minetest.register_craftitem("upgrade:auto_renew", {
	description = "",
	inventory_image = ".png",
})

-- auto replaces the best tool into hand if mining with inneficient tool
minetest.register_craftitem("upgrade:auto_speed", {
	description = "",
	inventory_image = ".png",
})

-- auto gives tools health back based on their durability on every node dug
minetest.register_craftitem("upgrade:durability", {
	description = "",
	inventory_image = ".png",
})

-- auto places a torch from inventory if light level is below a certain number
minetest.register_craftitem("upgrade:auto_torch", {
	description = "",
	inventory_image = ".png",
})

-- hard coded for simplicity sake

-- use set_name(item_name) in a upgrade forge to use individual items with upgrades?


minetest.register_on_dignode(function(pos, oldnode, digger)
	if digger == nil then
		return
	end
	local item = digger:get_wielded_item():to_string()
	--find if item is pick/axe/shovel
	local inv = digger:get_inventory()
	local autoladder = inv:contains_item("main", "upgrade:auto_ladder")
	local vein_miner = inv:contains_item("main", "upgrade:vein_miner")
	local auto_smelt = inv:contains_item("main", "upgrade:auto_smelt")
	--search for the borer upgrade, which does almost every upgrade in the inventory a bunch of times, else do them once
	if inv:contains_item("main", "upgrade:borer_1") then
		borer_function(pos,digger,1,item,autoladder,vein_miner,auto_smelt)
	elseif inv:contains_item("main", "upgrade:borer_2") then
		borer_function(pos,digger,2,item,autoladder,vein_miner,auto_smelt)
	elseif inv:contains_item("main", "upgrade:borer_3") then
		borer_function(pos,digger,3,item,autoladder,vein_miner,auto_smelt)
	else
		if vein_miner == true then
			upgrade_veinminer_loop(pos)
			print("\n\n\n\nMAKE THIS AUTOSMELT TOO!")
		end
		--find the end result of the item you mine, and smelt it if possible
		--this destroys the original mined object then replaces it with the new item
		if auto_smelt == true then
			auto_smelt_function(oldnode, pos)
		end
	end
	
end)

function auto_smelt_function(oldnode, pos)
	if oldnode == nil then
		return
	end
	local item = minetest.get_node_drops(oldnode.name)[1]
	local result,_  = minetest.get_craft_result({method = "cooking", width = 1, items = {item}}).item
	if result:to_string() ~= "" then
		for _,object in ipairs(minetest.env:get_objects_inside_radius(pos, 0.1)) do
			if not object:is_player() and object:get_luaentity() and object:get_luaentity().name == "__builtin:item" then
				object:remove()
			end
		end
		minetest.after(0,function(pos,result)
			minetest.add_item(pos, result)
		end,pos,result)
	else
		--print("Test")
		local item = minetest.get_node_drops(oldnode)[1]
		local result,_  = minetest.get_craft_result({method = "cooking", width = 1, items = {item}}).item
		if result:to_string() ~= "" then
			for _,object in ipairs(minetest.env:get_objects_inside_radius(pos, 0.1)) do
				if not object:is_player() and object:get_luaentity() and object:get_luaentity().name == "__builtin:item" then
					object:remove()
				end
			end
			minetest.after(0,function(pos,result)
				minetest.add_item(pos, result)
			end,pos,result)
		end
	end
end

print("create a rope thing so you can drag the boat entities around, and attach one entity to another\n\n\n\n")




local settings = {}
settings.attach_scaling = 30
settings.scaling = 0.667

settings.ship_size = 5


function settings.set(list)
  local set = {}
  for _, l in ipairs(list) do set[l] = true end
  return set
end

settings.node_table = settings.set{"default:wood","default:glass","stairs:stair_wood"}

minetest.register_entity("buildable_vehicles:ship_element", {
	initial_properties = {
		physical = false,
		collide_with_objects = true,
		collisionbox = {-0.5,-0.5,-0.5, 0.5,0.5,0.5}, 
		visual = "wielditem",
		textures = {},
		automatic_face_movement_dir = 0.0,
	},

	node = {},

	set_node = function(self, node)
		self.node = node
		local prop = {
			is_visible = true,
			textures = {node.name},
		}
		self.object:set_properties(prop)
	end,

	get_staticdata = function(self)
		return self.node.name
	end,

	on_activate = function(self, staticdata)
		self.object:set_armor_groups({immortal=1})
		if staticdata then
			self:set_node({name=staticdata})
		end
		minetest.after(0,function()
			if self.parent ~= nil and self.relative ~= nil then 
				self.object:set_attach(self.parent, "", {x=self.relative.x,y=self.relative.y,z=self.relative.z}, {x=0,y=self.face_direction,z=0})
				self.object:set_properties({visual_size = {x=settings.scaling*3, y=settings.scaling*3}})
				--self.object:set_properties({})
			else
				--this fixes issues with scaling
				self.object:set_properties({visual_size = {x=settings.scaling, y=settings.scaling}})

			end
		end)
	end,

	-- maybe have cannons, anchors, trolling lines, etc
	on_step = function(self, dtime)
		local velocity = self.object:getvelocity()
		--remove old vessels for now
		if self.controller == nil and self.parent == nil then
			self.object:remove()
		end
		if self.parent ~= nil then
			
		else
			--self.object:setvelocity({x=math.random(-1,1)*math.random(),y=0,z=math.random(-1,1)*math.random()})
			--let player control vessel
			if self.controller then
				local pos = self.object:getpos()
				local node = minetest.get_node(pos).name
				local in_water = minetest.get_item_group(node, "water")
				local control = minetest.get_player_by_name(self.controller):get_player_control()
				local y_goal = 0
				if in_water > 0 then
					y_goal = 10 - velocity.y
				else
					y_goal = -10
				end
				local vel = {x=0,y=0,z=0}
				if minetest.get_player_by_name(self.controller):get_attach() ~= nil then
					if control.jump == true or control.sneak == true or control.up == true then
						vel.y = -10
						if control.up == true then
							local dir = minetest.get_player_by_name(self.controller):get_look_dir()
							vel.x = dir.x * 8
							vel.z = dir.z * 8
						else
							vel.x = 0
							vel.z = 0
						end
					end
				end
				self.object:setacceleration({x=vel.x - velocity.x,y=y_goal,z=vel.z - velocity.z})
			end
			
		end
	end,
	on_rightclick = function(self, clicker)
		if clicker:get_player_name() == self.controller then
			clicker:set_detach()
			--self.controller = nil
		--elseif self.controller == nil then
		--	clicker:set_attach()
		--	self.controller = clicker:get_player_name()
		end
	end,
	--
})


function spawn_element(p, node)
	local obj = core.add_entity(p, "buildable_vehicles:ship_element")
	obj:get_luaentity():set_node(node)
	return obj
end

function create_vessel(pos,param2)

	local parent = spawn_element(pos, {name="buildable_vehicles:control_node"})
	parent:get_luaentity().object:set_properties({stepheight = 2, automatic_face_movement_dir = (90 * param2)-90, physical = true})--, parent = true})
	local basepos = pos

	local range = settings.ship_size
	
	
	
	local min = {x=pos.x-range,y=pos.y-range,z=pos.z-range}
	local max = {x=pos.x+range,y=pos.y+range,z=pos.z+range}
	local vm = minetest.get_voxel_manip()   
	local emin, emax = vm:read_from_map(min,max)
	local area = VoxelArea:new{MinEdge=emin, MaxEdge=emax}
	local data = vm:get_data()
	
	local air = minetest.get_content_id("air")

	--vehicle collision box
	local collision_box_width_x = 0--to use width instead of length
	local collision_box_width_z = 0
	local collision_box_top     = 0
	local collision_box_bottom  = 0
	--build the vessel
	for x = range*-1,range do
		for y = range*-1,range do
			for z = range*-1,range do
				local pos = {x=basepos.x+x,y=basepos.y+y,z=basepos.z+z}
				--entities for the vessel
				local node = vm:get_node_at(pos).name
				
				---the facedir of the node for node entity
				local face_direction = vm:get_node_at(pos).param2
				--print(face_direction)
				
				
				--print(dump(vm:get_node_at(pos)))
				if settings.node_table[node] then
					local child = spawn_element(pos, {name=node})
					child:get_luaentity().parent = parent
					
					child:get_luaentity().relative = {x=x * settings.attach_scaling,y=y * settings.attach_scaling,z=z * settings.attach_scaling}
					child:get_luaentity().face_direction = face_direction * 90
					--delete the nodes added to the vessel
					local p_pos = area:index(pos.x, pos.y, pos.z)
					data[p_pos] = air
					--set up the collision box
					if y < collision_box_bottom then
						collision_box_bottom = y
					end
					if y > collision_box_top then
						collision_box_top = y
					end
					if x > collision_box_width_x then
						collision_box_width_x = x
					end
					if z > collision_box_width_z then
						collision_box_width_z = z
					end
						
				end
			end
		end
	end
	vm:update_liquids()
	vm:set_data(data)
	vm:calc_lighting()
	vm:write_to_map()
	vm:update_map()
	
	--use width instead of length so vehicles navigate nodes better
	local collision_box_width = 0
	if collision_box_width_x < collision_box_width_z then
		collision_box_width = collision_box_width_x
	elseif collision_box_width_z <= collision_box_width_x then
		collision_box_width = collision_box_width_z
	end
	
	print(collision_box_width)
	collision_box_bottom = collision_box_bottom - 0.5
	collision_box_top    = collision_box_top + 0.5	
	collision_box_width  = collision_box_width + 0.25 -- allow to fit through their own width
	parent:get_luaentity().object:set_properties({collisionbox = {-collision_box_width,collision_box_bottom,-collision_box_width, collision_box_width,collision_box_top,collision_box_width}})
	
	return(parent)
end


minetest.register_node("buildable_vehicles:control_node", {
	description = "Control Node",
	tiles = {
		"default_furnace_top.png^default_mineral_diamond.png", "default_furnace_bottom.png",
		"default_furnace_side.png", "default_furnace_side.png",
		"default_furnace_side.png", "default_furnace_front.png"
	},
	groups = {cracky=3, stone=1},
	paramtype2 = "facedir",
	on_rightclick = function(pos, node, player, itemstack, pointed_thing)
		local vessel = create_vessel(pos,node.param2)
		player:set_attach(vessel, "", {x=0,y=0,z=0}, {x=0,y=0,z=0})
		vessel:get_luaentity().controller = player:get_player_name()
	end,
})








--fuel, lubrication, and coolant -----------------------------------------

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
	tiles = {"default_water.png^[colorize:#000000:200"},
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
	tiles = {"default_water.png^[colorize:#000000:200"},
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

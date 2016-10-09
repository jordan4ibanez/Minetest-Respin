--try to mimic node collision boxes by creating multiple entities attached in an entity with no collision box

local settings = {}
settings.attach_scaling = 30
settings.scaling = 0.667

settings.ship_size = 5


function settings.set(list)
  local set = {}
  for _, l in ipairs(list) do set[l] = true end
  return set
end

settings.node_table = settings.set{"default:wood","default:tree","default:glass","stairs:stair_wood"}

minetest.register_entity("buildable_vehicles:ship_element", {
	initial_properties = {
		physical = true,
		collide_with_objects = true,
		collisionbox = {-0.5,-0.5,-0.5, 0.5,0.5,0.5},  -- THIS NEEDS TO BE MODIFIED ON CREATION
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
				self.object:set_attach(self.parent, "", {x=self.relative.x,y=self.relative.y,z=self.relative.z}, {x=0,y=0,z=0})
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
				if minetest.get_player_by_name(self.controller):get_attach() ~= nil then
					local control = minetest.get_player_by_name(self.controller):get_player_control()
					if control.jump == true or control.sneak == true or control.up == true then
						local vel = {}
						if control.jump == true then
							vel.y = 3
						elseif control.sneak == true then
							vel.y = -3
						else
							vel.y = 0
						end
						if control.up == true then
							local dir = minetest.get_player_by_name(self.controller):get_look_dir()
							vel.x = dir.x * 2
							vel.z = dir.z * 2
						else
							vel.x = 0
							vel.z = 0
						end
						self.object:setacceleration({x=vel.x - velocity.x,y=0,z=vel.z - velocity.z})
					end
				else
					self.object:setacceleration({x=0,y=0,z=0})
				end
			end
			
		end
	end,
	on_rightclick = function(self, clicker)
		if clicker:get_player_name() == self.controller then
			clicker:set_detach()
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
	local basepos = parent:getpos()

	local range = settings.ship_size
	
	
	
	local min = {x=pos.x-range,y=pos.y-range,z=pos.z-range}
	local max = {x=pos.x+range,y=pos.y+range,z=pos.z+range}
	local vm = minetest.get_voxel_manip()   
	local emin, emax = vm:read_from_map(min,max)
	local area = VoxelArea:new{MinEdge=emin, MaxEdge=emax}
	local data = vm:get_data()
	
	local air = minetest.get_content_id("air")

	--build the vessel
	for x = range*-1,range do
		for y = range*-1,range do
			for z = range*-1,range do
				local pos = {x=basepos.x+x,y=basepos.y+y,z=basepos.z+z}
				--entities for the vessel
				local node = vm:get_node_at(pos).name
				local param2 = vm:get_node_at(pos).param2
				--print(dump(vm:get_node_at(pos)))
				if settings.node_table[node] then
					local child = spawn_element(pos, {name=node})
					child:get_luaentity().parent = parent
					
					if param2 then
						child:get_luaentity().param2 = param2
					end
					
					if param2 == 0 then
						print("00000")
						child:get_luaentity().relative = {x=x * settings.attach_scaling,y=y * settings.attach_scaling,z=z * settings.attach_scaling}
					elseif param2 == 1 then
						print("111111")
						child:get_luaentity().relative = {x=x * settings.attach_scaling,y=y * settings.attach_scaling,z=z * settings.attach_scaling}
					elseif param2 == 2 then
						print("22222")
						child:get_luaentity().relative = {x=z * settings.attach_scaling*-1,y=y * settings.attach_scaling,z=x * settings.attach_scaling}
					elseif param2 == 3 then
						print("33333")
						child:get_luaentity().relative = {x=x * settings.attach_scaling*-1,y=y * settings.attach_scaling,z=z * settings.attach_scaling}
					end
					--delete the nodes added to the vessel
					local p_pos = area:index(pos.x, pos.y, pos.z)
					data[p_pos] = air	
				end
			end
		end
	end
	vm:set_data(data)
	vm:calc_lighting()
	vm:write_to_map()
	vm:update_map()
	
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
		print(node.param2)
		local vessel = create_vessel(pos,node.param2)
		player:set_attach(vessel, "", {x=0,y=0,z=0}, {x=0,y=0,z=0})
		vessel:get_luaentity().controller = player:get_player_name()
	end,
})

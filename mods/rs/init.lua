minetest.register_entity("rs:r", { --basic minecart

	physical     = true,
	collisionbox = {-0.45, -0.45, -0.45, 0.45, 0.45, 0.45},
	visual       = mesh,
	mesh         = "basic_minecart.x",
	textures     = "minecart.png",
	visual_size = {x=1, y=1},
	stepheight = 1,
	automatic_face_movement_dir = 0,
	timer = 0,
	collide_with_objects = false,
	vel_goal_x = 0,
	vel_goal_z = 0,
	vel_goal_y = 0,
	
	dir_x = 0,
	dir_y = 0,
	dir_z = 0,
	
	--punch function
	on_punch = function(self)

	end,

	--right click function
	on_rightclick = function(self, clicker)
	
	end,

	--when the entity is created in world
	on_activate = function(self, staticdata, dtime_s)
		self.object:set_armor_groups({immortal=1})

		self.object:setacceleration({x=0,y=-10,z=0})		
	end,
	get_staticdata = function(self)
		return minetest.serialize({
			timer = self.timer,
			used  = self.used,
			age   = self.age,
		})
	end,



	--what the mob does in the world
	on_step = function(self, dtime)
		self.timer = self.timer + dtime
		
		local pos = self.object:getpos()
		local vel = self.object:getvelocity()
		
		local goal_pos = {x=pos.x+self.dir_x,y=pos.y+self.dir_y,z=pos.z+self.dir_z}
		
		if self.dir_x == 0 then
			if string.match(minetest.get_node({x=pos.x+1,y=pos.y,z=pos.z}).name, "rail") then
				self.dir_x = 1
			elseif string.match(minetest.get_node({x=pos.x-1,y=pos.y,z=pos.z}).name, "rail")   then
				self.dir_x = -1
			end
		end
		if self.dir_z == 0 then
			if string.match(minetest.get_node({x=pos.x,y=pos.y,z=pos.z+1}).name, "rail")  then
				self.dir_z = 1
			elseif  string.match(minetest.get_node({x=pos.x,y=pos.y,z=pos.z-1}).name, "rail")  then
				self.dir_z = -1
			end
		end
		
		

		
		--print(minetest.get_item_group(minetest.get_node({x=pos.x+1,y=pos.y,z=pos.z}).name, "rail"))
							
		local pos1 = pos
		--pos1.y = pos1.y+item_drop_settings.player_collect_height
		local object = minetest.get_player_by_name("singleplayer")
		local pos2 = goal_pos
		local vec = {x=pos1.x-pos2.x, y=pos1.y-pos2.y, z=pos1.z-pos2.z}

		self.vel_goal_x = (vec.x*-4) -- do speed instead
		self.vel_goal_y = (vec.y*-4)
		self.vel_goal_z = (vec.z*-4)
		for _,object in ipairs(minetest.env:get_objects_inside_radius(pos, 0.6)) do
			if object:is_player() then
				self.vel_goal_x = 0 -- this is a lazy workaround
				self.vel_goal_y = 0
				self.vel_goal_z = 0
			end
		end
	end,
	})

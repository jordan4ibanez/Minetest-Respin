minetest.register_entity("rs:r", { --basic minecart

	physical     = true,
	collisionbox = {-0.45, -1.75, -0.45, 0.45, 0.45, 0.45},
	visual       = "mesh",
	mesh         = "minecart.x",
	textures     = {"minecart.png"},
	visual_size = {x=1, y=1},
	stepheight = 0.7,
	automatic_face_movement_dir = 0,
	timer = 0,
	collide_with_objects = false,
	vel_goal_x = 0,
	vel_goal_z = 0,
	vel_goal_y = 0,
	
	dir_x = 0,
	dir_y = 0,
	dir_z = 0,
	
	speed = 0,
	
	attach = false,
	
	--punch function
	on_punch = function(self)
	end,

	--right click function
	on_rightclick = function(self, clicker)
		self.dir_x = 1
		--self.obj
		if self.attach == false then
			self.speedup = true
			clicker:set_attach(self.object, "", {x=0,y=0,z=0}, {x=0,y=0,z=0})
			self.attach = clicker:get_player_name()
		elseif self.attach ~= false then
			self.speedup = false
			local player = minetest.get_player_by_name(self.attach)
			player:set_detach()
			self.attach = false
		end
	end,

	--when the entity is created in world
	on_activate = function(self, staticdata, dtime_s)
		--self.object:set_armor_groups({immortal=1})
		self.object:set_animation({x=45,y=45},0, 0)
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
		if self.speedup == true then
			self.speed = self.speed + dtime
		else
			if self.speed > 0 then
				self.speed = self.speed - dtime
				if self.speed < 0 then
					self.speed = 0
				end
			end
		end
		
		local pos = self.object:getpos()
		local vel = self.object:getvelocity()
		if vel.y < 0 then
			self.object:set_animation({x=0,y=0},0, 0)
		elseif vel.y > 0 then
			self.object:set_animation({x=90,y=90},0, 0)
		else
			self.object:set_animation({x=45,y=45},0, 0)
		end
		
		--self.speed = 5
		if self.dir_x ~= 0 and vel.x == 0 then
			if minetest.get_node({x=pos.x,y=pos.y,z=pos.z+1}).name == "air" then
				self.dir_z = 1
				self.dir_x = 0
			elseif minetest.get_node({x=pos.x,y=pos.y,z=pos.z-1}).name == "air" then
				self.dir_z = -1
				self.dir_x = 0
			end
		elseif self.dir_z ~= 0 and vel.z == 0 then
			if minetest.get_node({x=pos.x+1,y=pos.y,z=pos.z}).name == "air" then
				self.dir_x = 1
				self.dir_z = 0
			elseif minetest.get_node({x=pos.x-1,y=pos.y,z=pos.z}).name == "air" then
				self.dir_x = -1
				self.dir_z = 0
			end
		end
		
		self.goal = {x=self.dir_x*self.speed,y=-10,z=self.dir_z*self.speed}
		
		self.object:setvelocity(self.goal)

	end,
	})

minetest.override_item("default:stick", {
	on_place = function(itemstack, placer, pointed_thing)
		pointed_thing.above.y = pointed_thing.above.y + 2
		minetest.add_entity(pointed_thing.above, "rs:r")
	end,
})

--have ore generation, looks and acts like stone, but when mined generates a mob (maybe angry block mob?)

--The AI for the land mobs
function register_mob_land(name, def)
	minetest.register_entity("mob:"..name, {
	mob          = true,
	hp_max       = def.hp,
	physical     = true,
	collisionbox = def.collisionbox,
	visual       = def.visual, --do this for "node monsters"
	mesh         = def.mesh,
	textures     = def.textures,
	hostile      = def.hostile,
	visual_size = {x=def.size, y=def.size},
	
	automatic_face_movement_dir = def.dir,
	yaw = 0,
	attack_timer = 0,
	
	jump = false,
	fall = false,
	
	timer = 0,
	makes_footstep_sound = true,
	stepheight = 1, --2 for not jumping
	collide_with_objects = false,
	timer_max = 0,
	vel_goal_x = 0,
	vel_goal_z = 0,
	used = false,
	
	last_vel_y = 0,
	old_water = false,
	--punch function
	on_punch = function(self,puncher)
		--drop stuff on die
		local pos = self.object:getpos()

		if self.object:get_hp() <= 0 then
			
			pos.y = pos.y + 0.5
			minetest.add_item(pos, def.drop)
			minetest.add_particlespawner({
				 amount = 40,
				 time = 0.1,
				 minpos = {x=pos.x-0.5, y=pos.y, z=pos.z-0.5},
				 maxpos = {x=pos.x+0.5, y=pos.y+1, z=pos.z+0.5},
				 minvel = {x=0, y=0.5, z=0},
				 maxvel = {x=0, y=1, z=0},
				 minacc = {x=0, y=0, z=0},
				 maxacc = {x=0, y=0, z=0},
				 minexptime = 1,
				 maxexptime = 1,
				 minsize = 1,
				 maxsize = 2,
				 collisiondetection = false,
				 vertical = false,
				 texture = "spawn_smoke.png",
			})
			minetest.sound_play("poof", {
				pos = pos,
				max_hear_distance = 100,
				gain = 10.0,
			})
		else

			local below = minetest.get_node({x=pos.x, y=pos.y + def.collisionbox[2] -  0.1, z=pos.z}).name
			local below2 = minetest.registered_items[below].walkable
			if puncher ~= nil and below2 == true then
				local pos2 = puncher:getpos()
				local vec = {x=pos.x-pos2.x, y=pos.y-pos2.y, z=pos.z-pos2.z}
				local yaw = math.atan(vec.z/vec.x)+math.pi/2
				if self.drawtype == "side" then
					yaw = yaw+(math.pi/2)
				end
				if pos.x > pos2.x then
					yaw = yaw+math.pi
				end
				--self.object:setyaw(yaw)
				local v = def.max_speed
				local x = math.sin(yaw) * -v
				local z = math.cos(yaw) * v
				self.object:setvelocity({x=x,y=5,z=z})
				
			end
			self.object:settexturemod("^[colorize:#ff0000:60")
			minetest.after(0.5, function(self)
				if self == nil then
					return
				end
				self.object:settexturemod("")
			end, self)
			minetest.sound_play(def.hurt_sound, {
				pos = pos,
				max_hear_distance = 10,
				gain = 10.0,
			})
			local hp = self.object:get_hp()
			
			local texture = "[combine:"..tostring(hp*16).."x"..tostring(hp*16)..":1,1=heart.png"
			
			for i = 1,hp do
				texture = texture..":"..tostring(i*16)..",1=heart.png"
			end
			
			minetest.add_particle({
				pos = {x=pos.x, y=pos.y+1.5, z=pos.z},
				velocity = {x=0, y=0, z=0},
				acceleration = {x=0, y=1, z=0},
				expirationtime = 1,
				size = 10,
				collisiondetection = false,
				vertical = true,
				texture = texture,
				--playername = "singleplayer"
			})
		end

	end,

	--right click function
	on_rightclick = function(self, clicker)
		local pos = self.object:getpos()
		
		--do stuff, like milk cow, or shear sheep with shears
		
		if self.used == false then
			if clicker:get_wielded_item():to_string() == def.tool then
				minetest.add_item(pos, def.alt_drop)
				self.used = true
			end
		end
	end,

	--when the entity is created in world
	on_activate = function(self, staticdata, dtime_s)
		self.object:setacceleration({x=0,y=-10,z=0})
		self.object:set_animation({x=def.walk_start,y=def.walk_end},def.normal_speed, 0)
		local pos = self.object:getpos()
		--[[
		minetest.add_particlespawner({
			 amount = 40,
			 time = 0.1,
			 minpos = {x=pos.x-0.5, y=pos.y, z=pos.z-0.5},
			 maxpos = {x=pos.x+0.5, y=pos.y+1, z=pos.z+0.5},
			 minvel = {x=0, y=0.5, z=0},
			 maxvel = {x=0, y=1, z=0},
			 minacc = {x=0, y=0, z=0},
			 maxacc = {x=0, y=0, z=0},
			 minexptime = 1,
			 maxexptime = 1,
			 minsize = 1,
			 maxsize = 2,
			 collisiondetection = false,
			 vertical = false,
			 texture = "spawn_smoke.png",
		})
		]]--
		--minetest.sound_play("poof", {
		--	pos = pos,
		--	max_hear_distance = 100,
		--	gain = 10.0,
		--})
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
		self.attack_timer = self.attack_timer + dtime
		

		local pos = self.object:getpos()
		local vel = self.object:getvelocity()
		self.object:setacceleration({x=self.vel_goal_x - vel.x,y=-10,z=self.vel_goal_z - vel.z})
		
	
		--if there is a walkable node try to jump unless it's a fence
		--if in water, swim up
		local node_goal_x = 0
		if self.vel_goal_x > 0 then
			node_goal_x = 1
		elseif self.vel_goal_x < 0 then
			node_goal_x = -1
		end
		local node_goal_z = 0
		if self.vel_goal_z > 0 then
			node_goal_z = 1
		elseif self.vel_goal_z < 0 then
			node_goal_z = -1
		end
				
		local node = minetest.get_node({x=pos.x + node_goal_x, y=pos.y +def.collisionbox[2] + 0.5, z=pos.z+node_goal_z}).name
		local walkable = minetest.registered_items[node].walkable
		local fence = minetest.get_item_group(node, "fence")
		local below = minetest.get_node({x=pos.x, y=pos.y + def.collisionbox[2] -  0.1, z=pos.z}).name
		local below2 = minetest.registered_items[below].walkable
		local node_center = minetest.get_node({x=pos.x, y=pos.y + def.collisionbox[2] + 0.5, z=pos.z}).name
		if walkable == true then
			if fence == 0 then
				if below2 == true then
					self.object:setvelocity({x=vel.x,y=5,z=vel.z})
				end
			end
		end
		--mob falling damage -- 5 node fall
		
		-- change this to a def of falling distance before pain
		if vel.y == 0 and self.last_vel_y < -5 then
			local hp = self.object:get_hp()
			local hurt = math.abs(self.last_vel_y + 5) 
			self.object:set_hp(hp - hurt)
			minetest.sound_play(def.hurt_sound, {
				pos = pos,
				max_hear_distance = 10,
				gain = 10.0,
			})
			self.object:settexturemod("^[colorize:#ff0000:60")
			minetest.after(0.5, function(self)
				if self == nil then
					return
				end
				self.object:settexturemod("")
			end, self)
			minetest.after(0, function(self)
				if self.object:get_hp() <= 0 then
					local pos = self.object:getpos()
					pos.y = pos.y + 0.5
					minetest.add_item(pos, def.drop)
					minetest.add_particlespawner({
						 amount = 40,
						 time = 0.1,
						 minpos = {x=pos.x-0.5, y=pos.y, z=pos.z-0.5},
						 maxpos = {x=pos.x+0.5, y=pos.y+1, z=pos.z+0.5},
						 minvel = {x=0, y=0.5, z=0},
						 maxvel = {x=0, y=1, z=0},
						 minacc = {x=0, y=0, z=0},
						 maxacc = {x=0, y=0, z=0},
						 minexptime = 1,
						 maxexptime = 1,
						 minsize = 1,
						 maxsize = 2,
						 collisiondetection = false,
						 vertical = false,
						 texture = "spawn_smoke.png",
					})
					minetest.sound_play("poof", {
						pos = pos,
						max_hear_distance = 100,
						gain = 10.0,
					})
					self.object:remove()
				end
			end,self)
		end
		self.last_vel_y = vel.y
		--swim wherever it's going, and do particles on splash with sound
		if self.old_water == false and minetest.get_item_group(node_center, "water") ~= 0 then
			minetest.add_particlespawner({
				 amount = 10,
				 time = 0.1,
				 minpos = {x=pos.x-0.7, y=pos.y, z=pos.z-0.7},
				 maxpos = {x=pos.x+0.7, y=pos.y+1, z=pos.z+0.7},
				 minvel = {x=0, y=0.5, z=0},
				 maxvel = {x=0, y=1, z=0},
				 minacc = {x=0, y=0, z=0},
				 maxacc = {x=0, y=0, z=0},
				 minexptime = 1,
				 maxexptime = 1,
				 minsize = 1,
				 maxsize = 2,
				 collisiondetection = false,
				 vertical = false,
				 texture = "bubble.png",
			})
			--sound depends on if mob falls into water
			if vel.y < -4 then
				minetest.sound_play("land_splash_big", {
					pos = pos,
					max_hear_distance = 10,
					gain = 10.0,
				})
			else
				minetest.sound_play("land_splash", {
					pos = pos,
					max_hear_distance = 3,
					gain = 10.0,
				})
			end
		end
		self.old_water = false
		if minetest.get_item_group(node_center, "water") > 0 then
			self.object:setacceleration({x=self.vel_goal_x - vel.x,y=10 - vel.y,z=self.vel_goal_z - vel.z})
			self.old_water = true
		end
		
		--change the animation speed based on how fast the mob moves
		if math.abs(vel.x) > math.abs(vel.z) then
			self.object:set_animation({x=def.walk_start,y=def.walk_end},math.abs(vel.x)*def.normal_speed, 0)
		else
			self.object:set_animation({x=def.walk_start,y=def.walk_end},math.abs(vel.z)*def.normal_speed, 0)
		end
		
		--if the velocity goal is almost 0 then do standing animation when stil
		if self.vel_goal_x == 0 and self.vel_goal_z == 0 then
			if math.abs(vel.x) < 0.05 and math.abs(vel.z) < 0.05 then
				self.object:set_animation({x=def.stand_start,y=def.stand_end},def.normal_speed, 0)
			end
		end
		
		--this section changes if the mob moves or stands still based on an internal timer
		
		if self.timer > self.timer_max then
			--change velocity goal
			--print("change velocity goal")
			self.timer = 0
			self.timer_max = math.random(2,10)
			if math.random() > 0.5 then
				--rest
				self.vel_goal_x = 0
				self.vel_goal_z = 0
			else
				--move
				self.vel_goal_x = math.random(-def.max_speed,def.max_speed)*math.random()
				self.vel_goal_z = math.random(-def.max_speed,def.max_speed)*math.random()
			end
			
		end
		--chase player
		if self.hostile == true then
			for _,object in ipairs(minetest.env:get_objects_inside_radius(pos, def.chase_rad)) do
				if object:is_player() then
					if object:get_hp() > 0 then
						--modified simplemobs api
						local pos2 = object:getpos()
						local vec = {x=pos.x-pos2.x, y=pos.y-pos2.y, z=pos.z-pos2.z}
						local yaw = math.atan(vec.z/vec.x)+math.pi/2
						if self.drawtype == "side" then
							yaw = yaw+(math.pi/2)
						end
						if pos.x > pos2.x then
							yaw = yaw+math.pi
						end
						--self.object:setyaw(yaw)
						local v = def.max_speed
						local x = math.sin(yaw) * v
						local z = math.cos(yaw) * -v

						self.vel_goal_x = x
						self.vel_goal_z = z						
						
						for _,object in ipairs(minetest.env:get_objects_inside_radius(pos, def.attack_rad)) do
							if object:is_player() then
								if self.attack_timer > def.attack_cooldown then
									object:set_hp(object:get_hp()-def.attack_damage)
									self.attack_timer = 0
									minetest.sound_play(def.attack_sound, {
										pos = pos,
										max_hear_distance = 10,
										gain = 10.0,
									})
								end
							end
						end
						break
					end
				end
			end
			
		end
		
		--"collision detection"
		for _,object in ipairs(minetest.env:get_objects_inside_radius(pos, 1)) do
			if not object:is_player() and object ~= self.object then
				if object:get_luaentity().mob then
					local pos2 = object:getpos()
					local vec = {x=pos.x-pos2.x, y=pos.y-pos2.y, z=pos.z-pos2.z}
					local yaw = math.atan(vec.z/vec.x)+math.pi/2
					if self.drawtype == "side" then
						yaw = yaw+(math.pi/2)
					end
					if pos.x > pos2.x then
						yaw = yaw+math.pi
					end
					--self.object:setyaw(yaw)
					local v = def.max_speed
					local x = math.sin(yaw) * -v
					local z = math.cos(yaw) * v
					if self.old_water == true then
						self.object:setacceleration({x=x,y=1 - vel.y,z=z})
					else
						self.object:setacceleration({x=x,y=-10,z=z})
					end
				end
			elseif object:is_player() then
				local pos2 = object:getpos()
				local vec = {x=pos.x-pos2.x, y=pos.y-pos2.y, z=pos.z-pos2.z}
				local yaw = math.atan(vec.z/vec.x)+math.pi/2
				if self.drawtype == "side" then
					yaw = yaw+(math.pi/2)
				end
				if pos.x > pos2.x then
					yaw = yaw+math.pi
				end
				--self.object:setyaw(yaw)
				local v = def.max_speed
				local x = math.sin(yaw) * -v
				local z = math.cos(yaw) * v
				if self.old_water == true then
					self.object:setacceleration({x=x,y=1 - vel.y,z=z})
				else
					self.object:setacceleration({x=x,y=-10,z=z})
				end
			end
		end
	
	end,
	})

	--spawners
	
	minetest.register_decoration({
		deco_type = "simple",
		place_on = def.spawn_on,
		sidelen = mob_chunksize,--8
		fill_ratio = def.fill_ratio,--0.001
		decoration = "mob:spawner_"..name,
		height = 1,
	})

	minetest.register_node("mob:spawner_"..name, {
		description = "Shouldn't Have This",
		tiles = {"invisible_node.png","invisible_node.png","invisible_node.png","invisible_node.png","invisible_node.png","invisible_node.png"},
		drawtype = "glasslike",
		walkable = false,
		sunlight_propagates = true,
		buildable_to = true,
	})
	minetest.register_lbm({
		name = "mob:mob_spawner_"..name,
		nodenames = {"mob:spawner_"..name},
		run_at_every_load = true,
		action = function(pos, node)
			minetest.remove_node(pos)
			minetest.add_entity(pos, "mob:"..name)
		end,
	})
	
	--spawnegg
	minetest.register_craftitem("mob:"..name.."_spawn_egg",{
		description = name.." Spawn Egg",
		inventory_image = "spawn_egg.png",
		on_place = function(itemstack, placer, pointed_thing)
			minetest.add_entity(pointed_thing.above, "mob:"..name)
		end,
	})
end

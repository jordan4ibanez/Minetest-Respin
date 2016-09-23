--The AI for the land mobs
function register_mob_land(name, def)
	minetest.register_entity("mob:"..name, {
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

	
	jump = false,
	fall = false,
	
	timer = 0,
	makes_footstep_sound = true,
	--stepheight = 1, --2 for not jumping
	collide_with_objects = false,
	timer_max = 0,
	vel_goal_x = 0,
	vel_goal_z = 0,
	used = false,
	
	--punch function
	on_punch = function(self)
		--drop stuff on die
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
		else
			minetest.sound_play(def.hurt_sound, {
				pos = pos,
				max_hear_distance = 10,
				gain = 10.0,
			})
		end

	end,

	--right click function
	on_rightclick = function(self, clicker)
		--do stuff, like milk cow, or shear sheep with shears
		local pos = self.object:getpos()
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

		
		local pos = self.object:getpos()
		local vel = self.object:getvelocity()
		self.object:setacceleration({x=self.vel_goal_x - vel.x,y=-10,z=self.vel_goal_z - vel.z})
		
		--if there is a walkable node try to jump unless it's a fence
		--if in water, swim up
		local node = minetest.get_node({x=pos.x + self.vel_goal_x, y=pos.y + 0.5, z=pos.z+self.vel_goal_z}).name
		local walkable = minetest.registered_items[node].walkable
		local fence = minetest.get_item_group(node, "fence")
		local below = minetest.get_node({x=pos.x, y=pos.y - 0.1, z=pos.z}).name
		local below2 = minetest.registered_items[below].walkable
		local node_center = minetest.get_node({x=pos.x, y=pos.y + 0.5, z=pos.z}).name
		if walkable == true then
			if fence == 0 then
				if below2 == true then
					self.object:setvelocity({x=vel.x,y=5,z=vel.z})
				end
			end
		end
		--swim wherever it's going
		if minetest.get_item_group(node_center, "water") > 0 then
			self.object:setacceleration({x=self.vel_goal_x - vel.x,y=1 - vel.y,z=self.vel_goal_z - vel.z})
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

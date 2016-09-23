--make fish jump when on land and go no where

function register_mob_water(name, def)
	minetest.register_entity("mob:"..name, {
	hp_max       = def.health,
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
	makes_footstep_sound = false,
	--stepheight = 1, --2 for not jumping
	collide_with_objects = false,
	timer_max = 0,
	vel_goal_x = 0,
	vel_goal_z = 0,
	vel_goal_y = 0,
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
		self.attack_timer = self.attack_timer + dtime
		
		local pos = self.object:getpos()
		local vel = self.object:getvelocity()
		self.object:setacceleration({x=self.vel_goal_x - vel.x,y=self.vel_goal_y - vel.y,z=self.vel_goal_z - vel.z})
		
		
		
		
		
		--if fish is out of water then flop around

		local node = minetest.get_node({x=pos.x + self.vel_goal_x, y=pos.y +def.collisionbox[2] + 0.5, z=pos.z+self.vel_goal_z}).name
		local walkable = minetest.registered_items[node].walkable
		local fence = minetest.get_item_group(node, "fence")
		local below = minetest.get_node({x=pos.x, y=pos.y + def.collisionbox[2] -  0.1, z=pos.z}).name
		local below2 = minetest.registered_items[below].walkable
		local node_center = minetest.get_node({x=pos.x, y=pos.y + def.collisionbox[2] + 0.5, z=pos.z}).name
			
		
		--if resting then stop
		if self.vel_goal_x == 0 and self.vel_goal_y == 0 and self.vel_goal_z == 0 then
			self.object:setacceleration({x=self.vel_goal_x - vel.x,y=self.vel_goal_y - vel.y,z=self.vel_goal_z - vel.z})
		end
		--if out of water then apply gravity and render it unable to move, flopping around
		--if in water and player is near, attack
		if minetest.get_item_group(node_center, "water") == 0 then
			if below2 == true then
				self.object:setvelocity({x=vel.x,y=5,z=vel.z})
				--make fish run out of breath
				minetest.sound_play("fish_splat", {
					pos = pos,
					max_hear_distance = 10,
					gain = 0.5,
				})
				self.vel_goal_x = 0
				self.vel_goal_y = 0
				self.vel_goal_z = 0
			end
			
			--self.vel_goal_x = 0
			--self.vel_goal_y = 0
			--self.vel_goal_z = 0
			self.object:setacceleration({x=self.vel_goal_x - vel.x,y=-10,z=self.vel_goal_z - vel.z})
		else
			if self.hostile == true then
				for _,object in ipairs(minetest.env:get_objects_inside_radius(pos, def.chase_rad)) do
					if object:is_player() then
				--modified simplemobs api
									
						local pos1 = pos
						--pos1.y = pos1.y+item_drop_settings.player_collect_height
						local pos2 = object:getpos()
						local vec = {x=pos1.x-pos2.x, y=pos1.y-pos2.y, z=pos1.z-pos2.z}
						--vec.x = vec.x
						--vec.y = vec.y
						--vec.z = vec.z
						self.vel_goal_x = (vec.x*-1) -- this is a lazy workaround
						self.vel_goal_y = (vec.y*-1)
						self.vel_goal_z = (vec.z*-1)
						for _,object in ipairs(minetest.env:get_objects_inside_radius(pos, def.attack_rad)) do
							if object:is_player() then
								if self.attack_timer > def.attack_cooldown then
									object:set_hp(object:get_hp()-def.attack_damage)
									self.attack_timer = 0
								end
							end
						end
						break
					end
				end
				
			end		
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
			minetest.sound_play("fish_bubbles", {
				pos = pos,
				max_hear_distance = 20,
				gain = 10.0,
			})
			if math.random() > 0.5 then
				--rest
				self.vel_goal_x = 0
				self.vel_goal_z = 0
				self.vel_goal_y = 0
				self.timer = self.timer/2
			else
				--move
				self.vel_goal_x = math.random(-def.max_speed,def.max_speed)*math.random()
				self.vel_goal_z = math.random(-def.max_speed,def.max_speed)*math.random()
				self.vel_goal_y = math.random(-def.max_speed,def.max_speed)*math.random()
			end
		end
	end,
	})

	--spawners
	
	minetest.register_ore({
		ore_type       = "scatter",
		ore            = "mob:spawner_"..name,
		wherein        = "default:water_source",
		clust_scarcity = def.scarcity,
		clust_num_ores = 2,
		clust_size     = 1,
		height_min     = -31000,
		height_max     = 64,
	})	

	minetest.register_node("mob:spawner_"..name, {
		description = "Water Source",
		drawtype = "liquid",
		tiles = {
			{
				name = "default_water_source_animated.png",
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
				name = "default_water_source_animated.png",
				animation = {
					type = "vertical_frames",
					aspect_w = 16,
					aspect_h = 16,
					length = 2.0,
				},
				backface_culling = false,
			},
		},
		alpha = 160,
		paramtype = "light",
		walkable = false,
		pointable = false,
		diggable = false,
		buildable_to = true,
		is_ground_content = false,
		drop = "",
		drowning = 1,
		liquid_viscosity = 1,
		post_effect_color = {a = 103, r = 30, g = 60, b = 90},
		groups = {water = 3, liquid = 3, puts_out_fire = 1},
	})

	minetest.register_lbm({
		name = "mob:mob_spawner_"..name,
		nodenames = {"mob:spawner_"..name},
		run_at_every_load = true,
		action = function(pos, node)
			minetest.set_node(pos, {name="default:water_source"})
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

--have mob grow up from baby size using visualsize to adulthood
--have mob eat things
--have mob drink water
--have mob have stat bars above them
--save mob stats on deserialize

--built on simple mobs, with assets from simplemobs[pilzadam], mobs redo[tenplus1],mob spawn eggs[thefamilygrog66]


--current goal: have mob move around on it's own and not be so stupid

mob_chunksize = minetest.get_mapgen_params().chunksize


function register_stupid_mob(name, def)
	minetest.register_entity("mob:"..name, {
	
	physical     = true,
	collisionbox = def.collisionbox,
	visual       = def.visual, --do this for "node monsters"
	mesh         = def.mesh,
	textures     = def.textures,
	hostile      = def.hostile,
	
	automatic_face_movement_dir = -90.0,
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
	
	--punch function
	on_punch = function(self)
		--drop stuff on die
		if self.object:get_hp() <= 0 then
			print("Do the particle effect")
			local pos = self.object:getpos()
			pos.y = pos.y + 0.5
			minetest.add_item(pos, def.drop)
		end
	end,

	--right click function
	on_rightclick = function(self, clicker)
		--do stuff, like milk cow, or shear sheep with shears
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
			 minvel = {x=0, y=1, z=0},
			 maxvel = {x=0, y=2, z=0},
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

		})
	end,














	--what the mob does in the world
	on_step = function(self, dtime)
		self.timer = self.timer + dtime
		local pos = self.object:getpos()
		local vel = self.object:getvelocity()
		self.object:setacceleration({x=self.vel_goal_x - vel.x,y=-10,z=self.vel_goal_z - vel.z})
		
		if minetest.get_node({x=pos.x + self.vel_goal_x, y=pos.y + 0.9, z=pos.z+self.vel_goal_z}).name ~= "air" then
			self.object:setvelocity({x=vel.x,y=5,z=vel.z})
		end
		
		---self.object:set_properties({visual_size = {x=self.timer, y=self.timer}})
		if self.timer > self.timer_max then
			--change velocity goal
			print("change velocity goal")
			self.vel_goal_x = math.random(-def.max_speed,def.max_speed)*math.random()
			self.vel_goal_z = math.random(-def.max_speed,def.max_speed)*math.random()
			self.timer = 0
			self.timer_max = math.random(1,10)
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

register_stupid_mob("sheep", {
--self params
collisionbox = {-0.4, -0.01, -0.4, 0.4, 1, 0.4},
visual       = "mesh",
mesh         = "mobs_sheep.x",
textures     = {"mobs_sheep.png"},

--animation params
normal_speed = 15,
stand_start  = 0,
stand_end    = 80,
walk_start   = 81,
walk_end     = 100,

--world/behavior params
hostile      = false,
spawn_on     = "default:dirt_with_grass",
fill_ratio   = 0.01, --amount of mobs to spawn
max_speed    = 2,

drop         = "wool:white",
})

--[[
register_stupid_mob("cow", {
--self params
collisionbox = {-0.4, -0.01, -0.4, 0.4, 1, 0.4},
visual       = "mesh",
mesh         = "mobs_cow.x",
textures     = {"mobs_cow.png"},

--animation params
normal_speed = 15,
stand_start  = 0,
stand_end    = 30,
walk_start   = 35,
walk_end     = 65,

--world/behavior params
hostile      = false,
spawn_on     = "default:dirt_with_grass",
fill_ratio   = 0.01, --amount of mobs to spawn 
max_speed    = 3,

drop         = "default:glass",

})
]]--

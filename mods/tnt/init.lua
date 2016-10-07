
minetest.register_node("tnt:tnt", {
	tile_images = {"tnt_top.png", "tnt_bottom.png","tnt_side.png", "tnt_side.png","tnt_side.png", "tnt_side.png"},
	description = "TNT",
	on_punch = function(pos, node, puncher)
		minetest.remove_node(pos)
		minetest.add_entity(pos,"tnt:tnt")
		minetest.sound_play("tnt_ignite", {
			pos = pos,
			max_hear_distance = 60,
			gain = 1.0,
		})
	end,
})

minetest.register_entity("tnt:tnt", {

	physical     = true,
	collisionbox = {-0.45, -0.45, -0.45, 0.45, 0.45, 0.45},
	visual       = "cube",
	textures     = {"tnt_top.png", "tnt_bottom.png","tnt_side.png", "tnt_side.png","tnt_side.png", "tnt_side.png"},
	visual_size = {x=1, y=1},
	timer = 0,


	on_activate = function(self, staticdata, dtime_s)
		self.object:set_armor_groups({immortal = 1})
		self.object:setvelocity({x=math.random(-0.5,0.5),y=math.random(4,7),z=math.random(-0.5,0.5)})
		self.object:setacceleration({x=0,y=-10,z=0,})
	end,


	on_step = function(self, dtime)
		self.timer = self.timer + dtime
		local vel = self.object:getvelocity()
		local pos = self.object:getpos()
		minetest.add_particle({
			pos = {x=pos.x, y=pos.y+0.5, z=pos.z},
			velocity = {x=math.random(-1,1)*math.random(), y=math.random(2,5), z=math.random(-1,1)*math.random()},
			acceleration = {x=0, y=1, z=0},
			expirationtime = 0.3,
			size = 1,
			collisiondetection = false,
			vertical = true,
			texture = "tnt_smoke.png",
			--playername = "singleplayer"
		})
		--tnt friction
		self.object:setacceleration({x=0 - vel.x,y=-10,z=0 - vel.z})
		if self.timer > 3 then
			boom(pos, 4)
			self.object:remove()
		end
	end,
})

function boom(pos, radius)
	pos = {x=math.floor(pos.x),y=math.floor(pos.y),z=math.floor(pos.z)}
	minetest.sound_play("tnt_explode", {
		pos = pos,
		max_hear_distance = 100,
		gain = 1.0,
	})
	local min = {x=pos.x-radius,y=pos.y-radius,z=pos.z-radius}
	local max = {x=pos.x+radius,y=pos.y+radius,z=pos.z+radius}
	local vm = minetest.get_voxel_manip()	
	local emin, emax = vm:read_from_map(min,max)
	local area = VoxelArea:new{MinEdge=emin, MaxEdge=emax}
	local data = vm:get_data()
	
	local air = minetest.get_content_id("air")
	
	for x = -radius,radius  do
		for z = -radius,radius  do
			for y = -radius,radius  do
				local p_pos = area:index(pos.x+x,pos.y+y,pos.z+z)
				local pos2 = {x=pos.x+x,y=pos.y+y,z=pos.z+z}
				local name = minetest.get_name_from_content_id(data[p_pos])
				if x*x+y*y+z*z <= radius * radius + radius then
					data[p_pos] = air
					minetest.add_particlespawner({
						 amount = 5,
						 time = 0.1,
						 minpos = {x=pos2.x-0.5, y=pos2.y-0.5, z=pos2.z-0.5},
						 maxpos = {x=pos2.x+0.5, y=pos2.y+0.5, z=pos2.z+0.5},
						 minvel = {x=0, y=0, z=0},
						 maxvel = {x=0, y=0, z=0},
						 minacc = {x=0, y=0, z=0},
						 maxacc = {x=0, y=0, z=0},
						 minexptime = math.random(1,2),
						 maxexptime = math.random(1,2),
						 minsize = 1,
						 maxsize = 2,
						 collisiondetection = false,
						 vertical = false,
						 texture = "tnt_smoke.png",
					})
				end
			end
		end
	end
	
	vm:update_liquids()
	vm:set_data(data)
	vm:calc_lighting()
	vm:write_to_map()
	vm:update_map()
end


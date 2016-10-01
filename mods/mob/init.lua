--DONE have mob move around on it's own and not be so stupid

--have mob grow up from baby size using visualsize to adulthood
--have mob eat things
--have mob drink water


--have mob have stat bars above them
--save mob stats on deserialize

--have mobs regenerate use after eating grass or whatever they eat or drink

--built on simple mobs, with assets from simplemobs[pilzadam], mobs redo[tenplus1],mob spawn eggs[thefamilygrog66]




mob_chunksize = minetest.get_mapgen_params().chunksize
dofile(minetest.get_modpath("mob").."/land_ai.lua")
dofile(minetest.get_modpath("mob").."/water_ai.lua")


minetest.register_craftitem("mob:shears", {
	description = "Shears",
	inventory_image = "shears.png",
})

minetest.register_craftitem("mob:meat_raw", {
	description = "Raw Meat",
	inventory_image = "mobs_meat_raw.png",
})

minetest.register_craftitem("mob:meat", {
	description = "Meat",
	inventory_image = "mobs_meat.png",
	on_use = minetest.item_eat(5),
})

minetest.register_craft({
	type = "cooking",
	output = "mob:meat",
	recipe = "mob:meat_raw",
	cooktime = 5,
})



register_mob_land("sheep", {
--self params
hp           = 10,
collisionbox = {-0.5, -0.5, -0.5, 0.5, 0.5, 0.5},
visual       = "mesh",
mesh         = "mobs_sheep.x",
textures     = {"mobs_sheep.png"},
dir          = -90,
size         = 1,

--animation params
normal_speed = 15,
stand_start  = 0,
stand_end    = 80,
walk_start   = 81,
walk_end     = 100,

--world/behavior params
hostile      = false,
spawn_on     = "default:dirt_with_grass",
fill_ratio   = 0.001, --amount of mobs to spawn
max_speed    = 2,

tool         = "mob:shears",
alt_drop     = "wool:white",
drop         = "mob:raw_meat",
hurt_sound   = "sheep",
})

register_mob_land("zombie", {
--self params
collisionbox = {-0.5, -0.5, -0.5, 0.5, 0.5, 0.5},
visual       = "mesh",
mesh         = "zombie.b3d",
textures     = {"zombie.png"},
dir          = -90,
size         = 1,

--animation params
normal_speed = 15,
stand_start  = 0,
stand_end    = 80,
walk_start   = 102,
walk_end     = 121,

--world/behavior params
hostile      = true,
spawn_on     = "default:dirt_with_grass",
fill_ratio   = 0.001, --amount of mobs to spawn 
max_speed    = 3,
chase_rad    = 15,
attack_rad   = 1,
health       = 20,
attack_cooldown = 1,
attack_damage = 2,

drop         = "default:glass",

})
--[[[
register_mob_land("cow", {
--self params
collisionbox = {-0.5, -0.5, -0.5, 0.5, 0.5, 0.5},
visual       = "mesh",
mesh         = "mobs_cow.x",
textures     = {"mobs_cow.png"},
dir          = -90,
size         = 1,

--animation params
normal_speed = 15,
stand_start  = 0,
stand_end    = 30,
walk_start   = 35,
walk_end     = 65,

--world/behavior params
hostile      = false,
spawn_on     = "default:dirt_with_grass",
fill_ratio   = 0.001, --amount of mobs to spawn 
max_speed    = 3,

drop         = "default:glass",

})]]--

register_mob_water("fish", {
--self params
collisionbox = {-0.5, -0.5, -0.5, 0.5, 0.5, 0.5},
visual       = "mesh",
mesh         = "fish.x",
textures     = {"fish_tail.png","fish_body.png"},
dir          = 90,
size         = 1,

--animation params
normal_speed = 80,
stand_start  = 20,
stand_end    = 100,
walk_start   = 20,
walk_end     = 100,

--world/behavior params
hostile      = false,
spawn_on     = "default:dirt_with_grass",
scarcity     = 3000, --the higher the less mobs to spawn 
max_speed    = 3,

drop         = "default:glass",

})


register_mob_water("big_fish", {
--self params
collisionbox = {-1, -1, -1, 1, 1, 1},
visual       = "mesh",
mesh         = "fish.x",
textures     = {"fish_tail.png","big_fish_body.png"},
dir          = 90,
size         = 4,

--animation params
normal_speed = 80,
stand_start  = 20,
stand_end    = 100,
walk_start   = 20,
walk_end     = 100,

--world/behavior params
hostile      = true,
chase_rad    = 15,
attack_rad   = 2.5,
health       = 20,
spawn_on     = "default:dirt_with_grass",
scarcity     = 10000, --the higher the less mobs to spawn 
max_speed    = 3,
attack_cooldown = 0.5,
attack_damage = 2,

drop         = "default:glass",

})

player_hurt_table = {}
--play sound on player hurt
minetest.register_on_player_hpchange(function(player, hp_change)
	local health = player:get_hp()
	if health > 0 and hp_change < 0 then
		minetest.sound_play("player_hurt", {
			pos = pos,
			max_hear_distance = 10,
			gain = 0.5,
		})
	elseif health <= 0 and hp_change <= 0 and player_hurt_table[player:get_player_name()] == nil then
		minetest.sound_play("player_death", {
			pos = pos,
			max_hear_distance = 10,
			gain = 0.5,
		})
		--prevent spamming of death sound
		player_hurt_table[player:get_player_name()] = true
	end
end)
--reset the player hurt table to allow hurt sound to play again
minetest.register_on_respawnplayer(function(player)
	if player_hurt_table[player:get_player_name()] ~= nil then
		player_hurt_table[player:get_player_name()] = nil
	end
end)

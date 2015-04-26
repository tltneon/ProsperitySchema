
	local AddConvars = {}
	-- Bloated Zombie
	AddConvars["bloated_health"] = 300
	AddConvars["bloated_damage"] = 20
	AddConvars["bloated_speed"] = 65
	AddConvars["bloated_dist"] = 6000
	AddConvars["bloated_distcheck"] = 7000
	AddConvars["bloated_collide"] = 0
	
	AddConvars["bloated_fleshoninjured"] = 1
	AddConvars["bloated_chanceoninjured"] = 8
	AddConvars["bloated_amountoninjured"] = 6
	
	AddConvars["bloated_fleshondeath"] = 1
	AddConvars["bloated_amountondeath"] = 8
	
	-- Fast Zombie
	AddConvars["fastzombie_health"] = 100
	AddConvars["fastzombie_speed"] = 225
	AddConvars["fastzombie_dist"] = 6000
	AddConvars["fastzombie_distcheck"] = 7000
	AddConvars["fastzombie_collide"] = 0
	
	AddConvars["fastzombie_firstattackdmg"] = 6
	AddConvars["fastzombie_secondattackdmg"] = 6
	
	-- Gore Child
	AddConvars["gorechild_health"] = 20
	AddConvars["gorechild_speed"] = 125
	AddConvars["gorechild_dist"] = 6000
	AddConvars["gorechild_distcheck"] = 7000
	AddConvars["gorechild_collide"] = 0
	
	AddConvars["gorechild_firstattackdmg"] = 2
	AddConvars["gorechild_secondattackdmg"] = 2
	
	-- Giga Gore Child
	AddConvars["giga_health"] = 2000
	AddConvars["giga_damage"] = 20
	AddConvars["giga_speed"] = 105
	AddConvars["giga_dist"] = 6000
	AddConvars["giga_distcheck"] = 7000
	AddConvars["giga_collide"] = 0
	
	AddConvars["giga_throw"] = 1
	AddConvars["giga_amount"] = 1
	AddConvars["giga_cooldown"] = 8
	
	-- Nightmare
	AddConvars["nightmare_health"] = 2000
	AddConvars["nightmare_damage"] = 49
	AddConvars["nightmare_speed"] = 105
	AddConvars["nightmare_dist"] = 6000
	AddConvars["nightmare_distcheck"] = 7000
	AddConvars["nightmare_collide"] = 0
	
	AddConvars["nightmare_slow"] = 1
	AddConvars["nightmare_amount"] = 90
	
	-- The Butcher
	AddConvars["butcher_health"] = 1500
	AddConvars["butcher_damage"] = 49
	AddConvars["butcher_speed"] = 175
	AddConvars["butcher_dist"] = 6000
	AddConvars["butcher_distcheck"] = 7000
	AddConvars["butcher_collide"] = 0
	
	-- The Tickle Monster
	AddConvars["ticklemonster_health"] = 2000
	AddConvars["ticklemonster_damage"] = 25
	AddConvars["ticklemonster_speed"] = 115
	AddConvars["ticklemonster_dist"] = 6000
	AddConvars["ticklemonster_distcheck"] = 7000
	AddConvars["ticklemonster_collide"] = 0
	
	-- PukePus
	AddConvars["pukepus_health"] = 2750
	AddConvars["pukepus_speed"] = 75
	AddConvars["pukepus_dist"] = 6000
	AddConvars["pukepus_distcheck"] = 7000
	AddConvars["pukepus_collide"] = 0
	
	AddConvars["pukepus_fleshperattack"] = 8
	
	-- Flesh Fire
	AddConvars["fleshfire_health"] = 1500
	AddConvars["fleshfire_damage"] = 20
	AddConvars["fleshfire_speed"] = 95
	AddConvars["fleshfire_dist"] = 6000
	AddConvars["fleshfire_distcheck"] = 7000
	AddConvars["fleshfire_collide"] = 0
	
	AddConvars["fleshfire_fire"] = 1
	AddConvars["fleshfire_fireduration"] = 4
	
	for k, v in pairs(AddConvars) do
	CreateConVar(k, v, {FCVAR_SERVER_CAN_EXECUTE, FCVAR_REPLICATED, FCVAR_NOTIFY})
	end
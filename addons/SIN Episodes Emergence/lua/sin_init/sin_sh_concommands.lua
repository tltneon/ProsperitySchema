local ConVars = {}
// QUADRALEX
ConVars["sk_quadralex_health"] = 1500
ConVars["sk_quadralex_dmg_shove"] = 88

// HOPPER
ConVars["sk_hopper_health"] = 180
ConVars["sk_hopper_dmg_slash"] = 12
ConVars["sk_hopper_dmg_spit"] = 16

// LEPERKIN
ConVars["sk_leperkin_health"] = 230
ConVars["sk_leperkin_dmg_slash"] = 15
ConVars["sk_leperkin_dmg_slash_blunt"] = 23
ConVars["sk_leperkin_dmg_spit"] = 19

for k, v in pairs(ConVars) do
	CreateConVar(k, v, {})
end
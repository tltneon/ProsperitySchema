	
	-- Bloated Zombie
	local function Bloated( Panel )
	if !LocalPlayer():IsAdmin() or !LocalPlayer():IsSuperAdmin() then
		Panel:AddControl( "Label", {Text = "You're not an admin!"})
		Panel:ControlHelp("Notice: Admins can only change these options.")
		return
	end
	
	Panel:AddControl("Slider", {Label = "Health:",min = 1,max = 3000,Command = "bloated_health"})
	Panel:ControlHelp("Default Health: 300, Max Health: 3000")
	
	Panel:AddControl("Slider", {Label = "Damage:",min = 1,max = 200,Command = "bloated_damage"})
	Panel:ControlHelp("Default Damage: 20, Max Damage: 200")
	
	Panel:AddControl("Slider", {Label = "Speed:",min = 20,max = 200,Command = "bloated_speed"})
	Panel:ControlHelp("Default Speed: 65, Max Speed: 200 (Speed over the max will cause the zombie not to move)")
	
	Panel:AddControl("Slider", {Label = "Distance to find targets:",min = 500,max = 1000000,Command = "bloated_dist"})
	Panel:ControlHelp("Default Distance: 6000, Max Distance: 1000000, 7 digits")
	
	Panel:AddControl("Slider", {Label = "Distance to chase targets:",min = 600,max = 10000000,Command = "bloated_distcheck"})
	Panel:ControlHelp("Default Distance: 7000, Max Distance: 10000000, 8 digits")
	
	Panel:AddControl("Checkbox", {Label = "Collide", Command = "bloated_collide"})
	Panel:ControlHelp("Default: False (Players and zombies can get stuck on this zombie)")
	
	Panel:AddControl("Checkbox", {Label = "Spew out flesh on death", Command = "bloated_fleshondeath"})
	Panel:ControlHelp("Default: True")
	
	Panel:AddControl("Slider", {Label = "Amount on death",min = 1,max = 24,Command = "bloated_amountondeath"})
	Panel:ControlHelp("Default Amount: 8, Max Amount: 24")
	
	Panel:AddControl("Checkbox", {Label = "Spew out flesh on hit", Command = "bloated_fleshoninjured"})
	Panel:ControlHelp("Default: True")
	
	Panel:AddControl("Slider", {Label = "Amount on injured",min = 1,max = 16,Command = "bloated_amountoninjured"})
	Panel:ControlHelp("Default Amount: 6, Max Amount: 16")
	
	local text = vgui.Create("DLabel")
		text:SetSize(30,50)
		text:SetPos(5,30)
		text:SetText("NOTE: These options take affect when zombies spawn!")
		text:SetMultiline(false)
		Panel:AddPanel(text)
	
	local text = vgui.Create("DLabel")
		text:SetSize(30,50)
		text:SetPos(5,40)
		text:SetText("NOTE: Admins can only change these options!")
		text:SetMultiline(false)
		Panel:AddPanel(text)
	
	end
	
	-- Fast Zombie
	local function FastZombie( Panel )
	if !LocalPlayer():IsAdmin() or !LocalPlayer():IsSuperAdmin() then
		Panel:AddControl( "Label", {Text = "You're not an admin!"})
		Panel:ControlHelp("Notice: Admins can only change these options.")
		return
	end
	
	Panel:AddControl("Slider", {Label = "Health:",min = 1,max = 3000,Command = "fastzombie_health"})
	Panel:ControlHelp("Default Health: 100, Max Health: 3000")
	
	Panel:AddControl("Slider", {Label = "Speed:",min = 20,max = 200,Command = "fastzombie_speed"})
	Panel:ControlHelp("Default Speed: 225, Max Speed: 200 (Speed over the max will cause the zombie not to move)")
	
	Panel:AddControl("Slider", {Label = "Distance to find targets:",min = 500,max = 1000000,Command = "fastzombie_dist"})
	Panel:ControlHelp("Default Distance: 6000, Max Distance: 1000000, 7 digits")
	
	Panel:AddControl("Slider", {Label = "Distance to chase targets:",min = 600,max = 10000000,Command = "fastzombie_distcheck"})
	Panel:ControlHelp("Default Distance: 7000, Max Distance: 10000000, 8 digits")
	
	Panel:AddControl("Checkbox", {Label = "Collide", Command = "fastzombie_collide"})
	Panel:ControlHelp("Default: False (Players and zombies can get stuck on this zombie)")
	
	Panel:AddControl("Slider", {Label = "First hit damage:",min = 1,max = 200,Command = "fastzombie_firstattackdmg"})
	Panel:ControlHelp("Default Damage: 6, Max Damage: 200")
	
	Panel:AddControl("Slider", {Label = "Second hit damage:",min = 1,max = 200,Command = "fastzombie_secondattackdmg"})
	Panel:ControlHelp("Default Damage: 6, Max Damage: 200")
	
	local text = vgui.Create("DLabel")
		text:SetSize(30,50)
		text:SetPos(5,30)
		text:SetText("NOTE: These options take affect when zombies spawn!")
		text:SetMultiline(false)
		Panel:AddPanel(text)
	
	local text = vgui.Create("DLabel")
		text:SetSize(30,50)
		text:SetPos(5,40)
		text:SetText("NOTE: Admins can only change these options!")
		text:SetMultiline(false)
		Panel:AddPanel(text)
	
	end
	
	-- Gore Child
	local function GoreChild( Panel )
	if !LocalPlayer():IsAdmin() or !LocalPlayer():IsSuperAdmin() then
		Panel:AddControl( "Label", {Text = "You're not an admin!"})
		Panel:ControlHelp("Notice: Admins can only change these options.")
		return
	end
	
	Panel:AddControl("Slider", {Label = "Health:",min = 1,max = 3000,Command = "gorechild_health"})
	Panel:ControlHelp("Default Health: 20, Max Health: 3000")
	
	Panel:AddControl("Slider", {Label = "Speed:",min = 20,max = 200,Command = "gorechild_speed"})
	Panel:ControlHelp("Default Speed: 125, Max Speed: 200 (Speed over the max will cause the zombie not to move)")
	
	Panel:AddControl("Slider", {Label = "Distance to find targets:",min = 500,max = 1000000,Command = "gorechild_dist"})
	Panel:ControlHelp("Default Distance: 6000, Max Distance: 1000000, 7 digits")
	
	Panel:AddControl("Slider", {Label = "Distance to chase targets:",min = 600,max = 10000000,Command = "gorechild_distcheck"})
	Panel:ControlHelp("Default Distance: 7000, Max Distance: 10000000, 8 digits")
	
	Panel:AddControl("Checkbox", {Label = "Collide", Command = "gorechild_collide"})
	Panel:ControlHelp("Default: False (Players and zombies can get stuck on this zombie)")
	
	Panel:AddControl("Slider", {Label = "First hit damage:",min = 1,max = 200,Command = "gorechild_firstattackdmg"})
	Panel:ControlHelp("Default Damage: 2, Max Damage: 200")
	
	Panel:AddControl("Slider", {Label = "Second hit damage:",min = 1,max = 200,Command = "gorechild_secondattackdmg"})
	Panel:ControlHelp("Default Damage: 2, Max Damage: 200")
	
	local text = vgui.Create("DLabel")
		text:SetSize(30,50)
		text:SetPos(5,30)
		text:SetText("NOTE: These options take affect when zombies spawn!")
		text:SetMultiline(false)
		Panel:AddPanel(text)
	
	local text = vgui.Create("DLabel")
		text:SetSize(30,50)
		text:SetPos(5,40)
		text:SetText("NOTE: Admins can only change these options!")
		text:SetMultiline(false)
		Panel:AddPanel(text)
	
	end
	
	-- Giga Gore Child
	local function GigaGoreChild( Panel )
	if !LocalPlayer():IsAdmin() or !LocalPlayer():IsSuperAdmin() then
		Panel:AddControl( "Label", {Text = "You're not an admin!"})
		Panel:ControlHelp("Notice: Admins can only change these options.")
		return
	end
	
	Panel:AddControl("Slider", {Label = "Health:",min = 1,max = 10000,Command = "giga_health"})
	Panel:ControlHelp("Default Health: 20, Max Health: 10000")
	
	Panel:AddControl("Slider", {Label = "Damage:",min = 20,max = 200,Command = "giga_damage"})
	Panel:ControlHelp("Default Damage: 20, Max Damage: 200)")
	
	Panel:AddControl("Slider", {Label = "Speed:",min = 20,max = 200,Command = "giga_speed"})
	Panel:ControlHelp("Default Speed: 125, Max Speed: 200 (Speed over the max will cause the zombie not to move)")
	
	Panel:AddControl("Slider", {Label = "Distance to find targets:",min = 500,max = 1000000,Command = "giga_dist"})
	Panel:ControlHelp("Default Distance: 6000, Max Distance: 1000000, 7 digits")
	
	Panel:AddControl("Slider", {Label = "Distance to chase targets:",min = 600,max = 10000000,Command = "giga_distcheck"})
	Panel:ControlHelp("Default Distance: 7000, Max Distance: 10000000, 8 digits")
	
	Panel:AddControl("Checkbox", {Label = "Collide", Command = "giga_collide"})
	Panel:ControlHelp("Default: False (Players and zombies can get stuck on this zombie)")
	
	Panel:AddControl("Checkbox", {Label = "Can throw gore childs", Command = "giga_throw"})
	Panel:ControlHelp("Default: True")
	
	Panel:AddControl("Slider", {Label = "Amount of gore childs",min = 1,max = 3,Command = "giga_amount"})
	Panel:ControlHelp("Default Amount: 1, Max Amount: 3")
	
	Panel:AddControl("Slider", {Label = "Delay till next throw",min = 2,max = 60,Command = "giga_cooldown"})
	Panel:ControlHelp("Default: 8, Max: 60 (Delay is in seconds)")
	
	local text = vgui.Create("DLabel")
		text:SetSize(30,50)
		text:SetPos(5,30)
		text:SetText("NOTE: These options take affect when zombies spawn!")
		text:SetMultiline(false)
		Panel:AddPanel(text)
	
	local text = vgui.Create("DLabel")
		text:SetSize(30,50)
		text:SetPos(5,40)
		text:SetText("NOTE: Admins can only change these options!")
		text:SetMultiline(false)
		Panel:AddPanel(text)
	
	end
	
	-- Nightmare
	local function Nightmare( Panel )
	if !LocalPlayer():IsAdmin() or !LocalPlayer():IsSuperAdmin() then
		Panel:AddControl( "Label", {Text = "You're not an admin!"})
		Panel:ControlHelp("Notice: Admins can only change these options.")
		return
	end
	
	Panel:AddControl("Slider", {Label = "Health:",min = 1,max = 10000,Command = "nightmare_health"})
	Panel:ControlHelp("Default Health: 2000, Max Health: 10000")
	
	Panel:AddControl("Slider", {Label = "Damage:",min = 1,max = 200,Command = "nightmare_damage"})
	Panel:ControlHelp("Default Damage: 49, Max Damage: 200")
	
	Panel:AddControl("Slider", {Label = "Speed:",min = 20,max = 200,Command = "nightmare_speed"})
	Panel:ControlHelp("Default Speed: 105, Max Speed: 200 (Speed over the max will cause the zombie not to move)")
	
	Panel:AddControl("Slider", {Label = "Distance to find targets:",min = 500,max = 1000000,Command = "nightmare_dist"})
	Panel:ControlHelp("Default Distance: 6000, Max Distance: 1000000, 7 digits")
	
	Panel:AddControl("Slider", {Label = "Distance to chase targets:",min = 600,max = 10000000,Command = "nightmare_distcheck"})
	Panel:ControlHelp("Default Distance: 7000, Max Distance: 10000000, 8 digits")
	
	Panel:AddControl("Checkbox", {Label = "Collide", Command = "nightmare_collide"})
	Panel:ControlHelp("Default: False (Players and zombies can get stuck on this zombie)")
	
	Panel:AddControl("Checkbox", {Label = "Can slow on hit", Command = "nightmare_slow"})
	Panel:ControlHelp("Default: True")
	
	Panel:AddControl("Slider", {Label = "Slow Amount",min = 15,max = 255,Command = "nightmare_amount"})
	Panel:ControlHelp("Default Amount: 90, Max Amount: 190 (Walkspeed)")
	
	local text = vgui.Create("DLabel")
		text:SetSize(30,50)
		text:SetPos(5,30)
		text:SetText("NOTE: These options take affect when zombies spawn!")
		text:SetMultiline(false)
		Panel:AddPanel(text)
	
	local text = vgui.Create("DLabel")
		text:SetSize(30,50)
		text:SetPos(5,40)
		text:SetText("NOTE: Admins can only change these options!")
		text:SetMultiline(false)
		Panel:AddPanel(text)
	
	end
	
	-- The Butcher
	local function Butcher( Panel )
	if !LocalPlayer():IsAdmin() or !LocalPlayer():IsSuperAdmin() then
		Panel:AddControl( "Label", {Text = "You're not an admin!"})
		Panel:ControlHelp("Notice: Admins can only change these options.")
		return
	end
	
	Panel:AddControl("Slider", {Label = "Health:",min = 1,max = 10000,Command = "butcher_health"})
	Panel:ControlHelp("Default Health: 1500, Max Health: 10000")
	
	Panel:AddControl("Slider", {Label = "Damage:",min = 1,max = 200,Command = "butcher_damage"})
	Panel:ControlHelp("Default Damage: 20, Max Damage: 200")
	
	Panel:AddControl("Slider", {Label = "Speed:",min = 20,max = 200,Command = "butcher_speed"})
	Panel:ControlHelp("Default Speed: 175, Max Speed: 200 (Speed over the max will cause the zombie not to move)")
	
	Panel:AddControl("Slider", {Label = "Distance to find targets:",min = 500,max = 1000000,Command = "butcher_dist"})
	Panel:ControlHelp("Default Distance: 6000, Max Distance: 1000000, 7 digits")
	
	Panel:AddControl("Slider", {Label = "Distance to chase targets:",min = 600,max = 10000000,Command = "butcher_distcheck"})
	Panel:ControlHelp("Default Distance: 7000, Max Distance: 10000000, 8 digits")
	
	Panel:AddControl("Checkbox", {Label = "Collide", Command = "butcher_collide"})
	Panel:ControlHelp("Default: False (Players and zombies can get stuck on this zombie)")
	
	local text = vgui.Create("DLabel")
		text:SetSize(30,50)
		text:SetPos(5,30)
		text:SetText("NOTE: These options take affect when zombies spawn!")
		text:SetMultiline(false)
		Panel:AddPanel(text)
	
	local text = vgui.Create("DLabel")
		text:SetSize(30,50)
		text:SetPos(5,40)
		text:SetText("NOTE: Admins can only change these options!")
		text:SetMultiline(false)
		Panel:AddPanel(text)
	
	end
	
	-- Tickle Monster
	local function TickleMonster( Panel )
	if !LocalPlayer():IsAdmin() or !LocalPlayer():IsSuperAdmin() then
		Panel:AddControl( "Label", {Text = "You're not an admin!"})
		Panel:ControlHelp("Notice: Admins can only change these options.")
		return
	end
	
	Panel:AddControl("Slider", {Label = "Health:",min = 1,max = 10000,Command = "ticklemonster_health"})
	Panel:ControlHelp("Default Health: 2000, Max Health: 10000")
	
	Panel:AddControl("Slider", {Label = "Damage:",min = 1,max = 200,Command = "ticklemonster_damage"})
	Panel:ControlHelp("Default Damage: 25, Max Damage: 200")
	
	Panel:AddControl("Slider", {Label = "Speed:",min = 20,max = 200,Command = "ticklemonster_speed"})
	Panel:ControlHelp("Default Speed: 115, Max Speed: 200 (Speed over the max will cause the zombie not to move)")
	
	Panel:AddControl("Slider", {Label = "Distance to find targets:",min = 500,max = 1000000,Command = "ticklemonster_dist"})
	Panel:ControlHelp("Default Distance: 6000, Max Distance: 1000000, 7 digits")
	
	Panel:AddControl("Slider", {Label = "Distance to chase targets:",min = 600,max = 10000000,Command = "ticklemonster_distcheck"})
	Panel:ControlHelp("Default Distance: 7000, Max Distance: 10000000, 8 digits")
	
	Panel:AddControl("Checkbox", {Label = "Collide", Command = "ticklemonster_collide"})
	Panel:ControlHelp("Default: False (Players and zombies can get stuck on this zombie)")
	
	local text = vgui.Create("DLabel")
		text:SetSize(30,50)
		text:SetPos(5,30)
		text:SetText("NOTE: These options take affect when zombies spawn!")
		text:SetMultiline(false)
		Panel:AddPanel(text)
	
	local text = vgui.Create("DLabel")
		text:SetSize(30,50)
		text:SetPos(5,40)
		text:SetText("NOTE: Admins can only change these options!")
		text:SetMultiline(false)
		Panel:AddPanel(text)
	
	end
	
	-- PukePus
	local function PukePus( Panel )
	if !LocalPlayer():IsAdmin() or !LocalPlayer():IsSuperAdmin() then
		Panel:AddControl( "Label", {Text = "You're not an admin!"})
		Panel:ControlHelp("Notice: Admins can only change these options.")
		return
	end
	
	Panel:AddControl("Slider", {Label = "Health:",min = 1,max = 10000,Command = "pukepus_health"})
	Panel:ControlHelp("Default Health: 2750, Max Health: 10000")

	Panel:AddControl("Slider", {Label = "Speed:",min = 20,max = 200,Command = "pukepus_speed"})
	Panel:ControlHelp("Default Speed: 75, Max Speed: 200 (Speed over the max will cause the zombie not to move)")
	
	Panel:AddControl("Slider", {Label = "Distance to find targets:",min = 500,max = 1000000,Command = "pukepus_dist"})
	Panel:ControlHelp("Default Distance: 6000, Max Distance: 1000000, 7 digits")
	
	Panel:AddControl("Slider", {Label = "Distance to chase targets:",min = 600,max = 10000000,Command = "pukepus_distcheck"})
	Panel:ControlHelp("Default Distance: 7000, Max Distance: 10000000, 8 digits")
	
	Panel:AddControl("Checkbox", {Label = "Collide", Command = "pukepus_collide"})
	Panel:ControlHelp("Default: False (Players and zombies can get stuck on this zombie)")
	
	Panel:AddControl("Slider", {Label = "Flesh per attack",min = 1,max = 18,Command = "pukepus_fleshperattack"})
	Panel:ControlHelp("Default: 8, Max: 18")
	
	local text = vgui.Create("DLabel")
		text:SetSize(30,50)
		text:SetPos(5,30)
		text:SetText("NOTE: These options take affect when zombies spawn!")
		text:SetMultiline(false)
		Panel:AddPanel(text)
	
	local text = vgui.Create("DLabel")
		text:SetSize(30,50)
		text:SetPos(5,40)
		text:SetText("NOTE: Admins can only change these options!")
		text:SetMultiline(false)
		Panel:AddPanel(text)
	
	spawnmenu.AddToolMenuOption( "NextBot Zombies", "Zombie Survival", "PukePus", "PukePus", "", "", PukePus, {} )
	hook.Add( "PopulateToolMenu", "PukePus", PukePus )
	
	end
	
	-- Flesh Fire
	local function FleshFire( Panel )
	if !LocalPlayer():IsAdmin() or !LocalPlayer():IsSuperAdmin() then
		Panel:ControlHelp("Notice: Admins can only change these options.")
		return
	end
	
	Panel:AddControl("Slider", {Label = "Health:",min = 1,max = 10000,Command = "fleshfire_health"})
	Panel:ControlHelp("Default Health: 1500, Max Health: 10000")

	Panel:AddControl("Slider", {Label = "Speed:",min = 20,max = 200,Command = "fleshfire_speed"})
	Panel:ControlHelp("Default Speed: 95, Max Speed: 200 (Speed over the max will cause the zombie not to move)")
	
	Panel:AddControl("Slider", {Label = "Distance to find targets:",min = 500,max = 1000000,Command = "fleshfire_dist"})
	Panel:ControlHelp("Default Distance: 6000, Max Distance: 1000000, 7 digits")
	
	Panel:AddControl("Slider", {Label = "Distance to chase targets:",min = 600,max = 10000000,Command = "fleshfire_distcheck"})
	Panel:ControlHelp("Default Distance: 7000, Max Distance: 10000000, 8 digits")
	
	Panel:AddControl("Checkbox", {Label = "Collide", Command = "fleshfire_collide"})
	Panel:ControlHelp("Default: False (Players and zombies can get stuck on this zombie)")
	
	Panel:AddControl("Checkbox", {Label = "Can set on fire", Command = "fleshfire_fire"})
	Panel:ControlHelp("Default: True")
	
	Panel:AddControl("Slider", {Label = "Fire duration",min = 1,max = 60,Command = "fleshfire_fireduration"})
	Panel:ControlHelp("Default: 4, Max: 60 (Duration is in seconds)")
	
	local text = vgui.Create("DLabel")
		text:SetSize(30,50)
		text:SetPos(5,30)
		text:SetText("NOTE: These options take affect when zombies spawn!")
		text:SetMultiline(false)
		Panel:AddPanel(text)
	
	local text = vgui.Create("DLabel")
		text:SetSize(30,50)
		text:SetPos(5,40)
		text:SetText("NOTE: Admins can only change these options!")
		text:SetMultiline(false)
		Panel:AddPanel(text)
	end
	
-- BOSS --
	function FleshFireMenu()	
	spawnmenu.AddToolMenuOption( "NextBot Zombies", "Zombie Survival", "Flesh Fire", "Flesh Fire", "", "", FleshFire, {} )
	end
	hook.Add( "PopulateToolMenu", "FleshFireMenu", FleshFireMenu )
	
	function PukePusMenu()	
	spawnmenu.AddToolMenuOption( "NextBot Zombies", "Zombie Survival", "PukePus", "PukePus", "", "", PukePus, {} )
	end
	hook.Add( "PopulateToolMenu", "PukePusMenu", PukePusMenu )
	
	function TickleMonsterMenu()	
	spawnmenu.AddToolMenuOption( "NextBot Zombies", "Zombie Survival", "Tickle Monster", "Tickle Monster", "", "", TickleMonster, {} )
	end
	hook.Add( "PopulateToolMenu", "TickleMonsterMenu", TickleMonsterMenu )
	
	function ButcherMenu()	
	spawnmenu.AddToolMenuOption( "NextBot Zombies", "Zombie Survival", "The Butcher", "The Butcher", "", "", Butcher, {} )
	end
	hook.Add( "PopulateToolMenu", "ButcherMenu", ButcherMenu )
	
	function NightmareMenu()	
	spawnmenu.AddToolMenuOption( "NextBot Zombies", "Zombie Survival", "Nightmare", "Nightmare", "", "", Nightmare, {} )
	end
	hook.Add( "PopulateToolMenu", "NightmareMenu", NightmareMenu )
	
	function GigaGoreChildMenu()	
	spawnmenu.AddToolMenuOption( "NextBot Zombies", "Zombie Survival", "Giga Gore Child", "Giga Gore Child", "", "", GigaGoreChild, {} )
	end
	hook.Add( "PopulateToolMenu", "GigaGoreChildMenu", GigaGoreChildMenu )
	
-- ZOMBIES --
	function GoreChildMenu()	
	spawnmenu.AddToolMenuOption( "NextBot Zombies", "Zombie Survival", "Gore Child", "Gore Child", "", "", GoreChild, {} )
	end
	hook.Add( "PopulateToolMenu", "GoreChildMenu", GoreChildMenu )
	
	function BloatedMenu()	
	spawnmenu.AddToolMenuOption( "NextBot Zombies", "Zombie Survival", "Bloated Zombie", "Bloated Zombie", "", "", Bloated, {} )
	end
	hook.Add( "PopulateToolMenu", "BloatedMenu", BloatedMenu )
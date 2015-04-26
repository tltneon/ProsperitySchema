killicons_color = Color( 255, 0, 0, 0 )

local function AddKillicon(class, material)
	killicon.Add(class,material,killicons_color)
end

if CLIENT then
-- Zombies
killicon.Add("poison_flesh", "killicons/poison_flesh", color_white)

killicon.Add("npc_nextbot_child", "killicons/nextbot_killicon", color_white)
killicon.Add("npc_nextbot_bloated", "killicons/nextbot_killicon", color_white)
killicon.Add("npc_nextbot_fast", "killicons/nextbot_killicon", color_white)

killicon.Add("npc_nextbot_fleshfire", "killicons/nextbot_killicon", color_white)
killicon.Add("npc_nextbot_ticklemonster", "killicons/nextbot_killicon", color_white)
killicon.Add("npc_nextbot_butcher", "killicons/nextbot_killicon", color_white)
killicon.Add("npc_nextbot_gigagore", "killicons/nextbot_killicon", color_white)
killicon.Add("npc_nextbot_nightmare", "killicons/nextbot_killicon", color_white)
killicon.Add("npc_nextbot_pukepus", "killicons/nextbot_killicon", color_white)

--Kill Messages
language.Add("poison_flesh", "Poison Flesh")

language.Add("npc_nextbot_bloated", "Bloated Zombie")
language.Add("npc_nextbot_child", "Gore Child")
language.Add("npc_nextbot_fast", "Fast Zombie")

language.Add("npc_nextbot_fleshfire", "(BOSS) Flesh Fire")
language.Add("npc_nextbot_gigagore", "(BOSS) Giga Gore Child")
language.Add("npc_nextbot_butcher", "(BOSS) The Butcher")
language.Add("npc_nextbot_ticklemonster", "(BOSS) Tickle Monster")
language.Add("npc_nextbot_nightmare", "(BOSS) Nightmare")
language.Add("npc_nextbot_pukepus", "(BOSS) PukePus")
end
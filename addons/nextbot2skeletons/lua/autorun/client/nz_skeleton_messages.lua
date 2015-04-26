killicons_color = Color( 255, 0, 0, 0 )

local function AddKillicon(class, material)
	killicon.Add(class,material,killicons_color)
end

if CLIENT then
-- Kill Messages
language.Add("nz_skeleton", "Skeleton")
language.Add("nz_skeleton_summoner", "Summoner Skeleton")
language.Add("nz_skeleton_inferno", "Inferno Skeleton")
end
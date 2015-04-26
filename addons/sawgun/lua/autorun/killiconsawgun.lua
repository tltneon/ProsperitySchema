
local icol = Color( 255, 255, 255, 255 ) 
if CLIENT then

	killicon.Add( "thrown_sawblade", "vgui/killicon/thrown_sawblade", icol )
	killicon.Add( "the_sawgun", "vgui/killicon/thrown_sawblade", icol )
end

if SERVER then

	if GetConVar("Sawblade_rotate") == nil then
		CreateConVar("Sawblade_rotate", "1", { FCVAR_ARCHIVE }, "Do you want the Sawblade to rotate ?")
	end
	
	if GetConVar("Sawblade_collide") == nil then
		CreateConVar("Sawblade_collide", "1", { FCVAR_REPLICATED, FCVAR_NOTIFY }, "Do you want the Sawblade to collide with players ?")
	end
	
	if GetConVar("Sawblade_damage") == nil then
		CreateConVar("Sawblade_damage", "100", { FCVAR_REPLICATED, FCVAR_NOTIFY }, "How much damage you want the Sawblade to have on impact ?")
	end
	
end
include('shared.lua')

language.Add("npc_xenomorph", "Xenomorph")
killicon.Add("npc_xenomorph","HUD/killicons/default",Color ( 255, 80, 0, 255 ) )

function ENT:Initialize()	
end

function ENT:Draw()
	self.Entity:DrawModel()
end
include('shared.lua')

ENT.RenderGroup = RENDERGROUP_BOTH

function ENT:Draw()
	self.Entity:DrawModel()
end

language.Add("npc_nextbot_boss2", "Poison Monstrosity")
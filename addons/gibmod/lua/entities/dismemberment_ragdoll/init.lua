AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")

include("shared.lua")
	
function ENT:Initialize()
	self:SetModel("models/kleiner.mdl")
	/*
	self.ragdoll = ents.Create("prop_ragdoll")	
	self.ragdoll:SetPos(self:GetPos())
	self.ragdoll:SetAngles(self:GetAngles())
	self.ragdoll:SetModel("models/kleiner.mdl")
	self.ragdoll:Spawn()
	self:SetNoDraw(true)
	self:SetNetworkedEntity("dismembermentragdoll", self.ragdoll)
	self:SetParent(self.ragdoll)
	self:AddEffects(EF_BONEMERGE)
	*/
end

function ENT:SpawnFunction(ply, tr)
    if not tr.Hit then return end
    
    local ent = ents.Create(ClassName)
    ent:SetPos(tr.HitPos)
    ent:Spawn()
    ent:Activate()
end

function ENT:Think()
	
end
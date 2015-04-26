AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")

include("shared.lua")

util.AddNetworkString("Kill")
	
function ENT:Initialize()
	self:SetModel(self:GetNWString("Gibmdl"))
    self:PhysicsInit(SOLID_VPHYSICS) 
    self:SetSolid(SOLID_VPHYSICS)
	self:SetMoveType(MOVETYPE_VPHYSICS)
	
	if GetConVar("dismemberment_gibphys"):GetBool() then
		self:SetCollisionGroup(COLLISION_GROUP_NONE)
	else
		self:SetCollisionGroup(COLLISION_GROUP_WORLD)
	end
	
	self:DrawShadow(true)
	self:SetHealth(100)
	
	local phys = self:GetPhysicsObject()
	
	if phys:IsValid() then
		phys:Wake()
		phys:SetMaterial("flesh")
		phys:SetAngles(Angle(math.random(0, 360), math.random(0, 360), math.random(0, 360)))
		phys:SetVelocity(VectorRand():GetNormal() * math.random(100, 150))//self:GetPos():GetNormal() * math.Rand(150, 200))
	end
	
	self.Timer = CurTime() + 100
	self.EffectTimer = CurTime() + math.random(2, 6)
end

function ENT:SpawnFunction(ply, tr)
    if not tr.Hit then return end
    
    local ent = ents.Create(ClassName)
    ent:SetPos(tr.HitPos)
    ent:Spawn()
    ent:Activate()
end
	
function ENT:PhysicsCollide(data, physobj)
	if data.Speed > 30 and data.DeltaTime > 0.1 then//if math.random(1, 8) == 1 then
		sound.Play("physics/flesh/flesh_squishy_impact_hard" .. math.random(1,4) .. ".wav", self:GetPos(), 75, 100, 1)
		util.Decal("Blood", data.HitPos + data.HitNormal, data.HitPos - data.HitNormal)
	end
end

function ENT:OnTakeDamage(dmg)
	self:SetHealth(self:Health() - dmg:GetDamage())
	
	ParticleEffect("blood_impact_red_01", self:GetPos(), self:GetAngles(), self)
	
	if self:Health() <= 0 and self:IsValid() then
		self:Remove()
	end
end

function ENT:Think()
	if CurTime() > self.Timer and self:IsValid() then
		self:Remove()
	end
	
	if CurTime() < self.EffectTimer and math.random(1, 2) == 1 then
		ParticleEffect("blood_impact_red_01", self:GetPos(), self:GetAngles(), self)
	end
end
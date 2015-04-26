AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")

include("shared.lua")

util.AddNetworkString("Kill")

local gibs = {"models/props_junk/watermelon01_chunk02a.mdl",
	"models/props_junk/watermelon01_chunk02b.mdl",
	"models/props_junk/watermelon01_chunk02c.mdl"}
	
local bodygibs = {"models/props_junk/watermelon01_chunk02a.mdl",
	"models/props_junk/watermelon01_chunk02b.mdl",
	"models/props_junk/watermelon01_chunk02c.mdl",
	"models/Gibs/HGIBS_scapula.mdl",
	"models/Gibs/HGIBS_rib.mdl"}

function ENT:Initialize()
	if self:GetNWBool("IsBodyGib") then
		self:SetModel(table.Random(bodygibs))
	else
		self:SetModel(table.Random(gibs))
	end
	
	if self:GetNWInt("GibType") == 1 or self:GetNWInt("GibType") == nil then
		self:SetMaterial("models/flesh")
	elseif self:GetNWInt("GibType") == 2 then
		self:SetMaterial("models/AntLion/antlion_innards")
	elseif self:GetNWInt("GibType") == 3 then
		self:SetMaterial("models/flesh")
	end
    self:PhysicsInit(SOLID_VPHYSICS) 
    self:SetSolid(SOLID_VPHYSICS)
	self:SetMoveType(MOVETYPE_VPHYSICS)
	self:SetCollisionGroup(COLLISION_GROUP_WORLD)
	self:DrawShadow(true)
	self:SetHealth(5)
	
	local phys = self:GetPhysicsObject()
	
	if phys:IsValid() then
		phys:Wake()
		phys:SetMaterial("flesh")
		phys:SetAngles(Angle(math.random(0, 360), math.random(0, 360), math.random(0, 360)))
		phys:SetVelocity(VectorRand():GetNormal() * math.random(100, 150))//self:GetPos():GetNormal() * math.Rand(150, 200))
	end
	
	self.Timer = CurTime() + math.random(20, 40)
end

function ENT:SpawnFunction(ply, tr)
    if not tr.Hit then return end
    
    local ent = ents.Create(ClassName)
    ent:SetPos(tr.HitPos)
    ent:Spawn()
    ent:Activate()
end
	
function ENT:PhysicsCollide(data, physobj)
	if math.random(1, 8) == 1 then
		sound.Play("physics/flesh/flesh_squishy_impact_hard" .. math.random(1,4) .. ".wav", self:GetPos(), 75, 100, 1)
	end
end

function ENT:OnTakeDamage(dmg)
	self:SetHealth(self:Health() - dmg:GetDamage())
	
	/*
	net.Start("Kill")
	net.WriteEntity(self)
	net.Broadcast()
	*/
	
	if self:Health() <= 0 and self:IsValid() then
		self:Remove()
	end
end

function ENT:Think()
	if CurTime() > self.Timer and self:IsValid() then
		self:Remove()
	end
end
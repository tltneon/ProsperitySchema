AddCSLuaFile()

ENT.Type = "anim"
ENT.Contact			= ""
ENT.Purpose			= ""
ENT.Instructions	= ""

ENT.Spawnable 		= false
ENT.AdminSpawnable 	= false



--stats
ENT.PrintName		= "Gibs"
ENT.Category 		= ""

ENT.Model1 = ("models/Gibs/HGIBS.mdl")
ENT.Model2 = ("models/Gibs/HGIBS_rib.mdl")
ENT.Model3 = ("models/Gibs/HGIBS_scapula.mdl")
ENT.Model4 = ("models/Gibs/HGIBS_spine.mdl")

if SERVER then

	function ENT:Initialize()
	self:Precache()
	
		local model = math.random(1,4)
	if model == 1 then self:SetModel(self.Model1) else
	if model == 2 then self:SetModel(self.Model2) end
	if model == 3 then self:SetModel(self.Model3) end
	if model == 4 then self:SetModel(self.Model4) end
	end
	
		self:SetMaterial("models/flesh")
		self:PhysicsInit( SOLID_VPHYSICS )
		self:SetMoveType( MOVETYPE_VPHYSICS )
		self:SetSolid( SOLID_VPHYSICS )
		
		self:SetCollisionGroup(COLLISION_GROUP_DEBRIS)
	 
			local phys = self:GetPhysicsObject()
		if (phys:IsValid()) then
			phys:EnableMotion( true )
		end
		
	timer.Simple(3, function() 
	if  ( self:IsValid() ) then
	self:Remove()
	end
	end)
	
	end
	
	function ENT:Precache()
	util.PrecacheModel(self.Model1)
	util.PrecacheModel(self.Model2)
	util.PrecacheModel(self.Model3)
	util.PrecacheModel(self.Model4)
	end

end

function ENT:Think()
end

function ENT:OnInjured(dmginfo)
dmginfo:ScaleDamage(0)
end

function ENT:PhysicsCollide(data, physobj)
if  ( self:IsValid() ) then
local sounds = {}
	sounds[1] = ("physics/flesh/flesh_squishy_impact_hard1.wav")
	sounds[2] = ("physics/flesh/flesh_squishy_impact_hard2.wav")
	sounds[3] = ("physics/flesh/flesh_squishy_impact_hard3.wav")
	sounds[4] = ("physics/flesh/flesh_squishy_impact_hard4.wav")
	self:EmitSound( sounds[math.random(1,4)], 55 )
end
end

if CLIENT then

	function ENT:Draw()
		self:DrawModel()
	end
end

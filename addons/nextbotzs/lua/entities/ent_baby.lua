AddCSLuaFile()

ENT.Type = "anim"
ENT.Contact			= ""
ENT.Purpose			= ""
ENT.Instructions	= ""

ENT.Spawnable 		= false
ENT.AdminSpawnable 	= false



--stats
ENT.PrintName		= "Doll"
ENT.Category 		= ""

ENT.Model = ("models/props_c17/doll01.mdl")

if SERVER then
	function ENT:Initialize()
	 
		self:SetModel(self.Model)
		self:SetHealth(50)
		self:PhysicsInit( SOLID_VPHYSICS )
		self:SetSolid( SOLID_VPHYSICS )

			local phys = self:GetPhysicsObject()
		if (phys:IsValid()) then
			phys:EnableMotion( true )
		end
		
		timer.Simple(2.5, function() 
			local zombie = ents.Create("npc_nextbot_child")
			if not ( self:IsValid() && self:Health() > 0 ) then return end
			if zombie:IsValid() then 
			zombie:SetPos(self:GetPos() + Vector(0, 0, 8))
			zombie:Spawn()
			self:Remove()
			end
		end)
		
	end
end

function ENT:Think()
end

function ENT:OnKilled(dmginfo)
self:EmitSound("ambient/creatures/town_child_scream1.wav", 75, 65)
end
	
function ENT:OnInjured(dmginfo)
dmginfo:ScaleDamage(0)
end

if CLIENT then

	function ENT:Draw()
		self:DrawModel()
	end
end

AddCSLuaFile()

ENT.Type = "anim"
ENT.Contact			= ""
ENT.Purpose			= ""
ENT.Instructions	= ""

ENT.Spawnable 		= false
ENT.AdminSpawnable 	= false



--stats
ENT.PrintName		= "Zombine Grenade"
ENT.Category 		= ""

ENT.Model = ("models/weapons/w_grenade.mdl")

if SERVER then
	function ENT:Initialize()
	 
		self:SetModel(self.Model)
		self:SetHealth(999999)
		self:PhysicsInit( SOLID_VPHYSICS )
		self:SetSolid( SOLID_VPHYSICS )
		
			local phys = self:GetPhysicsObject()
		if (phys:IsValid()) then
			phys:EnableMotion( true )
		end
		
		timer.Simple(2.5, function() 
			if ( self:IsValid() ) then 
			
			local explode = ents.Create("env_explosion")
	explode:SetPos(self:GetPos())
	explode:Spawn()
	explode:SetKeyValue( "iMagnitude", 60 )
	explode:SetOwner(self:GetOwner())	
	explode:Fire( "Explode", 1, 0 )
	explode:EmitSound("ambient/fire/gascan_ignite1.wav")	
			
			self:Remove()
			end
		end)
		
	end
end

function ENT:Think()
end

if CLIENT then

	function ENT:Draw()
		self:DrawModel()
	end
end

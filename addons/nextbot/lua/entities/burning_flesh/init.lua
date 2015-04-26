AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")

include("shared.lua")

ENT.Damage = 4

ENT.Type = "anim"

function ENT:Initialize()

	self:DrawShadow(false)
	self:PhysicsInitSphere(1)
	self:SetSolid(SOLID_VPHYSICS)
	self:SetCollisionGroup(COLLISION_GROUP_PROJECTILE)

	local phys = self:GetPhysicsObject()
	if phys:IsValid() then
		phys:SetMass(1)
		phys:SetBuoyancyRatio(0.002)
		phys:EnableMotion(true)
		phys:Wake()
	end
	
	timer.Simple(2, function() 
	if  ( self:IsValid() ) then	
	self:Remove()
	end
	end)
	
end

function ENT:Think()
end

function ENT:Explode()
end

function ENT:PhysicsCollide(data, physobj)
if  ( self:IsValid() ) then
	if SERVER then
	local sounds = {}
			sounds[1] = ("physics/flesh/flesh_squishy_impact_hard1.wav")
			sounds[2] = ("physics/flesh/flesh_squishy_impact_hard2.wav")
			sounds[3] = ("physics/flesh/flesh_squishy_impact_hard3.wav")
			sounds[4] = ("physics/flesh/flesh_squishy_impact_hard4.wav")
			self:EmitSound( sounds[math.random(1,4)], 60 )

	local ent = data.HitEntity
	if ent and ent:IsValid() and ent:IsPlayer() then
	
		local damage = DamageInfo()
		damage:SetDamageType(DMG_BURN)
		ent:TakeDamageInfo(damage, self)
		ent:TakeDamage(self.Damage, self)
		
		local painsounds = {}
			painsounds[1] = ("player/pl_pain7.wav")
			painsounds[2] = ("player/pl_pain6.wav")
			painsounds[3] = ("player/pl_pain5.wav")
			ent:EmitSound( painsounds[math.random(1,3)] )
		
		self:Remove()
	else
		local normal = data.OurOldVelocity:GetNormalized()
		local DotProduct = data.HitNormal:Dot(normal * -1)

		physobj:SetVelocityInstantaneous((2 * DotProduct * data.HitNormal + normal) * math.max(100, data.Speed) * 0.9)
	end
	
	if ent and ent:IsValid() and ent:GetClass() == "prop_physics" then
	ent:TakeDamage(2, self)	
	end
	
	end
	end
end

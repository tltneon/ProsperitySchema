AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include("shared.lua")

ENT.Type = "anim"
ENT.Contact			= ""
ENT.Purpose			= ""
ENT.Instructions	= ""

ENT.Spawnable 		= false
ENT.AdminSpawnable 	= false



--stats
ENT.PrintName		= "Gibs"
ENT.Category 		= ""

ENT.Model = ("models/Gibs/HGIBS.mdl")

ENT.Damage = 5

if SERVER then

	function ENT:Initialize()
	self:Precache()
	
		self:PhysicsInitSphere(8)
		self:SetSolid(SOLID_VPHYSICS)
		self:SetCollisionGroup(COLLISION_GROUP_PROJECTILE)

	 
			local phys = self:GetPhysicsObject()
		if (phys:IsValid()) then
			phys:EnableMotion( true )
		end
		
	timer.Simple(3, function() 
	if  ( self:IsValid() ) then
	
	local sounds = {}
			sounds[1] = ("physics/flesh/flesh_squishy_impact_hard1.wav")
			sounds[2] = ("physics/flesh/flesh_squishy_impact_hard2.wav")
			sounds[3] = ("physics/flesh/flesh_squishy_impact_hard3.wav")
			sounds[4] = ("physics/flesh/flesh_squishy_impact_hard4.wav")
			self:EmitSound( sounds[math.random(1,4)] )
	
	local bleed = ents.Create("info_particle_system")
		bleed:SetKeyValue("effect_name", "blood_impact_red_01")
		bleed:SetPos(self:GetPos()) 
		bleed:SetBloodColor(BLOOD_COLOR_GREEN) 
		bleed:Spawn()
		bleed:Activate() 
		bleed:Fire("Start", "", 0)
		bleed:Fire("Kill", "", 0.2)
	
	self:Remove()
	end
	end)
	
	end
	
	function ENT:Precache()
	util.PrecacheModel(self.Model)
	end
	
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
			self:EmitSound( sounds[math.random(1,4)] )

	local ent = data.HitEntity
	if ent and ent:IsValid() and ent:IsPlayer() then
	
		local damage = DamageInfo()
		damage:SetDamageType(DMG_ACID)
		ent:TakeDamageInfo(damage, self)
		ent:TakeDamage(self.Damage, self)
		
		local painsounds = {}
			painsounds[1] = ("player/pl_pain7.wav")
			painsounds[2] = ("player/pl_pain6.wav")
			painsounds[3] = ("player/pl_pain5.wav")
			ent:EmitSound( painsounds[math.random(1,3)] )
		
		local painsounds = {}
			painsounds[1] = ("player/pl_pain7.wav")
			painsounds[2] = ("player/pl_pain6.wav")
			painsounds[3] = ("player/pl_pain5.wav")
			ent:EmitSound( painsounds[math.random(1,3)] )
		
		self:EmitSound("physics/flesh/flesh_bloody_break.wav")
		
		ent:ViewPunch(Angle(math.random(-1, 1)*self.Damage, math.random(-1, 1)*self.Damage, math.random(-1, 1)*self.Damage))
		
		local moveAdd=Vector(0,0,150)
		if not ent:IsOnGround() then
		moveAdd=Vector(0,0,0)
		end
		ent:SetVelocity(moveAdd+((ent:GetPos()-self:GetPos()):GetNormal()*100)) -- apply the velocity
	
			local bleed = ents.Create("info_particle_system")
		bleed:SetKeyValue("effect_name", "blood_impact_red_01")
		bleed:SetPos(self:GetPos()) 
		bleed:SetBloodColor(BLOOD_COLOR_GREEN) 
		bleed:Spawn()
		bleed:Activate() 
		bleed:Fire("Start", "", 0)
		bleed:Fire("Kill", "", 0.2)
	
		self:Remove()
	else
		local normal = data.OurOldVelocity:GetNormalized()
		local DotProduct = data.HitNormal:Dot(normal * -1)

		physobj:SetVelocityInstantaneous((2 * DotProduct * data.HitNormal + normal) * math.max(100, data.Speed) * 0.9)
	end
	
	if ent and ent:IsValid() and ent:GetClass() == "prop_physics" then
	
	ent:TakeDamage(45, self)
	self:EmitSound("physics/flesh/flesh_bloody_break.wav")
	
	local phys = ent:GetPhysicsObject()
		if (phys != nil && phys != NULL && phys:IsValid()) then
		phys:ApplyForceCenter(ent:GetForward():GetNormalized()*15000 + Vector(0, 0, 2))
		end
		
	end
	
	end
end
end

if CLIENT then

	function ENT:Draw()
		self:DrawModel()
	end
end

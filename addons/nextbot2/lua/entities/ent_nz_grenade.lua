AddCSLuaFile()

if SERVER then
ENT.Base = "nz_projectile_base"
end

ENT.Type = "anim"
ENT.Contact			= ""
ENT.Purpose			= ""
ENT.Instructions	= ""

ENT.Spawnable 		= false
ENT.AdminSpawnable 	= false

ENT.PrintName		= "Grenade"
ENT.Category 		= ""

ENT.Model = "models/weapons/w_grenade.mdl"

if SERVER then
	function ENT:Initialize()
	 
		self:SetModel( self.Model )
		
		self:SetHealth( 999999 )
		self:PhysicsInit( SOLID_VPHYSICS )
		self:SetSolid( SOLID_VPHYSICS )
		
			local phys = self:GetPhysicsObject()
		if (phys:IsValid()) then
			phys:EnableMotion( true )
		end
		
	end
end

function ENT:OnInjured(dmginfo)
	dmginfo:ScaleDamage(0)
end
		
function ENT:Explode( ent, power )

	local ents = ents.FindInSphere( self:GetPos(), 120 )
	for _,v in pairs(ents) do
		
		if v:IsPlayer() then
			v:TakeDamage(20, self.Owner)
			v:Ignite(2, 60)
			v:ViewPunch(Angle(math.random(-1, 1)*power, math.random(-1, 1)*power, math.random(-1, 1)*power))
		elseif v:IsNPC() and v != self and !v:GetClass("nazi_zombie_*", "npc_nextbot_*", "nz_*", "mob_zombie_*") then
			v:TakeDamage(20, self.Owner)
			v:Ignite(2, 60)
		elseif v:GetClass("prop_physics") then
			local phys = v:GetPhysicsObject()
			if (phys != nil && phys != NULL && phys:IsValid()) then
			phys:ApplyForceCenter(self:GetForward():GetNormalized()*30000 + Vector(0, 0, 2))
			v:TakeDamage(20, self.Owner)	
			v:Ignite(6, 60)
			end
		end	

	end

end	
		
function ENT:PhysicsCollide(data, physobj)
	if self:IsValid() then
		if SERVER then
			
		local explode = ents.Create("env_explosion")
		explode:SetPos( self:GetPos() )
		explode:Spawn()
		explode:SetKeyValue( "iMagnitude", 0 )
		explode:SetOwner(self:GetOwner())	
		explode:Fire( "Explode", 1, 0 )	
		
		self:Explode( self, math.random( 40, 50 ) )
		
		SafeRemoveEntity( self )
		end
	end
end	

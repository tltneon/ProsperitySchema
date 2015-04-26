AddCSLuaFile()

ENT.Base             = "base_nextbot"
ENT.Spawnable        = false
ENT.AdminSpawnable   = false

--Stats--
--Model Settings--
ENT.Model = ("")

function ENT:Precache()
end

function ENT:Initialize()
	self:SetHealth(99999999999)
	self:SetModel(self.Model)
	self:SetCollisionGroup(COLLISION_GROUP_IN_VEHICLE)
	self:StartActivity(ACT_HL2MP_ZOMBIE_SLUMP_IDLE)
end

function ENT:BehaveAct()
end

function ENT:Think()

	if ( self.EffectTimer or 0 ) < CurTime() then
	self.EffectTimer = CurTime() + 0.425
	local effectdata = EffectData()
	effectdata:SetStart( self:GetPos() + Vector(0,0,0) ) 
	effectdata:SetOrigin( self:GetPos() + Vector(0,0,0) )
	effectdata:SetScale( 0.8 )
	util.Effect( "poisonfire", effectdata )
	end
	
	if ( self.DamageTimer or 0 ) < CurTime() then
	self.DamageTimer = CurTime() + 1
	local ents = ents.FindInSphere( self:GetPos(), 70 )
	for _,v in pairs(ents) do
	
		if v:IsPlayer() then
		if !v:IsValid() then return end
		if v:Health() < 0 then return end
		v:TakeDamage( 1, self)
		v:EmitSound("npc/headcrab_poison/ph_hiss1.wav")
	
		local painsounds = {}
		painsounds[1] = ("player/pl_pain7.wav")
		painsounds[2] = ("player/pl_pain6.wav")
		painsounds[3] = ("player/pl_pain5.wav")
		v:EmitSound( painsounds[math.random(1,3)] )
		
		local moveAdd=Vector(0,0,150)
			if not v:IsOnGround() then
			moveAdd=Vector(0,0,0)
			end
			v:SetVelocity(moveAdd+((v:GetPos()-self:GetPos()):GetNormal()*100)) -- apply the velocity
		end
		
		if v:GetClass("prop_physics") then
		local phys = v:GetPhysicsObject()
			if (phys != nil && phys != NULL && phys:IsValid()) then
			phys:ApplyForceCenter(self:GetForward():GetNormalized()*10000 + Vector(0, 0, 2))
			v:TakeDamage(10, self)	
			end
		end	
	end
	
	end

end

function ENT:OnRemove()
end

function ENT:GetEnemy()
end

function ENT:OnStuck()
end

function ENT:OnUnStuck()
end

function ENT:SetEnemy()
end

function ENT:GetDoor()
end

function ENT:MoveToPos( pos, options )
end
	
function ENT:AttackProp()
end

function ENT:UpdateEnemy()
end

function ENT:RunBehaviour()
	while ( true ) do
			coroutine.wait( 99999999999 )
			self:StartActivity(ACT_HL2MP_ZOMBIE_SLUMP_IDLE)
	end
end	

function ENT:OnLeaveGround()
end

function ENT:OnLandOnGround() 
end

function ENT:OnKilled( dmginfo )
end

function ENT:OnInjured( dmginfo )
dmginfo:ScaleDamage(0)
dmginfo:SetDamage(0)
end
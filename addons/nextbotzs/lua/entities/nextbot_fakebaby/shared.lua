AddCSLuaFile()

ENT.Base             = "base_nextbot"
ENT.Spawnable        = false
ENT.AdminSpawnable   = false

--Stats--
--Model Settings--
ENT.Model = ("models/vinrax/player/doll_player.mdl")

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
self:EmitSound("physics/body/body_medium_impact_hard"..math.random(6)..".wav", 60, math.random(60, 70))
dmginfo:ScaleDamage(0)
end
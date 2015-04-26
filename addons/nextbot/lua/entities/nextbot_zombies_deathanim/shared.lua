AddCSLuaFile()

ENT.Base             = "base_nextbot"
ENT.Spawnable        = false
ENT.AdminSpawnable   = false
ENT.AutomaticFrameAdvance = true 

--Stats--
--Model Settings--
ENT.Model = ("")

function ENT:Precache()
end

function ENT:Initialize()
	self:SetHealth(2500)
	self:SetModel(self.Model)
	self:SetCollisionGroup(COLLISION_GROUP_IN_VEHICLE)
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
	if SERVER then
	
	local anim = math.random(1,4)
	if anim == 1 then
	self:PlaySequenceAndWait( "death_03", 1.2 )
	
	else
	if anim == 2 then
	self:PlaySequenceAndWait( "death_02", 1.2 )
	
	end
	if anim == 3 then
	self:PlaySequenceAndWait( "death_03", 1.2 )
	
	end
	if anim == 4 then
	
	timer.Simple(1.6, function()
	if !self:IsValid() then return end
	if self:Health() < 0 then return end
	self:EmitSound("hit/body_medium_impact_hard"..math.random(6)..".wav", 67, 85)
	end)
	
	timer.Simple(1, function()
	if !self:IsValid() then return end
	if self:Health() < 0 then return end
	self:EmitSound("hit/body_medium_impact_hard"..math.random(6)..".wav", 67, 90)
	end)
	
	self:PlaySequenceAndWait( "death_04", 1.6 )
	end
	end
	
	self:TakeDamage(2501)
	
	coroutine.wait( 0 )
	end
	end
end	

function ENT:OnLeaveGround()
end

function ENT:OnLandOnGround() 
end

function ENT:OnKilled( dmginfo )
	dmginfo:SetDamage(1)
	self:BecomeRagdoll( dmginfo )
end

function ENT:OnInjured( dmginfo )
	if !dmginfo:GetAttacker() == self and !dmginfo:GetInflictor() == self then
	dmginfo:ScaleDamage(0)
	end
end
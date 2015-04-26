AddCSLuaFile()

ENT.Base             = "base_nextbot"
ENT.Spawnable        = false
ENT.AdminSpawnable   = false
ENT.AutomaticFrameAdvance = true 

--Stats--
--Model Settings--
ENT.Model = ("models/vinrax/player/doll_player.mdl")

function ENT:Precache()
end

function ENT:Initialize()
	self:SetHealth(900)
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
	local death = math.random(1,4)	
		if death == 1 then self:PlaySequenceAndWait( "death_01", 1 ) else	
		if death == 2 then self:PlaySequenceAndWait( "death_02", 1 ) end	
		if death == 3 then self:PlaySequenceAndWait( "death_03", 1 ) end	
		if death == 4 then self:PlaySequenceAndWait( "death_04", 1 ) end	
		end	
	
	local zombie = ents.Create("nextbot_fakebaby")
			if not ( self:IsValid() ) then return end
			if zombie:IsValid() then 
			zombie:SetPos(self:GetPos())
			zombie:SetAngles(self:GetAngles())
			zombie:Spawn()
			zombie:SetModelScale(0.4, 0)
			zombie:SetSkin(self:GetSkin())
			zombie:SetColor(self:GetColor())
			zombie:SetMaterial(self:GetMaterial())
			self:Remove()
			end
	
	coroutine.wait( 0.01 )
	end
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
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
	self:SetHealth(1)
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
	
	local anim = math.random(1,2)
	if anim == 1 then
	self:PlaySequenceAndWait( "death_01", 1 )
	else
	if anim == 2 then
	self:PlaySequenceAndWait( "death_02", 1 )
	end
	if anim == 3 then
	self:PlaySequenceAndWait( "death_03", 1 )
	end
	if anim == 4 then
	self:PlaySequenceAndWait( "death_04", 1 )
	end
	end
	
	local zombie = ents.Create("nextbot_fakebody")
			if not ( self:IsValid() ) then return end
			if zombie:IsValid() then 
			zombie:SetPos(self:GetPos())
			zombie:SetModel(self:GetModel())
			zombie:SetAngles(self:GetAngles())
			zombie:Spawn()
			
		local scale = self:GetModelScale()
			zombie:SetModelScale( scale, 0)
			
			zombie:SetSkin(self:GetSkin())
			zombie:SetColor(self:GetColor())
			zombie:SetMaterial(self:GetMaterial())
			self:Remove()
			end
	
	coroutine.wait( 0.00025 )
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
	dmginfo:ScaleDamage(0)
end
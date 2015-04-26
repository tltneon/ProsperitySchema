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
	self:SetHealth(999999)
	self:SetModel(self.Model)
	self:SetCollisionGroup(COLLISION_GROUP_IN_VEHICLE)
	
	if SERVER then
	local model = ents.Create("ent_shield")
	model:SetPos( self:GetPos() + Vector(0,0,50))
    self:DeleteOnRemove(model)
    model:SetParent(self)
	model:SetModelScale(1.3, 0)
    model:Spawn()
    model:Fire("setparentattachment", "Anim_Attachment_LH", 0.01)
	model:SetCollisionGroup(COLLISION_GROUP_IN_VEHICLE)
	
	
	local model2 = ents.Create("ent_club")
    model2:SetPos( self:GetPos())
    self:DeleteOnRemove(model2)
    model2:SetParent(self)
	model2:SetModelScale(1.4, 0)
    model2:Spawn()
    model2:Fire("setparentattachment", "Anim_Attachment_RH", 0.01)
	model2:SetCollisionGroup(COLLISION_GROUP_IN_VEHICLE)
	end
	
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
	self:PlaySequenceAndWait( "death_04", 1 )
	else
	if anim == 2 then
	self:PlaySequenceAndWait( "death_03", 0.8 )
	end
	end
	
	local zombie = ents.Create("boss5_fakebody")
			if not ( self:IsValid() ) then return end
			if zombie:IsValid() then 
			zombie:SetPos(self:GetPos())
			zombie:SetModel(self:GetModel())
			zombie:SetAngles(self:GetAngles())
			zombie:Spawn()
			zombie:SetModelScale(1.5, 0)
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
dmginfo:ScaleDamage(0)
dmginfo:SetDamage(0)
end
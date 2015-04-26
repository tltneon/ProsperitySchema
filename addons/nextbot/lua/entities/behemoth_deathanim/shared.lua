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
	
	timer.Simple(2.7, function()
	if !self:IsValid() then return end
	if self:Health() < 0 then return end
	self:EmitSound("physics/concrete/concrete_break"..math.random(2,3)..".wav", 77, math.random(65,75))
	
	local asd = ents.FindInSphere(self:GetPos(), 255)
		for _,v in pairs(asd) do
		
			if (v:IsPlayer()) then
		
		v:ViewPunch(Angle(math.random(-3, 7), math.random(-3, 7), math.random(-3, 9)))
		
			end
		end
	
	end)
	
	timer.Simple(1.8, function()
	if !self:IsValid() then return end
	if self:Health() < 0 then return end
	self:EmitSound("physics/concrete/concrete_break"..math.random(2,3)..".wav", 77, math.random(65,75))
	
	local asd = ents.FindInSphere(self:GetPos(), 255)
		for _,v in pairs(asd) do
		
			if (v:IsPlayer()) then
		
		v:ViewPunch(Angle(math.random(-3, 7), math.random(-3, 7), math.random(-3, 9)))
		
			end
		end
	
	end)
	
	self:PlaySequenceAndWait( "death_04", 1 )
	
	local zombie = ents.Create("nextbot_fakebody")
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
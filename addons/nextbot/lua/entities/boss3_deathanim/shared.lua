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

function ENT:Explode()
if SERVER then

			local explode = ents.Create("env_explosion")
	explode:SetPos(self:GetPos())
	explode:Spawn()
	explode:SetKeyValue( "iMagnitude", "60" )
	explode:SetOwner(self.Entity:GetOwner())
	explode:SetOwner(self)	
	explode:Fire( "Explode", 0, 0 )
	explode:EmitSound("ambient/fire/gascan_ignite1.wav")
	end
	
	local effectdata = EffectData()
	effectdata:SetStart( self:GetPos() ) 
	effectdata:SetOrigin( self:GetPos() )
	effectdata:SetScale( 1 )
	util.Effect( "boss5explosion", effectdata )
	
end

function ENT:RunBehaviour()
	while ( true ) do	
	if SERVER then
	
	timer.Simple(0.2, function()
	if not ( self:IsValid() ) then return end
	self:Explode()
	end)
	
	timer.Simple(0.4, function()
	if not ( self:IsValid() ) then return end
	self:Explode()
	end)
	
	timer.Simple(0.6, function()
	if not ( self:IsValid() ) then return end
	self:Explode()
	end)
	
	timer.Simple(0.8, function()
	if not ( self:IsValid() ) then return end
	self:Explode()
	end)
	
	timer.Simple(1, function()
	if not ( self:IsValid() ) then return end
	self:Explode()
	end)
	
	timer.Simple(1.2, function()
	if not ( self:IsValid() ) then return end
	self:Explode()
	end)
	
	timer.Simple(1.4, function()
	if not ( self:IsValid() ) then return end
	self:Explode()
	end)
	
	timer.Simple(1.6, function()
	if not ( self:IsValid() ) then return end
	self:Explode()
	end)
	
	self:PlaySequenceAndWait( "death_04", 1 )
	
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
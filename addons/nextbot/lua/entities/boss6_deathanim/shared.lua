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
	self:EmitSound("physics/concrete/concrete_break"..math.random(2,3)..".wav", 70, math.random(65,75))
	
	local sounds = {}
			sounds[1] = ("physics/flesh/flesh_squishy_impact_hard1.wav")
			sounds[2] = ("physics/flesh/flesh_squishy_impact_hard2.wav")
			sounds[3] = ("physics/flesh/flesh_squishy_impact_hard3.wav")
			sounds[4] = ("physics/flesh/flesh_squishy_impact_hard4.wav")
			self:EmitSound( sounds[math.random(1,4)], 100, math.random(65,75) )
	
	end)
	
	timer.Simple(1.8, function()
	if !self:IsValid() then return end
	if self:Health() < 0 then return end
	self:EmitSound("physics/concrete/concrete_break"..math.random(2,3)..".wav", 70, math.random(65,75))
	
	local sounds = {}
			sounds[1] = ("physics/flesh/flesh_squishy_impact_hard1.wav")
			sounds[2] = ("physics/flesh/flesh_squishy_impact_hard2.wav")
			sounds[3] = ("physics/flesh/flesh_squishy_impact_hard3.wav")
			sounds[4] = ("physics/flesh/flesh_squishy_impact_hard4.wav")
			self:EmitSound( sounds[math.random(1,4)], 100, math.random(65,75) )
	
	end)
	
	timer.Simple(0.2, function()
	if not ( self:IsValid() ) then return end
	local flesh = ents.Create("flesh_ball") 
		if flesh:IsValid() then
		flesh:SetPos(self:EyePos() + Vector(0,0,25))
		flesh:SetOwner(self)
		flesh:Spawn()
		self:EmitSound("physics/body/body_medium_break"..math.random(2, 4)..".wav", 72, math.Rand(105, 115))
	
		local phys = flesh:GetPhysicsObject()
			if phys:IsValid() then
				local ang = self:EyeAngles()
				ang:RotateAroundAxis(ang:Forward(), math.Rand(-200, 200))
				ang:RotateAroundAxis(ang:Up(), math.Rand(-200, 200))
				phys:SetVelocityInstantaneous(ang:Forward() * math.Rand(225, 390))
			end
		end
	end)
	
	timer.Simple(0.4, function()
	if not ( self:IsValid() ) then return end
	local flesh = ents.Create("flesh_ball") 
		if flesh:IsValid() then
		flesh:SetPos(self:EyePos() + Vector(0,0,25))
		flesh:SetOwner(self)
		flesh:Spawn()
		self:EmitSound("physics/body/body_medium_break"..math.random(2, 4)..".wav", 72, math.Rand(105, 115))
	
		local phys = flesh:GetPhysicsObject()
			if phys:IsValid() then
				local ang = self:EyeAngles()
				ang:RotateAroundAxis(ang:Forward(), math.Rand(-200, 200))
				ang:RotateAroundAxis(ang:Up(), math.Rand(-200, 200))
				phys:SetVelocityInstantaneous(ang:Forward() * math.Rand(225, 390))
			end
		end
	end)
	
	timer.Simple(0.6, function()
	if not ( self:IsValid() ) then return end
	local flesh = ents.Create("flesh_ball") 
		if flesh:IsValid() then
		flesh:SetPos(self:EyePos() + Vector(0,0,25))
		flesh:SetOwner(self)
		flesh:Spawn()
		self:EmitSound("physics/body/body_medium_break"..math.random(2, 4)..".wav", 72, math.Rand(105, 115))
	
		local phys = flesh:GetPhysicsObject()
			if phys:IsValid() then
				local ang = self:EyeAngles()
				ang:RotateAroundAxis(ang:Forward(), math.Rand(-200, 200))
				ang:RotateAroundAxis(ang:Up(), math.Rand(-200, 200))
				phys:SetVelocityInstantaneous(ang:Forward() * math.Rand(225, 390))
			end
		end
	end)
	
	timer.Simple(0.8, function()
	if not ( self:IsValid() ) then return end
	local flesh = ents.Create("flesh_ball") 
		if flesh:IsValid() then
		flesh:SetPos(self:EyePos() + Vector(0,0,25))
		flesh:SetOwner(self)
		flesh:Spawn()
		self:EmitSound("physics/body/body_medium_break"..math.random(2, 4)..".wav", 72, math.Rand(105, 115))
	
		local phys = flesh:GetPhysicsObject()
			if phys:IsValid() then
				local ang = self:EyeAngles()
				ang:RotateAroundAxis(ang:Forward(), math.Rand(-200, 200))
				ang:RotateAroundAxis(ang:Up(), math.Rand(-200, 200))
				phys:SetVelocityInstantaneous(ang:Forward() * math.Rand(225, 390))
			end
		end
	end)
	
	timer.Simple(1, function()
	if not ( self:IsValid() ) then return end
	local flesh = ents.Create("flesh_ball") 
		if flesh:IsValid() then
		flesh:SetPos(self:EyePos() + Vector(0,0,25))
		flesh:SetOwner(self)
		flesh:Spawn()
		self:EmitSound("physics/body/body_medium_break"..math.random(2, 4)..".wav", 72, math.Rand(105, 115))
	
		local phys = flesh:GetPhysicsObject()
			if phys:IsValid() then
				local ang = self:EyeAngles()
				ang:RotateAroundAxis(ang:Forward(), math.Rand(-200, 200))
				ang:RotateAroundAxis(ang:Up(), math.Rand(-200, 200))
				phys:SetVelocityInstantaneous(ang:Forward() * math.Rand(225, 390))
			end
		end
	end)
	
	timer.Simple(1.2, function()
	if not ( self:IsValid() ) then return end
	local flesh = ents.Create("flesh_ball") 
		if flesh:IsValid() then
		flesh:SetPos(self:EyePos() + Vector(0,0,25))
		flesh:SetOwner(self)
		flesh:Spawn()
		self:EmitSound("physics/body/body_medium_break"..math.random(2, 4)..".wav", 72, math.Rand(105, 115))
	
		local phys = flesh:GetPhysicsObject()
			if phys:IsValid() then
				local ang = self:EyeAngles()
				ang:RotateAroundAxis(ang:Forward(), math.Rand(-200, 200))
				ang:RotateAroundAxis(ang:Up(), math.Rand(-200, 200))
				phys:SetVelocityInstantaneous(ang:Forward() * math.Rand(225, 390))
			end
		end
	end)
	
	timer.Simple(1.4, function()
	if not ( self:IsValid() ) then return end
	local flesh = ents.Create("flesh_ball") 
		if flesh:IsValid() then
		flesh:SetPos(self:EyePos() + Vector(0,0,25))
		flesh:SetOwner(self)
		flesh:Spawn()
		self:EmitSound("physics/body/body_medium_break"..math.random(2, 4)..".wav", 72, math.Rand(105, 115))
	
		local phys = flesh:GetPhysicsObject()
			if phys:IsValid() then
				local ang = self:EyeAngles()
				ang:RotateAroundAxis(ang:Forward(), math.Rand(-200, 200))
				ang:RotateAroundAxis(ang:Up(), math.Rand(-200, 200))
				phys:SetVelocityInstantaneous(ang:Forward() * math.Rand(225, 390))
			end
		end
	end)
	
	timer.Simple(1.6, function()
	if not ( self:IsValid() ) then return end
	local flesh = ents.Create("flesh_ball") 
		if flesh:IsValid() then
		flesh:SetPos(self:EyePos() + Vector(0,0,15))
		flesh:SetOwner(self)
		flesh:Spawn()
		self:EmitSound("physics/body/body_medium_break"..math.random(2, 4)..".wav", 72, math.Rand(105, 115))
	
		local phys = flesh:GetPhysicsObject()
			if phys:IsValid() then
				local ang = self:EyeAngles()
				ang:RotateAroundAxis(ang:Forward(), math.Rand(-200, 200))
				ang:RotateAroundAxis(ang:Up(), math.Rand(-200, 200))
				phys:SetVelocityInstantaneous(ang:Forward() * math.Rand(225, 390))
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
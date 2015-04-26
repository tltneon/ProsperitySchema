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
	
	timer.Simple(0.2, function()
	if not ( self:IsValid() ) then return end
	local flesh = ents.Create("burning_flesh") 
		if flesh:IsValid() then
		flesh:SetPos(self:EyePos() + Vector(0,0,25))
		flesh:SetOwner(self)
		flesh:Spawn()
	
		self:EmitSound("physics/flesh/flesh_bloody_break.wav")	
		self:EmitSound("physics/body/body_medium_break"..math.random(2, 4)..".wav", 72, math.Rand(105, 115))
	
		local phys = flesh:GetPhysicsObject()
			if phys:IsValid() then
				local ang = self:EyeAngles()
				ang:RotateAroundAxis(ang:Forward(), math.Rand(-200, 200))
				ang:RotateAroundAxis(ang:Up(), math.Rand(-200, 200))
				phys:SetVelocityInstantaneous(ang:Forward() * math.Rand(325, 590))
			end
		end
	end)
	
	timer.Simple(0.4, function()
	if not ( self:IsValid() ) then return end
	local flesh = ents.Create("burning_flesh") 
		if flesh:IsValid() then
		flesh:SetPos(self:EyePos() + Vector(0,0,25))
		flesh:SetOwner(self)
		flesh:Spawn()
	
		self:EmitSound("physics/flesh/flesh_bloody_break.wav")	
		self:EmitSound("physics/body/body_medium_break"..math.random(2, 4)..".wav", 72, math.Rand(105, 115))
	
		local phys = flesh:GetPhysicsObject()
			if phys:IsValid() then
				local ang = self:EyeAngles()
				ang:RotateAroundAxis(ang:Forward(), math.Rand(-200, 200))
				ang:RotateAroundAxis(ang:Up(), math.Rand(-200, 200))
				phys:SetVelocityInstantaneous(ang:Forward() * math.Rand(325, 590))
			end
		end
	end)
	
	timer.Simple(0.6, function()
	if not ( self:IsValid() ) then return end
	local flesh = ents.Create("burning_flesh") 
		if flesh:IsValid() then
		flesh:SetPos(self:EyePos() + Vector(0,0,25))
		flesh:SetOwner(self)
		flesh:Spawn()
	
		self:EmitSound("physics/flesh/flesh_bloody_break.wav")	
		self:EmitSound("physics/body/body_medium_break"..math.random(2, 4)..".wav", 72, math.Rand(105, 115))
	
		local phys = flesh:GetPhysicsObject()
			if phys:IsValid() then
				local ang = self:EyeAngles()
				ang:RotateAroundAxis(ang:Forward(), math.Rand(-200, 200))
				ang:RotateAroundAxis(ang:Up(), math.Rand(-200, 200))
				phys:SetVelocityInstantaneous(ang:Forward() * math.Rand(325, 590))
			end
		end
	end)
	
	timer.Simple(0.8, function()
	if not ( self:IsValid() ) then return end
	local flesh = ents.Create("burning_flesh")  
		if flesh:IsValid() then
		flesh:SetPos(self:EyePos() + Vector(0,0,25))
		flesh:SetOwner(self)
		flesh:Spawn()
	
		self:EmitSound("physics/flesh/flesh_bloody_break.wav")	
		self:EmitSound("physics/body/body_medium_break"..math.random(2, 4)..".wav", 72, math.Rand(105, 115))
	
		local phys = flesh:GetPhysicsObject()
			if phys:IsValid() then
				local ang = self:EyeAngles()
				ang:RotateAroundAxis(ang:Forward(), math.Rand(-200, 200))
				ang:RotateAroundAxis(ang:Up(), math.Rand(-200, 200))
				phys:SetVelocityInstantaneous(ang:Forward() * math.Rand(325, 590))
			end
		end
	end)
	
	timer.Simple(1, function()
	if not ( self:IsValid() ) then return end
	local flesh = ents.Create("burning_flesh") 
		if flesh:IsValid() then
		flesh:SetPos(self:EyePos() + Vector(0,0,25))
		flesh:SetOwner(self)
		flesh:Spawn()
	
		self:EmitSound("physics/flesh/flesh_bloody_break.wav")	
		self:EmitSound("physics/body/body_medium_break"..math.random(2, 4)..".wav", 72, math.Rand(105, 115))
	
		local phys = flesh:GetPhysicsObject()
			if phys:IsValid() then
				local ang = self:EyeAngles()
				ang:RotateAroundAxis(ang:Forward(), math.Rand(-200, 200))
				ang:RotateAroundAxis(ang:Up(), math.Rand(-200, 200))
				phys:SetVelocityInstantaneous(ang:Forward() * math.Rand(325, 590))
			end
		end
	end)
	
	timer.Simple(1.2, function()
	if not ( self:IsValid() ) then return end
	local flesh = ents.Create("burning_flesh") 
		if flesh:IsValid() then
		flesh:SetPos(self:EyePos() + Vector(0,0,25))
		flesh:SetOwner(self)
		flesh:Spawn()
	
		self:EmitSound("physics/flesh/flesh_bloody_break.wav")	
		self:EmitSound("physics/body/body_medium_break"..math.random(2, 4)..".wav", 72, math.Rand(105, 115))
	
		local phys = flesh:GetPhysicsObject()
			if phys:IsValid() then
				local ang = self:EyeAngles()
				ang:RotateAroundAxis(ang:Forward(), math.Rand(-200, 200))
				ang:RotateAroundAxis(ang:Up(), math.Rand(-200, 200))
				phys:SetVelocityInstantaneous(ang:Forward() * math.Rand(325, 590))
			end
		end
	end)
	
	timer.Simple(1.4, function()
	if not ( self:IsValid() ) then return end
	local flesh = ents.Create("burning_flesh") 
		if flesh:IsValid() then
		flesh:SetPos(self:EyePos() + Vector(0,0,25))
		flesh:SetOwner(self)
		flesh:Spawn()
	
		self:EmitSound("physics/flesh/flesh_bloody_break.wav")	
		self:EmitSound("physics/body/body_medium_break"..math.random(2, 4)..".wav", 72, math.Rand(105, 115))
	
		local phys = flesh:GetPhysicsObject()
			if phys:IsValid() then
				local ang = self:EyeAngles()
				ang:RotateAroundAxis(ang:Forward(), math.Rand(-200, 200))
				ang:RotateAroundAxis(ang:Up(), math.Rand(-200, 200))
				phys:SetVelocityInstantaneous(ang:Forward() * math.Rand(325, 590))
			end
		end
	end)
	
	timer.Simple(1.6, function()
	if not ( self:IsValid() ) then return end
	local flesh = ents.Create("burning_flesh") 
		if flesh:IsValid() then
		flesh:SetPos(self:EyePos() + Vector(0,0,15))
		flesh:SetOwner(self)
		flesh:Spawn()
	
		self:EmitSound("physics/flesh/flesh_bloody_break.wav")	
		self:EmitSound("physics/body/body_medium_break"..math.random(2, 4)..".wav", 72, math.Rand(105, 115))
	
		local phys = flesh:GetPhysicsObject()
			if phys:IsValid() then
				local ang = self:EyeAngles()
				ang:RotateAroundAxis(ang:Forward(), math.Rand(-200, 200))
				ang:RotateAroundAxis(ang:Up(), math.Rand(-200, 200))
				phys:SetVelocityInstantaneous(ang:Forward() * math.Rand(325, 590))
			end
		end
	end)
	
	self:EmitSound("npc/barnacle/barnacle_die2.wav")
	self:EmitSound("npc/barnacle/barnacle_digesting1.wav")
	self:EmitSound("npc/barnacle/barnacle_digesting2.wav")
	
	local anim = math.random(1,4)
	if anim == 1 then
	self:PlaySequenceAndWait( "death_01", 0.8 )
	else
	if anim == 2 then
	self:PlaySequenceAndWait( "death_02", 0.4 )
	end
	if anim == 3 then
	self:PlaySequenceAndWait( "death_03", 0.4 )
	end
	if anim == 4 then
	self:PlaySequenceAndWait( "death_04", 1 )
	end
	end
	
	self:TakeDamage(2501)
	
	coroutine.wait( 1 )
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
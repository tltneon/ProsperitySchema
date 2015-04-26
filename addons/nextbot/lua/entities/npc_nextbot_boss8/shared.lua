AddCSLuaFile()

ENT.Base             = "base_nextbot"
ENT.Spawnable        = false
ENT.AdminSpawnable   = false


--Stats--
ENT.Speed = 80
ENT.WalkSpeedAnimation = 0.7
ENT.FlinchSpeed = 0

ENT.health = 2000
ENT.Damage = 25

ENT.AttackWaitTime = 0.8
ENT.AttackFinishTime = 0.2

ENT.FallDamage = 0


--Model Settings--
ENT.Model = "models/player/corpse1.mdl"

ENT.AttackAnim = (ACT_GMOD_GESTURE_RANGE_ZOMBIE)
ENT.FleshTossAnim = (ACT_GMOD_GESTURE_RANGE_FRENZY)
ENT.EruptionAnim = (ACT_GMOD_GESTURE_TAUNT_ZOMBIE)

ENT.WalkAnim = (ACT_HL2MP_RUN_PANICKED)

ENT.AttackDoorAnim = (ACT_GMOD_GESTURE_RANGE_ZOMBIE)

--Sounds--
ENT.Attack1 = Sound("")
ENT.Attack2 = Sound("")

ENT.DoorBreak = Sound("npc/zombie/zombie_pound_door.wav")

ENT.Alert1 = Sound("npc/zombie/zombie_alert1.wav")
ENT.Alert2 = Sound("npc/zombie/zombie_alert2.wav")
ENT.Alert3 = Sound("npc/zombie/zombie_alert3.wav")

ENT.Death1 = Sound("npc/zombie_poison/pz_die2.wav")
ENT.Death2 = Sound("npc/zombie_poison/pz_die2.wav")
ENT.Death3 = Sound("npc/zombie_poison/pz_die2.wav")

ENT.Flinch1 = Sound("npc/zombie/zombie_voice_idle10.wav")
ENT.Flinch2 = Sound("npc/zombie/zombie_voice_idle11.wav")
ENT.Flinch3 = Sound("npc/zombie/zombie_voice_idle12.wav")

ENT.Fall1 = Sound("npc/zombie/zombie_voice_idle11.wav")
ENT.Fall2 = Sound("npc/zombie/zombie_voice_idle13.wav")

ENT.Idle1 = Sound("npc/zombie/zombie_voice_idle1.wav")
ENT.Idle2 = Sound("npc/zombie/zombie_voice_idle2.wav")
ENT.Idle3 = Sound("npc/zombie/zombie_voice_idle3.wav")
ENT.Idle4 = Sound("npc/zombie/zombie_voice_idle4.wav")
ENT.Idle5 = Sound("npc/zombie/zombie_voice_idle5.wav")
ENT.Idle6 = Sound("npc/zombie/zombie_voice_idle6.wav")
ENT.Idle7 = Sound("npc/zombie/zombie_voice_idle7.wav")
ENT.Idle8 = Sound("npc/zombie/zombie_voice_idle8.wav")
ENT.Idle9 = Sound("npc/zombie/zombie_voice_idle9.wav")

ENT.Pain1 = Sound("npc/zombie/zombie_pain1.wav")
ENT.Pain2 = Sound("npc/zombie/zombie_pain2.wav")
ENT.Pain3 = Sound("npc/zombie/zombie_pain3.wav")
ENT.Pain4 = Sound("npc/zombie/zombie_pain4.wav")
ENT.Pain5 = Sound("npc/zombie/zombie_pain5.wav")
ENT.Pain6 = Sound("npc/zombie/zombie_pain6.wav")

ENT.Hit = Sound("npc/zombie/claw_strike1.wav")
ENT.Miss = Sound("npc/zombie/claw_miss1.wav")

function ENT:Precache()

--Models--
util.PrecacheModel(self.Model)
	

--Sounds--	
util.PrecacheSound(self.Attack1)
util.PrecacheSound(self.Attack2)

util.PrecacheSound(self.DoorBreak)

util.PrecacheSound(self.Alert1)
util.PrecacheSound(self.Alert2)
util.PrecacheSound(self.Alert3)

util.PrecacheSound(self.Death1)
util.PrecacheSound(self.Death2)
util.PrecacheSound(self.Death3)

util.PrecacheSound(self.Flinch1)
util.PrecacheSound(self.Flinch2)
util.PrecacheSound(self.Flinch3)

util.PrecacheSound(self.Fall1)
util.PrecacheSound(self.Fall2)

util.PrecacheSound(self.Idle1)
util.PrecacheSound(self.Idle2)
util.PrecacheSound(self.Idle3)
util.PrecacheSound(self.Idle4)
util.PrecacheSound(self.Idle5)
util.PrecacheSound(self.Idle6)
util.PrecacheSound(self.Idle7)
util.PrecacheSound(self.Idle8)
util.PrecacheSound(self.Idle9)
	
util.PrecacheSound(self.Pain1)
util.PrecacheSound(self.Pain2)
util.PrecacheSound(self.Pain3)
util.PrecacheSound(self.Pain4)
util.PrecacheSound(self.Pain5)
util.PrecacheSound(self.Pain6)
	
util.PrecacheSound(self.Hit)
util.PrecacheSound(self.Miss)

end

function ENT:Initialize()

	--Stats--
	self:SetCollisionGroup(COLLISION_GROUP_DEBRIS)
	
	self:SetMaterial("models/rotten_corpse/corpse1")
	self:SetColor( Color(255, 185, 185, 255) )
	self:SetModelScale(1.1, 0)
	
    self:SetModel(self.Model)
	self:SetHealth( self.health )
	
	self.LoseTargetDist	= 4000 -- How far the enemy has to be before we lose them
	self.SearchRadius 	= 3000	-- How far to search for enemies
	
	self.IsAttacking = false
	self.HasNoEnemy = false
	
	--Misc--
	self:Precache()
	self.loco:SetStepHeight(35)
	self.loco:SetAcceleration(900)
	self.loco:SetDeceleration(400)
	self.LastPos = self:GetPos()
	self.nextbot = true
end

function ENT:Think()
if !IsValid(self) then return end

	if self.IsAttacking then
		if (GetConVarNumber("nb_stop") == 0) then
	self.loco:FaceTowards( self.Enemy:GetPos() )
		end
	end

    if !self.nxtThink then self.nxtThink = 0 end
    if CurTime() < self.nxtThink then return end

    self.nxtThink = CurTime() + 0.025

	-- First Step
        local bones = self:LookupBone("ValveBiped.Bip01_R_Foot")
		
        local pos, ang = self:GetBonePosition(bones)

        local tr = {}
        tr.start = pos 
        tr.endpos = tr.start - ang:Right()*5 + ang:Forward()*5
        tr.filter = self
        tr = util.TraceLine(tr)

        if tr.Hit && !self.FeetOnGround then
		self:EmitSound("npc/zombie/foot"..math.random(3)..".wav", 70)
        end

        self.FeetOnGround = tr.Hit
		
	-- Second Step
		local bones2 = self:LookupBone("ValveBiped.Bip01_L_Foot")
		
        local pos2, ang2 = self:GetBonePosition(bones2)

        local tr = {}
        tr.start = pos2 
        tr.endpos = tr.start - ang2:Right()*5 + ang2:Forward()*5
        tr.filter = self
        tr = util.TraceLine(tr)

        if tr.Hit && !self.FeetOnGround2 then
		self:EmitSound("npc/zombie/foot"..math.random(3)..".wav", 70)
        end

        self.FeetOnGround2 = tr.Hit
end

function ENT:GetEnemy()
	return self.Enemy
end

function ENT:GetDoor(ent)

	local doors = {}
	doors[1] = "models/props_c17/door01_left.mdl"
	doors[2] = "models/props_c17/door02_double.mdl"
	doors[3] = "models/props_c17/door03_left.mdl"
	doors[4] = "models/props_doors/door01_dynamic.mdl"
	doors[5] = "models/props_doors/door03_slotted_left.mdl"
	doors[6] = "models/props_interiors/elevatorshaft_door01a.mdl"
	doors[7] = "models/props_interiors/elevatorshaft_door01b.mdl"
	doors[8] = "models/props_silo/silo_door01_static.mdl"
	doors[9] = "models/props_wasteland/prison_celldoor001b.mdl"
	doors[10] = "models/props_wasteland/prison_celldoor001a.mdl"
	
	doors[11] = "models/props_radiostation/radio_metaldoor01.mdl"
	doors[12] = "models/props_radiostation/radio_metaldoor01a.mdl"
	doors[13] = "models/props_radiostation/radio_metaldoor01b.mdl"
	doors[14] = "models/props_radiostation/radio_metaldoor01c.mdl"
	
	for k,v in pairs( doors ) do
		if ent:GetModel() == v and string.find(ent:GetClass(), "door") then
			return "door"
		end
	end

end

function ENT:SetEnemy()
	ent = player.GetAll()[math.random(1,#player.GetAll())]
	self.Enemy = ent
end

function ENT:GetEnemy()
	return self.Enemy
end

function ENT:HaveEnemy()
	if ( self:GetEnemy() and IsValid( self:GetEnemy() ) ) then
		if ( self:GetRangeTo( self:GetEnemy():GetPos() ) > self.LoseTargetDist ) then
			return self:FindEnemy()
		elseif ( self:GetEnemy():IsPlayer() and !self:GetEnemy():Alive() ) then
			return self:FindEnemy()
		end	
		return true
	else
		return self:FindEnemy()
	end
end

function ENT:FindEnemy()
	local _ents = ents.FindInSphere( self:GetPos(), self.SearchRadius )
	for k,v in pairs( _ents ) do
		if ( v:IsPlayer() ) then
			self:SetEnemy( v )
			return true
		end
	end	
	self:SetEnemy( nil )
	return false
end

function ENT:ChaseEnemy( options )
	local options = options or {}
	local path = Path( "Follow" )
	path:SetMinLookAheadDistance( options.lookahead or 300 )
	path:SetGoalTolerance( options.tolerance or 20 )
	path:Compute( self, self:GetEnemy():GetPos() )
	if (  !path:IsValid() ) then return "failed" end
	while ( path:IsValid() and self:HaveEnemy() ) do

		if ( path:GetAge() > 0.1 ) then	
			path:Compute( self, self:GetEnemy():GetPos() )
		end
		path:Update( self )	
		if ( options.draw ) then path:Draw() end
		if ( self.loco:IsStuck() ) then
			self:HandleStuck()
			return "stuck"
		end

		if (self:GetPos():Distance(self.Enemy:GetPos()) < 1000) then	
	if math.random( 1,500) == 5 then
	self:IdleSounds()
	end
		end
		
		local door = ents.FindInSphere(self:GetPos(),25)
		if door then
			for i = 1, #door do
				local v = door[i]
				if !v:IsPlayer() and v != self and IsValid( v ) then
					if self:GetDoor( v ) == "door" then
					
						if v.Hitsleft == nil then
							v.Hitsleft = 10
						end
						
						if v != NULL and v.Hitsleft > 0 then
						
							if !self:IsValid() then return end
		if self:Health() < 0 then return end
		
		if !v:IsValid() then 
		self:StartActivity( self.WalkAnim )
		self:SetPoseParameter("move_x",self.WalkSpeedAnimation)	
		self:EmitSound(self.Miss)
		return end
		
		if v:Health() < 0 then 
		self:StartActivity( self.WalkAnim )
		self:SetPoseParameter("move_x",self.WalkSpeedAnimation)	
		self:EmitSound(self.Miss)
		return end
						
							if (self:GetRangeTo(v) < 25) then
							
								if SERVER then
								self:EmitSound("npc/fast_zombie/leap1.wav", 74, math.Rand(70, 90))
								end
							
								self:RestartGesture(self.AttackDoorAnim)
								self:SetPoseParameter("move_x",0)
								self.loco:SetDesiredSpeed(0)
								coroutine.wait(self.AttackWaitTime)
								v:EmitSound(self.DoorBreak)
								
								if v != NULL and v.Hitsleft != nil then
									if v.Hitsleft > 0 then
									v.Hitsleft = v.Hitsleft - 1
									
									end
								end
							end
						end
						
						if v != NULL and v.Hitsleft < 1 then
							v:Remove()
							
						local door = ents.Create("prop_physics")
						door:SetModel(v:GetModel())
						door:SetPos(v:GetPos())
						door:SetAngles(v:GetAngles())
						door:Spawn()
						door:EmitSound("Wood_Plank.Break")
						
						local phys = door:GetPhysicsObject()
						if (phys != nil && phys != NULL && phys:IsValid()) then
						phys:ApplyForceCenter(self:GetForward():GetNormalized()*20000 + Vector(0, 0, 2))
						end
						
						door:SetSkin(v:GetSkin())
						door:SetColor(v:GetColor())
						door:SetMaterial(v:GetMaterial())
					end
						coroutine.wait(self.AttackFinishTime)	
						self:StartActivity( self.WalkAnim )
						self:SetPoseParameter("move_x",self.WalkSpeedAnimation)
						self.loco:SetDesiredSpeed( self.Speed )
						end
						end
						end
						end
						
		local ent = ents.FindInSphere(self:GetPos(),120)
	for k,v in pairs( ent ) do
		if (v:IsPlayer() && v:Alive()) then
		self.Enemy = v
		self:Attack()
		end
	end

		if GetConVarNumber( "nb_attackprop" ) == 1 then
		if (self:GetRangeTo(self.Enemy) < 50 or self:AttackProp()) then
			else
			if (self:GetRangeTo(self.Enemy) < 50 or self:AttackBreakable()) then
			end 
		end
	end
	
		coroutine.yield()
	end
	return "ok"
end

ENT.nxtAttack = 0
function ENT:Attack()
	if !self.nxtAttack then self.nxtAttack = 0 end
    if CurTime() < self.nxtAttack then return end

    self.nxtAttack = CurTime() + 1.2
		
		if ( (self.Enemy:IsValid() and self.Enemy:Health() > 0 ) ) then
		
		if self.IsFlinching or self.IsReviving then return end
		
	local attack = math.random(1,2)
	if attack == 1 then
	
		self:EmitSound("npc/barnacle/barnacle_die2.wav")
		self:EmitSound("npc/barnacle/barnacle_digesting1.wav")
		self:EmitSound("npc/barnacle/barnacle_digesting2.wav")
	
		self:RestartGesture(self.FleshTossAnim)
	
		timer.Simple(1.9, function() 
		if !self:IsValid() then return end
		if self:Health() < 0 then return end
		
		if !self.Enemy:IsValid() then 
		self:StartActivity( self.WalkAnim )
		self:EmitSound(self.Miss)
		return end
		
		if self.Enemy:Health() < 0 then 
		self:StartActivity( self.WalkAnim )
		self:EmitSound(self.Miss)
		return end
			
		if self.IsFlinching or self.IsReviving then return end
		
		self:EmitSound("physics/flesh/flesh_bloody_break.wav")	
		self:EmitSound("physics/body/body_medium_break"..math.random(2, 4)..".wav", 72, math.Rand(105, 115))
		self:RestartGesture(self.FleshTossAnim)
		
		for i=1,2 do
		flesh = ents.Create("burning_flesh") 
		if flesh:IsValid() then
		flesh:SetPos(self:EyePos() + Vector(0,0,30))
		flesh:SetOwner(self)
		flesh:Spawn()
	
		local phys = flesh:GetPhysicsObject()
			if phys:IsValid() then
				local ang = self:EyeAngles()
				ang:RotateAroundAxis(ang:Forward(), math.Rand(-5, 5))
				ang:RotateAroundAxis(ang:Up(), math.Rand(-5, 5))
				phys:SetVelocityInstantaneous(ang:Forward() * math.Rand(560,690))
			end
			end
		end
			
		end)
		
		timer.Simple(1.6, function() 
		if !self:IsValid() then return end
		if self:Health() < 0 then return end
		
		if !self.Enemy:IsValid() then 
		self:StartActivity( self.WalkAnim )
		self:EmitSound(self.Miss)
		return end
		
		if self.Enemy:Health() < 0 then 
		self:StartActivity( self.WalkAnim )
		self:EmitSound(self.Miss)
		return end
			
		if self.IsFlinching or self.IsReviving then return end
		
		self:EmitSound("physics/flesh/flesh_bloody_break.wav")	
		self:EmitSound("physics/body/body_medium_break"..math.random(2, 4)..".wav", 72, math.Rand(105, 115))
		self:RestartGesture(self.FleshTossAnim)
		
		for i=1,2 do
		flesh = ents.Create("burning_flesh") 
		if flesh:IsValid() then
		flesh:SetPos(self:EyePos() + Vector(0,0,30))
		flesh:SetOwner(self)
		flesh:Spawn()
	
		local phys = flesh:GetPhysicsObject()
			if phys:IsValid() then
				local ang = self:EyeAngles()
				ang:RotateAroundAxis(ang:Forward(), math.Rand(-5, 5))
				ang:RotateAroundAxis(ang:Up(), math.Rand(-5, 5))
				phys:SetVelocityInstantaneous(ang:Forward() * math.Rand(560,690))
			end
			end
		end
			
		end)
		
		timer.Simple(1.3, function() 
		if !self:IsValid() then return end
		if self:Health() < 0 then return end
		
		if !self.Enemy:IsValid() then 
		self:StartActivity( self.WalkAnim )
		self:EmitSound(self.Miss)
		return end
		
		if self.Enemy:Health() < 0 then 
		self:StartActivity( self.WalkAnim )
		self:EmitSound(self.Miss)
		return end
			
		if self.IsFlinching or self.IsReviving then return end
		
		self:EmitSound("physics/flesh/flesh_bloody_break.wav")	
		self:EmitSound("physics/body/body_medium_break"..math.random(2, 4)..".wav", 72, math.Rand(105, 115))
		self:RestartGesture(self.FleshTossAnim)
		
		for i=1,2 do
		flesh = ents.Create("burning_flesh") 
		if flesh:IsValid() then
		flesh:SetPos(self:EyePos() + Vector(0,0,30))
		flesh:SetOwner(self)
		flesh:Spawn()
	
		local phys = flesh:GetPhysicsObject()
			if phys:IsValid() then
				local ang = self:EyeAngles()
				ang:RotateAroundAxis(ang:Forward(), math.Rand(-5, 5))
				ang:RotateAroundAxis(ang:Up(), math.Rand(-5, 5))
				phys:SetVelocityInstantaneous(ang:Forward() * math.Rand(560,690))
			end
			end
		end
			
		end)
		
		timer.Simple(1.1, function() 
		if !self:IsValid() then return end
		if self:Health() < 0 then return end
		
		if !self.Enemy:IsValid() then 
		self:StartActivity( self.WalkAnim )
		self:EmitSound(self.Miss)
		return end
		
		if self.Enemy:Health() < 0 then 
		self:StartActivity( self.WalkAnim )
		self:EmitSound(self.Miss)
		return end
			
		if self.IsFlinching or self.IsReviving then return end
		
		self:EmitSound("physics/flesh/flesh_bloody_break.wav")	
		self:EmitSound("physics/body/body_medium_break"..math.random(2, 4)..".wav", 72, math.Rand(105, 115))
		self:RestartGesture(self.FleshTossAnim)
		
		for i=1,2 do
		flesh = ents.Create("burning_flesh") 
		if flesh:IsValid() then
		flesh:SetPos(self:EyePos() + Vector(0,0,30))
		flesh:SetOwner(self)
		flesh:Spawn()
	
		local phys = flesh:GetPhysicsObject()
			if phys:IsValid() then
				local ang = self:EyeAngles()
				ang:RotateAroundAxis(ang:Forward(), math.Rand(-5, 5))
				ang:RotateAroundAxis(ang:Up(), math.Rand(-5, 5))
				phys:SetVelocityInstantaneous(ang:Forward() * math.Rand(560,690))
			end
			end
		end
			
		end)
			
		timer.Simple(0.8, function() 
		if !self:IsValid() then return end
		if self:Health() < 0 then return end
		
		if !self.Enemy:IsValid() then 
		self:StartActivity( self.WalkAnim )
		self:EmitSound(self.Miss)
		return end
		
		if self.Enemy:Health() < 0 then 
		self:StartActivity( self.WalkAnim )
		self:EmitSound(self.Miss)
		return end
			
		if self.IsFlinching or self.IsReviving then return end
		
		self:EmitSound("physics/flesh/flesh_bloody_break.wav")	
		self:EmitSound("physics/body/body_medium_break"..math.random(2, 4)..".wav", 72, math.Rand(105, 115))
		self:RestartGesture(self.FleshTossAnim)
		
		for i=1,2 do
		flesh = ents.Create("burning_flesh") 
		if flesh:IsValid() then
		flesh:SetPos(self:EyePos() + Vector(0,0,30))
		flesh:SetOwner(self)
		flesh:Spawn()
	
		local phys = flesh:GetPhysicsObject()
			if phys:IsValid() then
				local ang = self:EyeAngles()
				ang:RotateAroundAxis(ang:Forward(), math.Rand(-5, 5))
				ang:RotateAroundAxis(ang:Up(), math.Rand(-5, 5))
				phys:SetVelocityInstantaneous(ang:Forward() * math.Rand(560,690))
			end
			end
		end
			
		end)
		
		timer.Simple(0.7, function() 
		if !self:IsValid() then return end
		if self:Health() < 0 then return end
		
		if !self.Enemy:IsValid() then 
		self:StartActivity( self.WalkAnim )
		self:EmitSound(self.Miss)
		return end
		
		if self.Enemy:Health() < 0 then 
		self:StartActivity( self.WalkAnim )
		self:EmitSound(self.Miss)
		return end
			
		if self.IsFlinching or self.IsReviving then return end
		
		self:EmitSound("physics/flesh/flesh_bloody_break.wav")	
		self:EmitSound("physics/body/body_medium_break"..math.random(2, 4)..".wav", 72, math.Rand(105, 115))
		self:RestartGesture(self.FleshTossAnim)
		
		for i=1,2 do
		flesh = ents.Create("burning_flesh") 
		if flesh:IsValid() then
		flesh:SetPos(self:EyePos() + Vector(0,0,30))
		flesh:SetOwner(self)
		flesh:Spawn()
	
		local phys = flesh:GetPhysicsObject()
			if phys:IsValid() then
				local ang = self:EyeAngles()
				ang:RotateAroundAxis(ang:Forward(), math.Rand(-5, 5))
				ang:RotateAroundAxis(ang:Up(), math.Rand(-5, 5))
				phys:SetVelocityInstantaneous(ang:Forward() * math.Rand(560,690))
			end
			end
		end
			
		end)
		
		timer.Simple(0.5, function() 
		if !self:IsValid() then return end
		if self:Health() < 0 then return end
		
		if !self.Enemy:IsValid() then 
		self:StartActivity( self.WalkAnim )
		self:EmitSound(self.Miss)
		return end
		
		if self.Enemy:Health() < 0 then 
		self:StartActivity( self.WalkAnim )
		self:EmitSound(self.Miss)
		return end
			
		if self.IsFlinching or self.IsReviving then return end
		
		self:EmitSound("physics/flesh/flesh_bloody_break.wav")	
		self:EmitSound("physics/body/body_medium_break"..math.random(2, 4)..".wav", 72, math.Rand(105, 115))
		self:RestartGesture(self.FleshTossAnim)
		
		for i=1,2 do
		flesh = ents.Create("burning_flesh") 
		if flesh:IsValid() then
		flesh:SetPos(self:EyePos() + Vector(0,0,30))
		flesh:SetOwner(self)
		flesh:Spawn()
	
		local phys = flesh:GetPhysicsObject()
			if phys:IsValid() then
				local ang = self:EyeAngles()
				ang:RotateAroundAxis(ang:Forward(), math.Rand(-5, 5))
				ang:RotateAroundAxis(ang:Up(), math.Rand(-5, 5))
				phys:SetVelocityInstantaneous(ang:Forward() * math.Rand(560,690))
			end
			end
		end
			
		end)
		
		else
	if attack == 2 then
	
		self:EmitSound("npc/barnacle/barnacle_die2.wav")
		self:EmitSound("npc/barnacle/barnacle_digesting1.wav")
		self:EmitSound("npc/barnacle/barnacle_digesting2.wav")
	
		self:RestartGesture(self.EruptionAnim)
	
		timer.Simple(1.9, function() 
		if !self:IsValid() then return end
		if self:Health() < 0 then return end
		
		if !self.Enemy:IsValid() then 
		self:StartActivity( self.WalkAnim )
		self:EmitSound(self.Miss)
		return end
		
		if self.Enemy:Health() < 0 then 
		self:StartActivity( self.WalkAnim )
		self:EmitSound(self.Miss)
		return end
			
		if self.IsFlinching or self.IsReviving then return end
		
		self:EmitSound("physics/flesh/flesh_bloody_break.wav")	
		self:EmitSound("physics/body/body_medium_break"..math.random(2, 4)..".wav", 72, math.Rand(105, 115))
		
		for i=1,2 do
		flesh = ents.Create("burning_flesh") 
		if flesh:IsValid() then
		flesh:SetPos(self:EyePos() + Vector(0,0,30))
		flesh:SetOwner(self)
		flesh:Spawn()
	
		local phys = flesh:GetPhysicsObject()
			if phys:IsValid() then
				local ang = self:EyeAngles()
				ang:RotateAroundAxis(ang:Forward(), math.Rand(-205,205))
				ang:RotateAroundAxis(ang:Up(), math.Rand(-205, 205))
				phys:SetVelocityInstantaneous(ang:Forward() * math.Rand(560,690))
			end
			end
		end
			
		end)
		
		timer.Simple(1.6, function() 
		if !self:IsValid() then return end
		if self:Health() < 0 then return end
		
		if !self.Enemy:IsValid() then 
		self:StartActivity( self.WalkAnim )
		self:EmitSound(self.Miss)
		return end
		
		if self.Enemy:Health() < 0 then 
		self:StartActivity( self.WalkAnim )
		self:EmitSound(self.Miss)
		return end
			
		if self.IsFlinching or self.IsReviving then return end
		
		self:EmitSound("physics/flesh/flesh_bloody_break.wav")	
		self:EmitSound("physics/body/body_medium_break"..math.random(2, 4)..".wav", 72, math.Rand(105, 115))
		
		for i=1,2 do
		flesh = ents.Create("burning_flesh") 
		if flesh:IsValid() then
		flesh:SetPos(self:EyePos() + Vector(0,0,30))
		flesh:SetOwner(self)
		flesh:Spawn()
	
		local phys = flesh:GetPhysicsObject()
			if phys:IsValid() then
				local ang = self:EyeAngles()
				ang:RotateAroundAxis(ang:Forward(), math.Rand(-205, 205))
				ang:RotateAroundAxis(ang:Up(), math.Rand(-205, 205))
				phys:SetVelocityInstantaneous(ang:Forward() * math.Rand(560,690))
			end
			end
		end
			
		end)
		
		timer.Simple(1.3, function() 
		if !self:IsValid() then return end
		if self:Health() < 0 then return end
		
		if !self.Enemy:IsValid() then 
		self:StartActivity( self.WalkAnim )
		self:EmitSound(self.Miss)
		return end
		
		if self.Enemy:Health() < 0 then 
		self:StartActivity( self.WalkAnim )
		self:EmitSound(self.Miss)
		return end
			
		if self.IsFlinching or self.IsReviving then return end
		
		self:EmitSound("physics/flesh/flesh_bloody_break.wav")	
		self:EmitSound("physics/body/body_medium_break"..math.random(2, 4)..".wav", 72, math.Rand(105, 115))
		
		for i=1,2 do
		flesh = ents.Create("burning_flesh") 
		if flesh:IsValid() then
		flesh:SetPos(self:EyePos() + Vector(0,0,30))
		flesh:SetOwner(self)
		flesh:Spawn()
	
		local phys = flesh:GetPhysicsObject()
			if phys:IsValid() then
				local ang = self:EyeAngles()
				ang:RotateAroundAxis(ang:Forward(), math.Rand(-205, 205))
				ang:RotateAroundAxis(ang:Up(), math.Rand(-205, 205))
				phys:SetVelocityInstantaneous(ang:Forward() * math.Rand(560,690))
			end
			end
		end
			
		end)
		
		timer.Simple(1.1, function() 
		if !self:IsValid() then return end
		if self:Health() < 0 then return end
		
		if !self.Enemy:IsValid() then 
		self:StartActivity( self.WalkAnim )
		self:EmitSound(self.Miss)
		return end
		
		if self.Enemy:Health() < 0 then 
		self:StartActivity( self.WalkAnim )
		self:EmitSound(self.Miss)
		return end
			
		if self.IsFlinching or self.IsReviving then return end
		
		self:EmitSound("physics/flesh/flesh_bloody_break.wav")	
		self:EmitSound("physics/body/body_medium_break"..math.random(2, 4)..".wav", 72, math.Rand(105, 115))
		
		for i=1,2 do
		flesh = ents.Create("burning_flesh") 
		if flesh:IsValid() then
		flesh:SetPos(self:EyePos() + Vector(0,0,30))
		flesh:SetOwner(self)
		flesh:Spawn()
	
		local phys = flesh:GetPhysicsObject()
			if phys:IsValid() then
				local ang = self:EyeAngles()
				ang:RotateAroundAxis(ang:Forward(), math.Rand(-205, 205))
				ang:RotateAroundAxis(ang:Up(), math.Rand(-205, 205))
				phys:SetVelocityInstantaneous(ang:Forward() * math.Rand(560,690))
			end
			end
		end
			
		end)
			
		timer.Simple(0.8, function() 
		if !self:IsValid() then return end
		if self:Health() < 0 then return end
		
		if !self.Enemy:IsValid() then 
		self:StartActivity( self.WalkAnim )
		self:EmitSound(self.Miss)
		return end
		
		if self.Enemy:Health() < 0 then 
		self:StartActivity( self.WalkAnim )
		self:EmitSound(self.Miss)
		return end
			
		if self.IsFlinching or self.IsReviving then return end
		
		self:EmitSound("physics/flesh/flesh_bloody_break.wav")	
		self:EmitSound("physics/body/body_medium_break"..math.random(2, 4)..".wav", 72, math.Rand(105, 115))
		
		for i=1,2 do
		flesh = ents.Create("burning_flesh") 
		if flesh:IsValid() then
		flesh:SetPos(self:EyePos() + Vector(0,0,30))
		flesh:SetOwner(self)
		flesh:Spawn()
	
		local phys = flesh:GetPhysicsObject()
			if phys:IsValid() then
				local ang = self:EyeAngles()
				ang:RotateAroundAxis(ang:Forward(), math.Rand(-205, 205))
				ang:RotateAroundAxis(ang:Up(), math.Rand(-205, 205))
				phys:SetVelocityInstantaneous(ang:Forward() * math.Rand(560,690))
			end
			end
		end
			
		end)
		
		timer.Simple(0.7, function() 
		if !self:IsValid() then return end
		if self:Health() < 0 then return end
		
		if !self.Enemy:IsValid() then 
		self:StartActivity( self.WalkAnim )
		self:EmitSound(self.Miss)
		return end
		
		if self.Enemy:Health() < 0 then 
		self:StartActivity( self.WalkAnim )
		self:EmitSound(self.Miss)
		return end
			
		if self.IsFlinching or self.IsReviving then return end
		
		self:EmitSound("physics/flesh/flesh_bloody_break.wav")	
		self:EmitSound("physics/body/body_medium_break"..math.random(2, 4)..".wav", 72, math.Rand(105, 115))
		
		for i=1,2 do
		flesh = ents.Create("burning_flesh") 
		if flesh:IsValid() then
		flesh:SetPos(self:EyePos() + Vector(0,0,30))
		flesh:SetOwner(self)
		flesh:Spawn()
	
		local phys = flesh:GetPhysicsObject()
			if phys:IsValid() then
				local ang = self:EyeAngles()
				ang:RotateAroundAxis(ang:Forward(), math.Rand(-205, 205))
				ang:RotateAroundAxis(ang:Up(), math.Rand(-205, 205))
				phys:SetVelocityInstantaneous(ang:Forward() * math.Rand(560,690))
			end
			end
		end
			
		end)
		
		timer.Simple(0.5, function() 
		if !self:IsValid() then return end
		if self:Health() < 0 then return end
		
		if !self.Enemy:IsValid() then 
		self:StartActivity( self.WalkAnim )
		self:EmitSound(self.Miss)
		return end
		
		if self.Enemy:Health() < 0 then 
		self:StartActivity( self.WalkAnim )
		self:EmitSound(self.Miss)
		return end
			
		if self.IsFlinching or self.IsReviving then return end
		
		self:EmitSound("physics/flesh/flesh_bloody_break.wav")	
		self:EmitSound("physics/body/body_medium_break"..math.random(2, 4)..".wav", 72, math.Rand(105, 115))
		
		for i=1,2 do
		flesh = ents.Create("burning_flesh") 
		if flesh:IsValid() then
		flesh:SetPos(self:EyePos() + Vector(0,0,30))
		flesh:SetOwner(self)
		flesh:Spawn()
	
		local phys = flesh:GetPhysicsObject()
			if phys:IsValid() then
				local ang = self:EyeAngles()
				ang:RotateAroundAxis(ang:Forward(), math.Rand(-205, 205))
				ang:RotateAroundAxis(ang:Up(), math.Rand(-205, 205))
				phys:SetVelocityInstantaneous(ang:Forward() * math.Rand(560,690))
			end
			end
		end
			
		end)
		
		end
		end
		self.IsAttacking = true

		self:StartActivity( self.WalkAnim )
		self.IsAttacking = false
		end

end

function ENT:IdleSounds()
end
	
function ENT:AttackProp()
	local entstoattack = ents.FindInSphere(self:GetPos(), 25)
	for _,v in pairs(entstoattack) do
	
		if (v:GetClass() == "prop_physics") then
		
		if SERVER then
		local sounds = {}
	sounds[1] = (self.Attack1)
	sounds[2] = (self.Attack2)
		self:EmitSound( sounds[math.random(1,2)] )
		end
	
		self:RestartGesture(self.AttackAnim)  
		self:SetPoseParameter("move_x",0)
		coroutine.wait(self.AttackWaitTime)
		self:EmitSound(self.Miss)
		
		if !self:IsValid() then return end
		if self:Health() < 0 then return end
		
		if !v:IsValid() then 
		self:StartActivity( self.WalkAnim )
		self:SetPoseParameter("move_x",self.WalkSpeedAnimation)
		self:EmitSound(self.Miss)
		return end
		
		if v:Health() < 0 then 
		self:StartActivity( self.WalkAnim )
		self:SetPoseParameter("move_x",self.WalkSpeedAnimation)
		self:EmitSound(self.Miss)
		return end
		
		if (self:GetRangeTo(v) < 60) then

		local phys = v:GetPhysicsObject()
			if (phys != nil && phys != NULL && phys:IsValid()) then
			phys:ApplyForceCenter(self:GetForward():GetNormalized()*30000 + Vector(0, 0, 2))
			v:EmitSound(self.DoorBreak)
			v:TakeDamage( self.Damage, self)	
			end
			
		end
		coroutine.wait(self.AttackFinishTime)	
		self:SetPoseParameter("move_x",self.WalkSpeedAnimation)
		self:StartActivity( self.WalkAnim )
			return true
		end
	end
	return false
end

function ENT:AttackBreakable()
	local entstoattack = ents.FindInSphere(self:GetPos(), 25)
	for _,v in pairs(entstoattack) do
	
		if (v:GetClass() == "func_breakable") then
		
		if SERVER then
		local sounds = {}
	sounds[1] = (self.Attack1)
	sounds[2] = (self.Attack2)
		self:EmitSound( sounds[math.random(1,2)] )
		end
	
	
		self:RestartGesture(self.AttackAnim)  
		self:SetPoseParameter("move_x",0)
		coroutine.wait(self.AttackWaitTime)
		self:EmitSound(self.Miss)
		
		if !self:IsValid() then return end
		if self:Health() < 0 then return end
		
		if !v:IsValid() then 
		self:StartActivity( self.WalkAnim )
		self:SetPoseParameter("move_x",self.WalkSpeedAnimation)
		self:EmitSound(self.Miss)
		return end
		
		if v:Health() < 0 then 
		self:StartActivity( self.WalkAnim )
		self:SetPoseParameter("move_x",self.WalkSpeedAnimation)
		self:EmitSound(self.Miss)
		return end
		
			v:EmitSound(self.DoorBreak)
			v:TakeDamage( self.Damage, self)	
			
		coroutine.wait(self.AttackFinishTime)
		self:SetPoseParameter("move_x",self.WalkSpeedAnimation)		
		self:StartActivity( self.WalkAnim )
			return true
		end
	end
	return false
end

function ENT:RunBehaviour()
	while ( true ) do
		if ( self:HaveEnemy() ) then
		self.HasNoEnemy = false
			self:StartActivity( self.WalkAnim )
			self.loco:SetDesiredSpeed( self.Speed )
			self:SetPoseParameter("move_x",self.WalkSpeedAnimation)
			
			self:ChaseEnemy() 
		else
			-- Wander around
		self.HasNoEnemy = true
			self:StartActivity( self.WalkAnim )
			self.loco:SetDesiredSpeed( self.Speed )
			self:SetPoseParameter("move_x",self.WalkSpeedAnimation)
			
			self:MoveToPos( self:GetPos() + Vector( math.Rand( -1, 1 ), math.Rand( -1, 1 ), 0 ) * 400 )
			self:SetPoseParameter("move_x",0)
		end
		coroutine.wait( 2 )
		self:IdleSounds()
	end
end	

function ENT:OnKilled( dmginfo )
	
	local zombie = ents.Create("boss8_deathanim")
			if !self:IsValid() then return end
			if zombie:IsValid() then 
			zombie:SetPos(self:GetPos())
			zombie:SetModel(self:GetModel())
			zombie:SetAngles(self:GetAngles())
			zombie:Spawn()
			zombie:SetColor( Color(255, 185, 185, 255) )
			zombie:SetSkin(self:GetSkin())
			zombie:SetMaterial(self:GetMaterial())
			self:Remove()
			end
end

function ENT:OnInjured( dmginfo )

	if self.HasNoEnemy and dmginfo:GetAttacker():IsPlayer() then
		if self:IsValid() and self:Health() > 0 then
	local attacker = dmginfo:GetAttacker()
	self.SearchRadius 	= self:GetRangeTo(attacker) + 1000
	self.Enemy = attacker
	end -- If we don't have an enemy and we get injured by a player then we chase the player
		end

	if !dmginfo:GetAttacker():IsPlayer() then
		if dmginfo:GetAttacker():GetClass("nazi_zombie_*", "npc_nextbot_*", "mob_zombie_*") then
			if dmginfo:IsExplosionDamage() then
			dmginfo:ScaleDamage(0)
			end
		end
	end
	
	if dmginfo:IsExplosionDamage() then
	dmginfo:ScaleDamage(10)
	else
	dmginfo:ScaleDamage(0.8)
	end

	if math.random( 1,5 ) == 2 then
	self:EmitSound("physics/flesh/flesh_bloody_break.wav")	
	self:EmitSound("physics/body/body_medium_break"..math.random(2, 4)..".wav", 72, math.Rand(105, 115))
	end
	
end
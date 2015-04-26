AddCSLuaFile()

ENT.Base             = "base_nextbot"
ENT.Spawnable        = false
ENT.AdminSpawnable   = false


--Stats--
ENT.Speed = 55
ENT.WalkSpeedAnimation = 1
ENT.FlinchSpeed = 0

ENT.health = 800
ENT.Damage = 35

ENT.AttackWaitTime = 0.8
ENT.AttackFinishTime = 0.2

ENT.FallDamage = 0


--Model Settings--
ENT.Model = "models/player/zombie_soldier.mdl"
ENT.AttackAnim = (ACT_GMOD_GESTURE_RANGE_ZOMBIE)

ENT.WalkAnim = (ACT_HL2MP_WALK_ZOMBIE_05)

ENT.FlinchAnim = (ACT_HL2MP_ZOMBIE_SLUMP_RISE)
ENT.FallAnim = (ACT_HL2MP_WALK_ZOMBIE_01)

ENT.AttackDoorAnim = (ACT_GMOD_GESTURE_RANGE_ZOMBIE)

--Sounds--
ENT.Attack1 = Sound("npc/slow_zombie/zo_attack1.wav")
ENT.Attack2 = Sound("npc/slow_zombie/zo_attack2.wav")

ENT.DoorBreak = Sound("npc/zombie/zombie_pound_door.wav")

ENT.Alert1 = Sound("npc/zombie/zombie_alert1.wav")
ENT.Alert2 = Sound("npc/zombie/zombie_alert2.wav")
ENT.Alert3 = Sound("npc/zombie/zombie_alert3.wav")

ENT.Death1 = Sound("npc/zombie/zombie_die1.wav")
ENT.Death2 = Sound("npc/zombie/zombie_die2.wav")
ENT.Death3 = Sound("npc/zombie/zombie_die3.wav")

ENT.Flinch1 = Sound("npc/zombie/zombie_voice_idle10.wav")
ENT.Flinch2 = Sound("npc/zombie/zombie_voice_idle11.wav")
ENT.Flinch3 = Sound("npc/zombie/zombie_voice_idle12.wav")

ENT.Fall1 = Sound("npc/zombie/zombie_voice_idle11.wav")
ENT.Fall2 = Sound("npc/zombie/zombie_voice_idle13.wav")

ENT.Idle1 = Sound("npc/slow_zombie/zombie_voice_idle1.wav")
ENT.Idle2 = Sound("npc/slow_zombie/zombie_voice_idle2.wav")
ENT.Idle3 = Sound("npc/slow_zombie/zombie_voice_idle3.wav")
ENT.Idle4 = Sound("npc/slow_zombie/zombie_voice_idle4.wav")
ENT.Idle5 = Sound("npc/slow_zombie/zombie_voice_idle5.wav")
ENT.Idle6 = Sound("npc/slow_zombie/zombie_voice_idle6.wav")
ENT.Idle7 = Sound("npc/slow_zombie/zombie_voice_idle7.wav")
ENT.Idle8 = Sound("npc/slow_zombie/zombie_voice_idle8.wav")
ENT.Idle9 = Sound("npc/slow_zombie/zombie_voice_idle9.wav")

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

util.PrecacheSound("npc/zombie/zombie_voice_idle6.wav")
util.PrecacheSound("npc/zombie/zombie_voice_idle11.wav")

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
	self:SetModelScale(1.4,0)
	self:SetMaterial("models/Combine_Soldier/zombineelite_ssheet_zombie")
	
    self:SetModel(self.Model)
	self:SetHealth(self.health)
	
	self.LoseTargetDist	= 4000	-- How far the enemy has to be before we lose them
	self.SearchRadius 	= 3000	-- How far to search for enemies
	
	self.IsFlinching = false
	self.IsAttacking = false
	self.HasNoEnemy = false
	
	--Misc--
	self:Precache()
	self.loco:SetStepHeight(35)	
	self.loco:SetAcceleration(400)
	self.loco:SetDeceleration(900)
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
        tr.endpos = tr.start - ang:Right()*6 + ang:Forward()*5
        tr.filter = self
        tr = util.TraceLine(tr)

        if tr.Hit && !self.FeetOnGround then
		self:EmitSound("physics/concrete/concrete_break"..math.random(2,3)..".wav", 70, math.random(65,75))
		
		local asd = ents.FindInSphere(self:GetPos(), 255)
		for _,v in pairs(asd) do
		
			if (v:IsPlayer()) then
		
		v:ViewPunch(Angle(math.random(-1, 3), math.random(-1, 3), math.random(-1, 5)))
		
			end
		end
		
        end

        self.FeetOnGround = tr.Hit
		
	-- Second Step
		local bones2 = self:LookupBone("ValveBiped.Bip01_L_Foot")
		
        local pos2, ang2 = self:GetBonePosition(bones2)

        local tr = {}
        tr.start = pos2 
        tr.endpos = tr.start - ang2:Right()*6 + ang2:Forward()*5
        tr.filter = self
        tr = util.TraceLine(tr)

        if tr.Hit && !self.FeetOnGround2 then
		self:EmitSound("physics/concrete/concrete_break"..math.random(2,3)..".wav", 70, math.random(65,75))
		
		local asd = ents.FindInSphere(self:GetPos(), 255)
		for _,v in pairs(asd) do
		
			if (v:IsPlayer()) then
		
		v:ViewPunch(Angle(math.random(-1, 3), math.random(-1, 3), math.random(-1, 5)))
		
			end
		end
		
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
		self:SetPlaybackRate(0.8)
		self:EmitSound("npc/infected_zombies/claw_miss_"..math.random(2)..".wav", math.random(95,95), math.random(65,75))
		return end
		
		if v:Health() < 0 then 
		self:StartActivity( self.WalkAnim )
		self:SetPoseParameter("move_x",self.WalkSpeedAnimation)	
		self:SetPlaybackRate(0.8)
		self:EmitSound("npc/infected_zombies/claw_miss_"..math.random(2)..".wav", math.random(95,95), math.random(65,75))
		return end
						
							if (self:GetRangeTo(v) < 25) then
							
					if SERVER then
					local sounds = {}
					sounds[1] = (self.Attack1)
					sounds[2] = (self.Attack2)
					self:EmitSound( sounds[math.random(1,2)] )
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
						self.loco:SetDesiredSpeed(self.Speed)
						self:SetPlaybackRate(0.8)
						end
						end
						end
						end

		local ent = ents.FindInSphere(self:GetPos(),100)
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
		
		if self.IsReviving or self.IsFlinching then
		else
		
		if SERVER then
		local sounds = {}
	sounds[1] = (self.Attack1)
	sounds[2] = (self.Attack2)
		self:EmitSound( sounds[math.random(1,2)], 95, math.random(60,75) )
		end
		
		self:RestartGesture(self.AttackAnim)
		self.Enemy = self.Enemy	
		self.IsAttacking = true
		
		timer.Simple( 0.8, function()
		
		if !self:IsValid() then return end
		if self:Health() < 0 then return end
		
		if !self.Enemy:IsValid() then 
		self:StartActivity( self.WalkAnim )
		self:SetPoseParameter("move_x",self.WalkSpeedAnimation)
		self:SetPlaybackRate(0.8)
		self:EmitSound("npc/infected_zombies/claw_miss_"..math.random(2)..".wav", math.random(95,95), math.random(65,75))
		return end
		
		if self.Enemy:Health() < 0 then 
		self:StartActivity( self.WalkAnim )
		self:SetPoseParameter("move_x",self.WalkSpeedAnimation)
		self:SetPlaybackRate(0.8)
		self:EmitSound("npc/infected_zombies/claw_miss_"..math.random(2)..".wav", math.random(95,95), math.random(65,75))
		return end
		
		if (self:GetRangeTo(self.Enemy) < 70) then
		self:EmitSound(self.Hit)
		self.Enemy:TakeDamage( self.Damage, self)	
		self.Enemy:ViewPunch(Angle(math.random(-1, 1)*self.Damage, math.random(-1, 1)*self.Damage, math.random(-1, 1)*self.Damage))
		
		local bleed = ents.Create("info_particle_system")
		bleed:SetKeyValue("effect_name", "blood_impact_red_01")
		bleed:SetPos(self.Enemy:GetPos() + Vector(0,0,70)) 
		bleed:Spawn()
		bleed:Activate() 
		bleed:Fire("Start", "", 0)
		bleed:Fire("Kill", "", 0.2)
		
		local moveAdd=Vector(0,0,350)
		if not self.Enemy:IsOnGround() then
		moveAdd=Vector(0,0,0)
		end
		self.Enemy:SetVelocity(moveAdd+((self.Enemy:GetPos()-self:GetPos()):GetNormal()*50)) -- apply the velocity

			end
			self:EmitSound("npc/infected_zombies/claw_miss_"..math.random(2)..".wav", math.random(95,95), math.random(65,75))	
		end)

		self.IsAttacking = false
		self:StartActivity( self.WalkAnim )	
		self:SetPoseParameter("move_x",self.WalkSpeedAnimation)
		self:SetPlaybackRate(0.8)
		end
		end
end

function ENT:IdleSounds()
if SERVER then
	if math.random( 1,3 ) == 1 then
	local sounds = {}
	sounds[1] = (self.Idle1)
	sounds[2] = (self.Idle2)
	sounds[3] = (self.Idle3)
	sounds[4] = (self.Idle4)
	sounds[5] = (self.Idle5)
	sounds[6] = (self.Idle6)
	sounds[7] = (self.Idle7)
	sounds[8] = (self.Idle8)
	sounds[9] = (self.Idle9)
		self:EmitSound( sounds[math.random(1,9)], 95, math.random(60,75) )
	end
		end		
end
	
function ENT:AttackProp()

if !self.nxtAttackProp then self.nxtAttackProp = 0 end
    if CurTime() < self.nxtAttackProp then return end

    self.nxtAttackProp = CurTime() + 1

	local entstoattack = ents.FindInSphere(self:GetPos(), 25)
	for _,v in pairs(entstoattack) do
	
		if (v:GetClass() == "prop_physics") then
		
		local phys = v:GetPhysicsObject()
		if (phys != nil && phys != NULL && phys:IsValid()) then
			if phys:IsMotionEnabled() and phys:GetSurfaceArea() < 60000 and phys:GetMass() < 3025 then
			
			if SERVER then
		local sounds = {}
	sounds[1] = (self.Attack1)
	sounds[2] = (self.Attack2)
		self:EmitSound( sounds[math.random(1,2)], 95, math.random(60,75) )
		end
			
			self:RestartGesture( ACT_GMOD_GESTURE_TAUNT_ZOMBIE )  
			self.IsAttacking = true
			v:SetParent( self )
			v:Fire("setparentattachment", "Anim_Attachment_LH", 0.01)
			
		timer.Simple(1.5, function()
		if !self:IsValid() then return end
		if self:Health() < 0 then return end
		
		if !v:IsValid() then 
		self:StartActivity( self.WalkAnim )
		self:SetPoseParameter("move_x",self.WalkSpeedAnimation)
		self:EmitSound("npc/infected_zombies/claw_miss_"..math.random(2)..".wav", math.random(95,95), math.random(65,75))
		return end
		
		if v:Health() < 0 then 
		self:StartActivity( self.WalkAnim )
		self:SetPoseParameter("move_x",self.WalkSpeedAnimation)
		self:EmitSound("npc/infected_zombies/claw_miss_"..math.random(2)..".wav", math.random(95,95), math.random(65,75))
		return end
		
		if SERVER then
		local sounds = {}
	sounds[1] = (self.Attack1)
	sounds[2] = (self.Attack2)
		self:EmitSound( sounds[math.random(1,2)], 95, math.random(60,75) )
		end
		
		self:RestartGesture( ACT_GMOD_GESTURE_ITEM_THROW )  
			
			timer.Simple(0.8, function()
		if !self:IsValid() then return end
		if self:Health() < 0 then return end
		
		if !v:IsValid() then 
		self:StartActivity( self.WalkAnim )
		self:SetPlaybackRate(0.8)
		self:SetPoseParameter("move_x",self.WalkSpeedAnimation)
		self:EmitSound("npc/infected_zombies/claw_miss_"..math.random(2)..".wav", math.random(95,95), math.random(65,75))
		return end
		
		if v:Health() < 0 then 
		self:StartActivity( self.WalkAnim )
		self:SetPlaybackRate(0.8)
		self:SetPoseParameter("move_x",self.WalkSpeedAnimation)
		self:EmitSound("npc/infected_zombies/claw_miss_"..math.random(2)..".wav", math.random(95,95), math.random(65,75))
		return end
			
			self:EmitSound("npc/infected_zombies/claw_miss_"..math.random(2)..".wav", math.random(75,95), math.random(65,95))	
			v:Remove()
			
			local fakeprop = ents.Create("ent_fakeprop")
			fakeprop:SetModel(v:GetModel())
			fakeprop:SetPos(v:GetPos())
			fakeprop:SetMaterial(v:GetMaterial())
			fakeprop:SetSkin(v:GetSkin())
			fakeprop:Spawn()
			
			local phys = fakeprop:GetPhysicsObject()
			if (phys != nil && phys != NULL && phys:IsValid()) then
			phys:EnableMotion( true )
			phys:EnableGravity( true )
			phys:Wake()
			
				if phys:GetMass() < 75 then
				phys:ApplyForceCenter(self:GetForward():GetNormalized()*60000 + Vector(0, 0, 2))
				else
				if phys:GetMass() < 175 and phys:GetMass() > 75 then
				phys:ApplyForceCenter(self:GetForward():GetNormalized()*80000 + Vector(0, 0, 2))
				end
				if phys:GetMass() < 300 and phys:GetMass() > 175 then
				phys:ApplyForceCenter(self:GetForward():GetNormalized()*250000 + Vector(0, 0, 2))
				end
				if phys:GetMass() < 500 and phys:GetMass() > 300 then
				phys:ApplyForceCenter(self:GetForward():GetNormalized()*500000 + Vector(0, 0, 2))
				end
				if phys:GetMass() < 700 and phys:GetMass() > 500 then
				phys:ApplyForceCenter(self:GetForward():GetNormalized()*600000 + Vector(0, 0, 2))
				end
				if phys:GetMass() < 1000 and phys:GetMass() > 700 then
				phys:ApplyForceCenter(self:GetForward():GetNormalized()*700000 + Vector(0, 0, 2))
				end
				if phys:GetMass() < 1600 and phys:GetMass() > 1000 then
				phys:ApplyForceCenter(self:GetForward():GetNormalized()*800000 + Vector(0, 0, 2))
				end
				end
				
			end
			self.IsAttacking = false
			end)
		end)
		
		else
		
		if SERVER then
		local sounds = {}
	sounds[1] = (self.Attack1)
	sounds[2] = (self.Attack2)
		self:EmitSound( sounds[math.random(1,2)], 95, math.random(60,75) )
		end
	
		self:RestartGesture(self.AttackAnim)  
		self:SetPoseParameter("move_x",0)
		coroutine.wait(self.AttackWaitTime)
		self:EmitSound("npc/infected_zombies/claw_miss_"..math.random(2)..".wav", math.random(95,95), math.random(65,75))
		
		if !self:IsValid() then return end
		if self:Health() < 0 then return end
		
		if !v:IsValid() then 
		self:StartActivity( self.WalkAnim )
		self:SetPoseParameter("move_x",self.WalkSpeedAnimation)
		self:SetPlaybackRate(0.8)
		self:EmitSound("npc/infected_zombies/claw_miss_"..math.random(2)..".wav", math.random(95,95), math.random(65,75))
		return end
		
		if v:Health() < 0 then 
		self:StartActivity( self.WalkAnim )
		self:SetPoseParameter("move_x",self.WalkSpeedAnimation)
		self:SetPlaybackRate(0.8)
		self:EmitSound("npc/infected_zombies/claw_miss_"..math.random(2)..".wav", math.random(95,95), math.random(65,75))
		return end
		
			local phys = v:GetPhysicsObject()
			if (phys != nil && phys != NULL && phys:IsValid()) then
			phys:ApplyForceCenter(self:GetForward():GetNormalized()*30000 + Vector(0, 0, 2))
			end
		
			v:EmitSound(self.DoorBreak)
			v:TakeDamage(self.Damage, self)	
		end	
			
		coroutine.wait(self.AttackFinishTime)	
		self:SetPoseParameter("move_x",self.WalkSpeedAnimation)
		self:StartActivity( self.WalkAnim )
		self:SetPlaybackRate(0.8)
		end
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
		self:EmitSound( sounds[math.random(1,2)], 95, math.random(60,75) )
		end
	
	
		self:RestartGesture(self.AttackAnim)  
		self:SetPoseParameter("move_x",0)
		coroutine.wait(self.AttackWaitTime)
		self:EmitSound("npc/infected_zombies/claw_miss_"..math.random(2)..".wav", math.random(95,95), math.random(65,75))
		
		if !self:IsValid() then return end
		if self:Health() < 0 then return end
		
		if !v:IsValid() then 
		self:StartActivity( self.WalkAnim )
		self:SetPoseParameter("move_x",self.WalkSpeedAnimation)
		self:SetPlaybackRate(0.8)
		self:EmitSound("npc/infected_zombies/claw_miss_"..math.random(2)..".wav", math.random(95,95), math.random(65,75))
		return end
		
		if v:Health() < 0 then 
		self:StartActivity( self.WalkAnim )
		self:SetPoseParameter("move_x",self.WalkSpeedAnimation)
		self:SetPlaybackRate(0.8)
		self:EmitSound("npc/infected_zombies/claw_miss_"..math.random(2)..".wav", math.random(95,95), math.random(65,75))
		return end
		
			v:EmitSound(self.DoorBreak)
			v:TakeDamage(self.Damage, self)	
			
		coroutine.wait(self.AttackFinishTime)
		self:SetPoseParameter("move_x",self.WalkSpeedAnimation)		
		self:StartActivity( self.WalkAnim )
		self:SetPlaybackRate(0.8)
			return true
		end
	end
	return false
end

function ENT:AlertSound()
local alertsounds = {}
	alertsounds[1] = (self.Alert1)
	alertsounds[2] = (self.Alert2)
	alertsounds[3] = (self.Alert3)
	self:EmitSound( alertsounds[math.random(1,3)], 95, math.random(60,75) )
end

function ENT:RunBehaviour()
	while ( true ) do
		if ( self:HaveEnemy() ) then
		self.HasNoEnemy = false
			self:AlertSound()
			self:StartActivity( self.WalkAnim )
			self:SetPlaybackRate(0.8)
			
			self:SetPoseParameter("move_x",self.WalkSpeedAnimation)
			self.loco:SetDesiredSpeed(self.Speed)
			self:ChaseEnemy() 
		else
			-- Wander around
		self.HasNoEnemy = true
			self:StartActivity( self.WalkAnim )
			self:SetPlaybackRate(0.8)
			
			self:SetPoseParameter("move_x",self.WalkSpeedAnimation)
			self.loco:SetDesiredSpeed(self.Speed)
			self:IdleSounds()
			self:MoveToPos( self:GetPos() + Vector( math.Rand( -1, 1 ), math.Rand( -1, 1 ), 0 ) * 300 )
			self:SetPoseParameter("move_x",0)
		end
		coroutine.wait( 1 )
		self:IdleSounds()
	end
end	

	if SERVER then
function ENT:OnKilled( dmginfo )

		local deathsounds = {}
	deathsounds[1] = (self.Death1)
	deathsounds[2] = (self.Death2)
	deathsounds[3] = (self.Death3)
	self:EmitSound( deathsounds[math.random(1,3)], 95, math.random(60,75) )

		local zombie = ents.Create("behemoth_deathanim")
			if !self:IsValid() then return end
			if zombie:IsValid() then 
			zombie:SetPos(self:GetPos())
			zombie:SetModel(self:GetModel())
			zombie:SetAngles(self:GetAngles())
			zombie:Spawn()
			zombie:SetModelScale(1.4, 0)
			zombie:SetSkin(self:GetSkin())
			zombie:SetColor(self:GetColor())
			zombie:SetMaterial(self:GetMaterial())
			self:Remove()
			end
	
end

function ENT:OnInjured( dmginfo )

	if self:Health() > 200 then
		if !dmginfo:IsExplosionDamage() then
		self:EmitSound("hit/boss1_hit.wav")
		local effectdata = EffectData()
		effectdata:SetStart( dmginfo:GetDamagePosition() ) 
		effectdata:SetOrigin( dmginfo:GetDamagePosition() )
		effectdata:SetScale( 1 )
		util.Effect( "StunStickImpact", effectdata )
		end
	end

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
	dmginfo:ScaleDamage(5)
	else
	dmginfo:ScaleDamage(0.7)
	end
	
end
	end
	
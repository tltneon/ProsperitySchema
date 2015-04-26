AddCSLuaFile()

ENT.Base             = "base_nextbot"
ENT.Spawnable        = false
ENT.AdminSpawnable   = false


--Stats--
ENT.Speed = 125
ENT.WalkSpeedAnimation = 3
ENT.FlinchSpeed = 0

ENT.health = 20
ENT.Damage = 2

ENT.AttackWaitTime = 0.2
ENT.AttackFinishTime = 0.2

ENT.FallDamage = 15


--Model Settings--
ENT.Model = "models/vinrax/player/doll_player.mdl"

ENT.AttackAnim = (ACT_GMOD_GESTURE_RANGE_ZOMBIE)
ENT.WalkAnim = (ACT_HL2MP_RUN_ZOMBIE)

ENT.FlinchAnim = (none)
ENT.FallAnim = (none)

ENT.AttackDoorAnim = (ACT_GMOD_GESTURE_RANGE_ZOMBIE_SPECIAL)

--Sounds--
ENT.Attack1 = Sound("npc/zombine/attack1.wav")
ENT.Attack2 = Sound("npc/zombine/attack2.wav")

ENT.Enrage = Sound("")

ENT.Alert1 = Sound("")
ENT.Alert2 = Sound("")
ENT.Alert3 = Sound("")

ENT.DoorBreak = Sound("npc/zombie/zombie_pound_door.wav")

ENT.Death1 = Sound("")
ENT.Death2 = Sound("")
ENT.Death3 = Sound("")

ENT.Flinch1 = Sound("")
ENT.Flinch2 = Sound("")
ENT.Flinch3 = Sound("none")

ENT.Fall1 = Sound("")
ENT.Fall2 = Sound("")

ENT.Idle1 = Sound("")
ENT.Idle2 = Sound("")
ENT.Idle3 = Sound("")
ENT.Idle4 = Sound("")
ENT.Idle5 = Sound("none")
ENT.Idle6 = Sound("none")
ENT.Idle7 = Sound("none")
ENT.Idle8 = Sound("none")
ENT.Idle9 = Sound("none")

ENT.Pain1 = Sound("")
ENT.Pain2 = Sound("")
ENT.Pain3 = Sound("")
ENT.Pain4 = Sound("none")
ENT.Pain5 = Sound("none")
ENT.Pain6 = Sound("none")

ENT.Hit = Sound("npc/zombie/claw_strike1.wav")
ENT.Miss = Sound("npc/zombie/claw_miss1.wav")

function ENT:Precache()
	if SERVER then
--Models--
util.PrecacheModel(self.Model)

--Sounds--	
util.PrecacheSound(self.Attack1)
util.PrecacheSound(self.Attack2)

util.PrecacheSound(self.Enrage)

util.PrecacheSound(self.Alert1)
util.PrecacheSound(self.Alert2)
util.PrecacheSound(self.Alert3)

util.PrecacheSound(self.DoorBreak)

util.PrecacheSound(self.Death1)
util.PrecacheSound(self.Death2)
util.PrecacheSound(self.Death3)

util.PrecacheSound(self.Alert1)
util.PrecacheSound(self.Alert2)
util.PrecacheSound(self.Alert3)

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
end

function ENT:Initialize()

	--Stats--
	if GetConVarNumber("gorechild_collide") == 0 then
	self:SetCollisionGroup(COLLISION_GROUP_DEBRIS)
	end
	self:SetModel(self.Model)
	self:SetHealth(GetConVarNumber("gorechild_health"))
	self:SetModelScale( 0.4, 0 )
	
	self.LoseTargetDist	= GetConVarNumber("gorechild_distcheck")	-- How far the enemy has to be before we lose them
	self.SearchRadius 	= GetConVarNumber("gorechild_dist")	-- How far to search for enemies
	
	self:StartActivity(ACT_HL2MP_ZOMBIE_SLUMP_RISE)
	
	self.IsReviving = true
	self.IsAttacking = false
	self.HasNoEnemy = false
	
	--Misc--
	self:Precache()
	self.loco:SetStepHeight(36)	
	self.loco:SetAcceleration(900)
	self.loco:SetDeceleration(400)
	self.LastPos = self:GetPos()
	self.nextbot = true
end

function ENT:BehaveAct()
end

function ENT:Think()
	if self.IsAttacking then
		if (GetConVarNumber("nb_stop") == 0) then
		self.loco:FaceTowards( self.Enemy:GetPos() )
		end
	end

	self.LastPos = self.Entity:GetPos() 
end

function ENT:OnStuck()
	if self.LastPos:Distance( self.Entity:GetPos() ) < 100 then
		self:SetPos( self.LastPos )
	end
end

function ENT:OnUnStuck()
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

function ENT:AttackProp()
	local entstoattack = ents.FindInSphere(self:GetPos(), 25)
	for _,v in pairs(entstoattack) do
	
		if (v:GetClass() == "prop_physics") then
		
		timer.Simple(0.2, function() 
		if !self:IsValid() then return end
		if self:Health() < 0 then return end
		
		if !v:IsValid() then 
		self:StartActivity( self.WalkAnim )
		self:SetPoseParameter("move_x",self.WalkSpeedAnimation)
		self:EmitSound("npc/zombie/claw_miss"..math.random(2)..".wav", 65, math.random(140, 150))
		return end
		
		if v:Health() < 0 then 
		self:StartActivity( self.WalkAnim )
		self:SetPoseParameter("move_x",self.WalkSpeedAnimation)
		self:EmitSound("npc/zombie/claw_miss"..math.random(2)..".wav", 65, math.random(140, 150))
		return end
		
			if (self:GetRangeTo(v) < 35) then
		self:EmitSound("physics/body/body_medium_impact_hard"..math.random(6)..".wav", 65, math.random(130, 140))
		v:TakeDamage(GetConVarNumber("gorechild_firstattackdmg"), self)	
	
		local phys = v:GetPhysicsObject()
			if (phys != nil && phys != NULL && phys:IsValid()) then
			phys:ApplyForceCenter(self:GetForward():GetNormalized()*5000 + Vector(0, 0, 1))
			end
	
			end
			self:EmitSound("npc/zombie/claw_miss"..math.random(2)..".wav", 65, math.random(140, 150))
		end)
		
		timer.Simple(0.5, function() 
		if !self:IsValid() then return end
		if self:Health() < 0 then return end
		
		if !v:IsValid() then 
		self:StartActivity( self.WalkAnim )
		self:SetPoseParameter("move_x",self.WalkSpeedAnimation)
		self:EmitSound("npc/zombie/claw_miss"..math.random(2)..".wav", 65, math.random(140, 150))
		return end
		
		if v:Health() < 0 then 
		self:StartActivity( self.WalkAnim )
		self:SetPoseParameter("move_x",self.WalkSpeedAnimation)
		self:EmitSound("npc/zombie/claw_miss"..math.random(2)..".wav", 65, math.random(140, 150))
		return end
		
			if (self:GetRangeTo(v) < 35) then
		self:EmitSound("physics/body/body_medium_impact_hard"..math.random(6)..".wav", 65, math.random(130, 140))
		v:TakeDamage(GetConVarNumber("gorechild_secondattackdmg"), self)	
		
		local phys = v:GetPhysicsObject()
			if (phys != nil && phys != NULL && phys:IsValid()) then
			phys:ApplyForceCenter(self:GetForward():GetNormalized()*5000 + Vector(0, 0, 1))
			end
		
			end
			self:EmitSound("npc/zombie/claw_miss"..math.random(2)..".wav", 65, math.random(140, 150))
		end)
		
		self:PlaySequenceAndWait( "zombie_attack_07_original", 1.4 )
		
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
		
		
		timer.Simple(0.2, function() 
		if !self:IsValid() then return end
		if self:Health() < 0 then return end
		
		if !v:IsValid() then 
		self:StartActivity( self.WalkAnim )
		self:SetPoseParameter("move_x",self.WalkSpeedAnimation)
		self:EmitSound("npc/zombie/claw_miss"..math.random(2)..".wav", 65, math.random(140, 150))
		return end
		
		if v:Health() < 0 then 
		self:StartActivity( self.WalkAnim )
		self:SetPoseParameter("move_x",self.WalkSpeedAnimation)
		self:EmitSound("npc/zombie/claw_miss"..math.random(2)..".wav", 65, math.random(140, 150))
		return end
		
			if (self:GetRangeTo(v) < 35) then
		self:EmitSound("physics/body/body_medium_impact_hard"..math.random(6)..".wav", 65, math.random(130, 140))
		v:TakeDamage(GetConVarNumber("gorechild_firstattackdmg"), self)	
	
			end
			self:EmitSound("npc/zombie/claw_miss"..math.random(2)..".wav", 65, math.random(140, 150))
		end)
		
		timer.Simple(0.5, function() 
		if !self:IsValid() then return end
		if self:Health() < 0 then return end
		
		if !v:IsValid() then 
		self:StartActivity( self.WalkAnim )
		self:SetPoseParameter("move_x",self.WalkSpeedAnimation)
		self:EmitSound("npc/zombie/claw_miss"..math.random(2)..".wav", 65, math.random(140, 150))
		return end
		
		if v:Health() < 0 then 
		self:StartActivity( self.WalkAnim )
		self:SetPoseParameter("move_x",self.WalkSpeedAnimation)
		self:EmitSound("npc/zombie/claw_miss"..math.random(2)..".wav", 65, math.random(140, 150))
		return end
		
			if (self:GetRangeTo(v) < 35) then
		self:EmitSound("physics/body/body_medium_impact_hard"..math.random(6)..".wav", 65, math.random(130, 140))
		v:TakeDamage(GetConVarNumber("gorechild_secondattackdmg"), self)	
		
			end
			self:EmitSound("npc/zombie/claw_miss"..math.random(2)..".wav", 65, math.random(140, 150))
		end)
		
		self:PlaySequenceAndWait( "zombie_attack_07_original", 1.4 )
		
		self:StartActivity( self.WalkAnim )
			return true
		end
	end
	return false
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

function ENT:IdleSounds()
end

function ENT:AlertSound()
self:EmitSound("ambient/creatures/teddy.wav", 60, 45)
end

function ENT:RunBehaviour()
	while ( true ) do
		if ( self:HaveEnemy() ) then
		self.HasNoEnemy = false
			self:StartActivity(ACT_HL2MP_ZOMBIE_SLUMP_RISE)
			self:SetPlaybackRate(2)
			self.IsReviving = true
			coroutine.wait( 1.5 )
			self.IsReviving = false
			self:AlertSound()
			
			self:StartActivity(self.WalkAnim)
			self:SetPoseParameter("move_x",self.WalkSpeedAnimation)
			self.loco:SetDesiredSpeed(GetConVarNumber("gorechild_speed"))
			self:ChaseEnemy() 
		else
			-- Wander around
			self.HasNoEnemy = true
			
			self:StartActivity(ACT_HL2MP_ZOMBIE_SLUMP_IDLE)
			self:SetPlaybackRate(0)
			self.loco:SetDesiredSpeed(0)
			coroutine.wait( 1 )
			
			self:IdleSounds()
			
		end
		coroutine.wait( 1 )
		self:EmitSound("ambient/creatures/teddy.wav", 60, 60)
	end
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
	
	if math.random(1,900) == 1 then
	self:EmitSound("ambient/creatures/teddy.wav", 60, 60)
	end
	
	local door = ents.FindInSphere(self:GetPos(),20)
		if door then
			for i = 1, #door do
				local v = door[i]
				if !v:IsPlayer() and v != self and IsValid( v ) then
					if self:GetDoor( v ) == "door" then
					
						if v.Hitsleft == nil then
							v.Hitsleft = 10
						end
						
						if v != NULL and v.Hitsleft > 0 then
							if (self:GetRangeTo(v) < 25) then
							
								timer.Simple(0.6, function() 
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
		
		self:EmitSound("physics/body/body_medium_impact_hard"..math.random(6)..".wav", 65, math.random(130, 140))
		end)
		
	-- Second Hit
		timer.Simple(0.8, function() 
		if !self:IsValid() then return end
		if self:Health() < 0 then return end
		
		if !v:IsValid() then 
		self:StartActivity( self.WalkAnim )
		self:SetPoseParameter("move_x",self.WalkSpeedAnimation)
		self:EmitSound("npc/zombie/claw_miss"..math.random(2)..".wav", 65, math.random(140, 150))
		return end
		
		if v:Health() < 0 then 
		self:StartActivity( self.WalkAnim )
		self:SetPoseParameter("move_x",self.WalkSpeedAnimation)
		self:EmitSound("npc/zombie/claw_miss"..math.random(2)..".wav", 65, math.random(140, 150))
		return end
		
		self:EmitSound("physics/body/body_medium_impact_hard"..math.random(6)..".wav", 65, math.random(130, 140))
		end)
								self:PlaySequenceAndWait( "zombie_attack_07_original", 1 )
								
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
						phys:ApplyForceCenter(self:GetForward():GetNormalized()*50000 + Vector(0, 0, 2))
						end
						
						door:SetSkin(v:GetSkin())
						door:SetColor(v:GetColor())
						door:SetMaterial(v:GetMaterial())
					end
						self:StartActivity( self.WalkAnim )
						end
						end
						end
						end
						
		local ent = ents.FindInSphere(self:GetPos(),90)
	for k,v in pairs( ent ) do
		if (v:IsPlayer() && v:Alive()) then
		self.Enemy = v
		self:Attack()
		end
	end	
		
		if (self:GetRangeTo(self.Enemy) < 55 or self:AttackProp()) then
			else
			if (self:GetRangeTo(self.Enemy) < 55 or self:AttackBreakable()) then
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

    self.nxtAttack = CurTime() + 0.46

		self.Enemy = self.Enemy
		self.IsAttacking = true
		self:RestartGesture(ACT_GMOD_GESTURE_RANGE_FRENZY)
		
		timer.Simple(0.2, function() 
		if !self:IsValid() then return end
		if self:Health() < 0 then return end
		
		if !self.Enemy:IsValid() then 
		self:StartActivity( self.WalkAnim )
		self:SetPoseParameter("move_x",self.WalkSpeedAnimation)
		self:EmitSound("npc/zombie/claw_miss"..math.random(2)..".wav", 65, math.random(140, 150))
		return end
		
		if self.Enemy:Health() < 0 then 
		self:StartActivity( self.WalkAnim )
		self:SetPoseParameter("move_x",self.WalkSpeedAnimation)
		self:EmitSound("npc/zombie/claw_miss"..math.random(2)..".wav", 65, math.random(140, 150))
		return end
		
			if (self:GetRangeTo(self.Enemy) < 35) then
			if self.Enemy:IsPlayer() then
			
		self:EmitSound("physics/body/body_medium_impact_hard"..math.random(6)..".wav", 65, math.random(130, 140))
		self.Enemy:TakeDamage(GetConVarNumber("gorechild_firstattackdmg"), self)	
		self.Enemy:ViewPunch(Angle(math.random(-1, 1)*self.Damage, math.random(-1, 1)*self.Damage, math.random(-1, 1)*self.Damage))
	
		local bleed = ents.Create("info_particle_system")
		bleed:SetKeyValue("effect_name", "blood_impact_red_01")
		bleed:SetPos(self.Enemy:GetPos() + Vector(0,0,50)) 
		bleed:Spawn()
		bleed:Activate() 
		bleed:Fire("Start", "", 0)
		bleed:Fire("Kill", "", 0.2)
	
			end
			
			end
			self:EmitSound("npc/zombie/claw_miss"..math.random(2)..".wav", 65, math.random(140, 150))
		end)
		
		timer.Simple(0.4, function() 
		if !self:IsValid() then return end
		if self:Health() < 0 then return end
		
		if !self.Enemy:IsValid() then 
		self:StartActivity( self.WalkAnim )
		self:SetPoseParameter("move_x",self.WalkSpeedAnimation)
		self:EmitSound("npc/zombie/claw_miss"..math.random(2)..".wav", 65, math.random(140, 150))
		return end
		
		if self.Enemy:Health() < 0 then 
		self:StartActivity( self.WalkAnim )
		self:SetPoseParameter("move_x",self.WalkSpeedAnimation)
		self:EmitSound("npc/zombie/claw_miss"..math.random(2)..".wav", 65, math.random(140, 150))
		return end
		
			if (self:GetRangeTo(self.Enemy) < 35) then
			if self.Enemy:IsPlayer() then
			
		self:EmitSound("physics/body/body_medium_impact_hard"..math.random(6)..".wav", 65, math.random(130, 140))
		self.Enemy:TakeDamage(GetConVarNumber("gorechild_secondattackdmg"), self)	
		self.Enemy:ViewPunch(Angle(math.random(-1, 1)*self.Damage, math.random(-1, 1)*self.Damage, math.random(-1, 1)*self.Damage))
		
		local bleed = ents.Create("info_particle_system")
		bleed:SetKeyValue("effect_name", "blood_impact_red_01")
		bleed:SetPos(self.Enemy:GetPos() + Vector(0,0,50)) 
		bleed:Spawn()
		bleed:Activate() 
		bleed:Fire("Start", "", 0)
		bleed:Fire("Kill", "", 0.2)
		
			end
			
			end
			self:EmitSound("npc/zombie/claw_miss"..math.random(2)..".wav", 65, math.random(130, 150))
		end)

		self:StartActivity( self.WalkAnim )
		self.IsAttacking = false
end

function ENT:OnOtherKilled()
end

function ENT:OnLeaveGround() 
end

function ENT:OnLandOnGround()
self:StartActivity( self.WalkAnim )
end

function ENT:OnKilled( dmginfo )
	if SERVER then
	self:EmitSound("ambient/creatures/town_child_scream1.wav", 75, 65)
	end
	
	if !self.IsReviving then
	local zombie = ents.Create("nextbot_deathanim2")
			if !self:IsValid() then return end
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
	else
	local zombie = ents.Create("nextbot_fakebaby")
			if !self:IsValid() then return end
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

	if !dmginfo:GetAttacker():IsPlayer() and dmginfo:IsExplosionDamage() then
	dmginfo:ScaleDamage(0)
	end

	if dmginfo:IsExplosionDamage() then
	dmginfo:ScaleDamage(5)
	else
	dmginfo:ScaleDamage(0.8)
	end

	self:EmitSound("physics/body/body_medium_impact_hard"..math.random(6)..".wav", 60, math.random(60, 70))
	
	if math.random(1,3) == 1 then
	self:EmitSound("ambient/voices/citizen_beaten"..math.random(5)..".wav", 60, math.random(50, 60))
	end
	
end
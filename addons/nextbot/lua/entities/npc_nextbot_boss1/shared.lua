AddCSLuaFile()

ENT.Base             = "base_nextbot"
ENT.Spawnable        = false
ENT.AdminSpawnable   = false


--Stats--
ENT.Speed = 70
ENT.WalkSpeedAnimation = 0.9
ENT.FlinchSpeed = 0

ENT.health = 2500
ENT.Damage = 25

ENT.AttackWaitTime = 0.5
ENT.AttackFinishTime = 0.5

ENT.FallDamage = 15

--Model Settings--
ENT.Model = "models/zombie/zombineplayer.mdl"

ENT.AttackAnim = (ACT_GMOD_GESTURE_RANGE_ZOMBIE)

ENT.WalkAnim2 = "walk_all"

ENT.FlinchAnim = (none)
ENT.FallAnim = (none)

ENT.AttackDoorAnim = (ACT_GMOD_GESTURE_RANGE_ZOMBIE_SPECIAL)

--Sounds--
ENT.Attack1 = Sound("npc/zombine/attack1.wav")
ENT.Attack2 = Sound("npc/zombine/attack2.wav")

ENT.Enrage = Sound("npc/zombine/enrage1.wav")

ENT.Alert1 = Sound("npc/zombine/enrage2.wav")
ENT.Alert2 = Sound("npc/zombine/fall1.wav")
ENT.Alert3 = Sound("npc/zombine/fall2.wav")

ENT.DoorBreak = Sound("npc/zombie/zombie_pound_door.wav")

ENT.Death1 = Sound("npc/zombine/death1.wav")
ENT.Death2 = Sound("npc/zombine/death2.wav")
ENT.Death3 = Sound("npc/zombine/death3.wav")

ENT.Flinch1 = Sound("npc/zombine/flinch1.wav")
ENT.Flinch2 = Sound("npc/zombine/flinch2.wav")
ENT.Flinch3 = Sound("none")

ENT.Fall1 = Sound("npc/zombine/fall1.wav")
ENT.Fall2 = Sound("npc/zombine/fall2.wav")

ENT.Idle1 = Sound("npc/zombine/idle1.wav")
ENT.Idle2 = Sound("npc/zombine/idle2.wav")
ENT.Idle3 = Sound("npc/zombine/idle3.wav")
ENT.Idle4 = Sound("npc/zombine/idle4.wav")
ENT.Idle5 = Sound("none")
ENT.Idle6 = Sound("none")
ENT.Idle7 = Sound("none")
ENT.Idle8 = Sound("none")
ENT.Idle9 = Sound("none")

ENT.Pain1 = Sound("npc/zombine/pain1.wav")
ENT.Pain2 = Sound("npc/zombine/pain2.wav")
ENT.Pain3 = Sound("npc/zombine/pain3.wav")
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
	self:SetCollisionGroup(COLLISION_GROUP_DEBRIS)
	
	self:SetModel(self.Model)
	self:SetHealth( self.health )
	self:SetModelScale( 1.4, 0 )
	
	self.LoseTargetDist	= 4000	-- How far the enemy has to be before we lose them
	self.SearchRadius 	= 3000	-- How far to search for enemies
	
	self:SetColor(Color(255, 175, 175, 255))
	
	self.IsAttacking = false
	self.Grenade1 = false
	self.HasNoEnemy = false
	
	--Misc--
	self:Precache()
	self.loco:SetStepHeight(35)	
	self.loco:SetAcceleration(900)
	self.loco:SetDeceleration(400)
	self.LastPos = self:GetPos()
	self.nextbot = true
end

ENT.NextGrenade = 8
function ENT:Grenade()
if CurTime() < self.NextGrenade then return end
if SERVER then

self.Grenade1 = true
self:RestartGesture(ACT_GMOD_GESTURE_ITEM_THROW)
self:EmitSound("weapons/slam/throw.wav", 100, math.random(78, 82))

		timer.Simple(0.5, function() 
		local ent = ents.Create("ent_grenade")
			if ent:IsValid() and self:IsValid() then
				ent:SetPos(self:EyePos() + Vector(20,0,40))
				ent:Spawn()
				ent:SetOwner(self)
				
				local phys = ent:GetPhysicsObject()
				if phys:IsValid() then
				local ang = self:EyeAngles()
				ang:RotateAroundAxis(ang:Forward(), math.Rand(-10, 10))
				ang:RotateAroundAxis(ang:Up(), math.Rand(-10, 10))
				phys:SetVelocityInstantaneous(ang:Forward() * math.Rand(490, 690))
				
				end
			end

		timer.Simple(0.4, function() 
		if !self:IsValid() then return end
		if self:Health() < 0 then return end
		self.Grenade1 = false
		end)
		
		end)

	self.NextGrenade = CurTime() + 8
	end
end

function ENT:Think()
if !IsValid(self) then return end

	if self.IsAttacking then
		if (GetConVarNumber("nb_stop") == 0) then
		self.loco:FaceTowards( self.Enemy:GetPos() )
		end
	end

		if (GetConVarNumber("nb_stop") == 0) then
		self:Grenade()
		else
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
		self:EmitSound("npc/combine_soldier/gear"..math.random(6)..".wav", 70)
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
		self:EmitSound("npc/combine_soldier/gear"..math.random(6)..".wav", 70)
        end

        self.FeetOnGround2 = tr.Hit
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
		
		if SERVER then
		local sounds = {}
	sounds[1] = (self.Attack1)
	sounds[2] = (self.Attack2)
		self:EmitSound( sounds[math.random(1,2)] )
		end
	
		timer.Simple(0.3, function() 
		if !self:IsValid() then return end
		if self:Health() < 0 then return end
		
		if !v:IsValid() then
		self:ResetSequence( self.WalkAnim2 )
		
		self:EmitSound(self.Miss)
		return end
		
		if v:Health() < 0 then 
		self:ResetSequence( self.WalkAnim2 )
		
		self:EmitSound(self.Miss)
		return end
		
					if self.IsReviving or self.IsFlinching then
					else
		
					if (self:GetRangeTo(v) < 70) then
					v:EmitSound(self.DoorBreak)
					v:TakeDamage( self.Damage, self)	

					local phys = v:GetPhysicsObject()
			if (phys != nil && phys != NULL && phys:IsValid()) then
			phys:ApplyForceCenter(self:GetForward():GetNormalized()*35000 + Vector(0, 0, 2))
			end
					end
					end
					end)
	
		self:PlaySequenceAndWait( "FastAttack", 1.2 )
		self:ResetSequence( self.WalkAnim2 )
		
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
	
	timer.Simple(0.3, function() 
		if !self:IsValid() then return end
		if self:Health() < 0 then return end
		
		if !v:IsValid() then 
		self:ResetSequence( self.WalkAnim2 )
		
		self:EmitSound(self.Miss)
		return end
		
		if v:Health() < 0 then 
		self:ResetSequence( self.WalkAnim2 )
		
		self:EmitSound(self.Miss)
		return end
		
					if self.IsReviving or self.IsFlinching then
					else
		
					v:EmitSound(self.DoorBreak)
					v:TakeDamage( self.Damage, self)	
					end
					end)
	
		self:PlaySequenceAndWait( "FastAttack", 1.2 )
		self:ResetSequence( self.WalkAnim2 )
		
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
	if SERVER then
	local sounds = {}
	sounds[1] = (self.Idle1)
	sounds[2] = (self.Idle2)
	sounds[3] = (self.Idle3)
	sounds[4] = (self.Idle4)
		self:EmitSound( sounds[math.random(1,4)])
	end
end

function ENT:AlertSound()
local alertsounds = {}
	alertsounds[1] = (self.Alert1)
	alertsounds[2] = (self.Alert2)
	alertsounds[3] = (self.Alert3)
	self:EmitSound( alertsounds[math.random(1,3)], 511, 100 )
end

function ENT:RunBehaviour()
	while ( true ) do
		if ( self:HaveEnemy() ) then
		self.HasNoEnemy = false
			self:AlertSound()
			self:ResetSequence( self.WalkAnim2 )
		
			self.loco:SetDesiredSpeed( self.Speed )
			self:ChaseEnemy() 
		else
			-- Wander around
		self.HasNoEnemy = true
			self:ResetSequence( self.WalkAnim2 )
			
			self.loco:SetDesiredSpeed( self.Speed )
			self:IdleSounds()
			self:MoveToPos( self:GetPos() + Vector( math.Rand( -1, 1 ), math.Rand( -1, 1 ), 0 ) * 400 )
			self:StartActivity(ACT_IDLE)
		end
		coroutine.wait( 2 )
		self:IdleSounds()
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
							v.Hitsleft = 5
						end
						
						if v != NULL and v.Hitsleft > 0 then
						
							if !self:IsValid() then return end
		if self:Health() < 0 then return end
		
		if !v:IsValid() then 
		self:ResetSequence( self.WalkAnim2 )
			
		self:EmitSound(self.Miss)
		return end
		
		if v:Health() < 0 then 
		self:ResetSequence( self.WalkAnim2 )
			
		self:EmitSound(self.Miss)
		return end
						
							if (self:GetRangeTo(v) < 25) then
							
								self:RestartGesture(ACT_GMOD_GESTURE_TAUNT_ZOMBIE)
								self:SetPoseParameter("move_x",0)
								self:EmitSound(self.Enrage, 511, 100)
								coroutine.wait(2)
								self:RestartGesture(self.AttackDoorAnim)
								self:SetPoseParameter("move_x",0)
								coroutine.wait(0.5)
								v:EmitSound(self.DoorBreak)
								
								if v != NULL and v.Hitsleft != nil then
									if v.Hitsleft > 0 then
									v.Hitsleft = v.Hitsleft - 10
									
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
						coroutine.wait(self.AttackFinishTime)
						
						self:ResetSequence( self.WalkAnim2 )
			
						end
						end
						end
						end
						
		
	local ent = ents.FindInSphere( self:GetPos(), 60) 
		for k,v in pairs( ent ) do
		
		if ( v:IsPlayer() && v:Alive() ) then
		
		if self.IsFlinching or self.IsReviving or self.Grenade1 then return end
		
		if SERVER then
		self:EmitSound(self.Attack1)
		end
	
		timer.Simple(0.3, function() 
		if !self:IsValid() then return end
		if self:Health() < 0 then return end
		
		if !v:IsValid() then 
		self:ResetSequence( self.WalkAnim2 )
			
		self:EmitSound(self.Miss)
		return end
		
		if v:Health() < 0 then 
		self:ResetSequence( self.WalkAnim2 )
		self:EmitSound(self.Miss)
		return end
		
		if self.IsFlinching or self.IsReviving or self.Grenade1 then return end
		
		if v:IsPlayer() then
			if (self:GetRangeTo(v) < 65) then
		self:EmitSound(self.Hit)
		v:TakeDamage( self.Damage, self)	
		v:ViewPunch(Angle(math.random(-1, 1)*self.Damage, math.random(-1, 1)*self.Damage, math.random(-1, 1)*self.Damage))
		
		local bleed = ents.Create("info_particle_system")
		bleed:SetKeyValue("effect_name", "blood_impact_red_01")
		bleed:SetPos(v:GetPos() + Vector(0,0,70)) 
		bleed:Spawn()
		bleed:Activate() 
		bleed:Fire("Start", "", 0)
		bleed:Fire("Kill", "", 0.2)
		
		local moveAdd=Vector(0,0,250)
		if not v:IsOnGround() then
		moveAdd=Vector(0,0,0)
		end
		v:SetVelocity(moveAdd+((self.Enemy:GetPos()-self:GetPos()):GetNormal()*0)) -- apply the velocity
		
			else
			self:EmitSound(self.Miss)
			end
		end
		end)
		
		self.Enemy = v
		self.IsAttacking = true
		self:PlaySequenceAndWait( "FastAttack", 1.2 )

		self:ResetSequence( self.WalkAnim2 )
			
		self.IsAttacking = false
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

	if SERVER then
function ENT:OnKilled( dmginfo )
	local deathsounds = {}
	deathsounds[1] = (self.Death1)
	deathsounds[2] = (self.Death2)
	deathsounds[3] = (self.Death3)
	self:EmitSound( deathsounds[math.random(1,3)] )
	
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

	if self.HasNoEnemy and dmginfo:GetAttacker():IsPlayer() then
		if self:IsValid() and self:Health() > 0 then
	local attacker = dmginfo:GetAttacker()
	self.SearchRadius 	= self:GetRangeTo(attacker) + 1000
	self.Enemy = attacker
	end -- If we don't have an enemy and we get injured by a player then we chase the player
		end

		if self:Health() > 1000 then
			if !dmginfo:IsExplosionDamage() then
			self:EmitSound("hit/boss1_hit.wav")
			dmginfo:ScaleDamage(0.5)
			
			local effectdata = EffectData()
			effectdata:SetStart( dmginfo:GetDamagePosition() ) 
			effectdata:SetOrigin( dmginfo:GetDamagePosition() )
			effectdata:SetScale( 1 )
			util.Effect( "StunStickImpact", effectdata )
			end
			
		else
		dmginfo:ScaleDamage(0.6)
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
	end
	
	if math.random( 1,5) == 1 then
	local painsounds = {}
	painsounds[1] = (self.Pain1)
	painsounds[2] = (self.Pain2)
	self:EmitSound( painsounds[math.random(1,2)] )
	end
end
	end
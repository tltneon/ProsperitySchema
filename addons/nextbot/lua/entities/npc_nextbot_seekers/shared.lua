AddCSLuaFile()

ENT.Base             = "base_nextbot"
ENT.Spawnable        = false
ENT.AdminSpawnable   = false


--Stats--
ENT.Speed = 145
ENT.WalkSpeedAnimation = 0.9
ENT.FlinchSpeed = 0

ENT.health = 100
ENT.Damage = 15

ENT.AttackWaitTime = 0.8
ENT.AttackFinishTime = 0.2

ENT.FallDamage = 0


--Model Settings--
ENT.Model = "models/zombie/seeker_01.mdl"
ENT.Model2 = "models/zombie/seeker_02.mdl"
ENT.Model3 = "models/zombie/seeker_03.mdl"

ENT.AttackAnim = (ACT_GMOD_GESTURE_RANGE_ZOMBIE)
ENT.WalkAnim = (ACT_HL2MP_RUN_ZOMBIE)

ENT.FlinchAnim = (ACT_HL2MP_ZOMBIE_SLUMP_RISE)
ENT.FallAnim = (ACT_HL2MP_WALK_ZOMBIE_01)

ENT.AttackDoorAnim = (ACT_GMOD_GESTURE_RANGE_ZOMBIE)

--Sounds--
ENT.Attack1 = Sound("npc/seekers/attack1.wav")
ENT.Attack2 = Sound("npc/seekers/attack2.wav")
ENT.Attack3 = Sound("npc/seekers/attack3.wav")
ENT.Attack4 = Sound("npc/seekers/attack4.wav")

ENT.DoorBreak = Sound("npc/zombie/zombie_pound_door.wav")

ENT.Death1 = Sound("npc/seekers/death1.wav")
ENT.Death2 = Sound("npc/seekers/death2.wav")
ENT.Death3 = Sound("npc/seekers/death3.wav")
ENT.Death4 = Sound("npc/seekers/death4.wav")

ENT.Alert1 = Sound("npc/seekers/alert1.wav")
ENT.Alert2 = Sound("npc/seekers/alert2.wav")
ENT.Alert3 = Sound("npc/seekers/alert3.wav")
ENT.Alert4 = Sound("npc/seekers/alert4.wav")

ENT.Idle1 = Sound("npc/seekers/idle1.wav")
ENT.Idle2 = Sound("npc/seekers/idle2.wav")
ENT.Idle3 = Sound("npc/seekers/idle3.wav")
ENT.Idle4 = Sound("npc/seekers/idle4.wav")

ENT.Pain1 = Sound("npc/seekers/pain1.wav")
ENT.Pain2 = Sound("npc/seekers/pain2.wav")
ENT.Pain3 = Sound("npc/seekers/pain3.wav")
ENT.Pain4 = Sound("npc/seekers/pain4.wav")

ENT.Hit1 = Sound("npc/infected_zombies/hit_punch_01.wav")
ENT.Hit2 = Sound("npc/infected_zombies/hit_punch_02.wav")
ENT.Hit3 = Sound("npc/infected_zombies/hit_punch_03.wav")
ENT.Hit4 = Sound("npc/infected_zombies/hit_punch_04.wav")
ENT.Hit5 = Sound("npc/infected_zombies/hit_punch_05.wav")
ENT.Hit6 = Sound("npc/infected_zombies/hit_punch_06.wav")
ENT.Hit7 = Sound("npc/infected_zombies/hit_punch_07.wav")
ENT.Hit8 = Sound("npc/infected_zombies/hit_punch_08.wav")

ENT.Miss1 = Sound("npc/infected_zombies/claw_miss_1.wav")
ENT.Miss2 = Sound("npc/infected_zombies/claw_miss_2.wav")

function ENT:Precache()
	if SERVER then
--Models--
util.PrecacheModel(self.Model)
util.PrecacheModel(self.Model2)
util.PrecacheModel(self.Model3)

--Sounds--	
util.PrecacheSound(self.Attack1)
util.PrecacheSound(self.Attack2)
util.PrecacheSound(self.Attack3)
util.PrecacheSound(self.Attack4)

util.PrecacheSound(self.DoorBreak)

util.PrecacheSound(self.Death1)
util.PrecacheSound(self.Death2)
util.PrecacheSound(self.Death3)
util.PrecacheSound(self.Death4)

util.PrecacheSound(self.Alert1)
util.PrecacheSound(self.Alert2)
util.PrecacheSound(self.Alert3)
util.PrecacheSound(self.Alert4)

util.PrecacheSound(self.Idle1)
util.PrecacheSound(self.Idle2)
util.PrecacheSound(self.Idle3)
util.PrecacheSound(self.Idle4)	
	
util.PrecacheSound(self.Pain1)
util.PrecacheSound(self.Pain2)
util.PrecacheSound(self.Pain3)
util.PrecacheSound(self.Pain4)	
	
util.PrecacheSound(self.Hit1)
util.PrecacheSound(self.Hit2)
util.PrecacheSound(self.Hit3)
util.PrecacheSound(self.Hit4)
util.PrecacheSound(self.Hit5)
util.PrecacheSound(self.Hit6)
util.PrecacheSound(self.Hit7)
util.PrecacheSound(self.Hit8)

util.PrecacheSound(self.Miss1)
util.PrecacheSound(self.Miss2)
	end
end

function ENT:Initialize()

	--Stats--
	self:SetCollisionGroup(COLLISION_GROUP_DEBRIS)
	
	self.Anims = { ACT_HL2MP_RUN_ZOMBIE, ACT_HL2MP_RUN_FAST, ACT_HL2MP_RUN_FIST, ACT_HL2MP_RUN_CHARGING, ACT_HL2MP_RUN_KNIFE }
	
    local model = math.random(1,3)
	if model == 1 then
	self:SetModel(self.Model)
	self.WalkAnim = (table.Random(self.Anims))
	else
	if model == 2 then
	self:SetModel(self.Model2)
	self.WalkAnim = (table.Random(self.Anims))
	end
	if model == 3 then
	self:SetModel(self.Model3)
	self.WalkAnim = (table.Random(self.Anims))
	end
	end
	
	self:SetHealth(self.health)
	
	self.LoseTargetDist	= 6000	-- How far the enemy has to be before we lose them
	self.SearchRadius 	= 5000	-- How far to search for enemies
	
	
	self.IsFlinching = false
	self.IsAttacking = false
	self.HasNoEnemy = false
	
	--Misc--
	self:Precache()
	self.loco:SetStepHeight(35)	
	self.loco:SetAcceleration(400)
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
		self:StartActivity( self.WalkAnim  )
		self:SetPoseParameter("move_x",self.WalkSpeedAnimation)	
		self:EmitSound("npc/infected_zombies/claw_miss_"..math.random(2)..".wav", math.random(75,95), math.random(65,95))
		return end
		
		if v:Health() < 0 then 
		self:StartActivity( self.WalkAnim  )
		self:SetPoseParameter("move_x",self.WalkSpeedAnimation)	
		self:EmitSound("npc/infected_zombies/claw_miss_"..math.random(2)..".wav", math.random(75,95), math.random(65,95))
		return end
						
							if (self:GetRangeTo(v) < 25) then
							
					if SERVER then
		local sounds = {}
	sounds[1] = (self.Attack1)
	sounds[2] = (self.Attack2)
	sounds[3] = (self.Attack3)
	sounds[4] = (self.Attack4)
		self:EmitSound( sounds[math.random(1,4)], 100, math.random(75,105) )
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
						self:StartActivity( self.WalkAnim  )
						self:SetPoseParameter("move_x",self.WalkSpeedAnimation)
						self.loco:SetDesiredSpeed(self.Speed)
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
	sounds[3] = (self.Attack3)
	sounds[4] = (self.Attack4)
		self:EmitSound( sounds[math.random(1,4)], 100, math.random(75,105) )
		end
	
		self.Enemy = self.Enemy	
		self.IsAttacking = true
		self:RestartGesture(self.AttackAnim)
		
		
		timer.Simple(0.8, function() 
		if !self:IsValid() then return end
		if self:Health() < 0 then return end
		
		if !self.Enemy:IsValid() then 
		self:StartActivity( self.WalkAnim  )
		self:EmitSound("npc/infected_zombies/claw_miss_"..math.random(2)..".wav", math.random(75,95), math.random(65,95))
		return end
		
		if self.Enemy:Health() < 0 then 
		self:StartActivity( self.WalkAnim  )
		self:EmitSound("npc/infected_zombies/claw_miss_"..math.random(2)..".wav", math.random(75,95), math.random(65,95))
		return end
		
		if self.IsFlinching or self.IsReviving then return end
		
		if (self:GetRangeTo(self.Enemy) < 60) then
			
		if self.Enemy:IsPlayer() then
			self.Enemy:EmitSound("npc/infected_zombies/hit_punch_0"..math.random(8)..".wav", math.random(100,125), math.random(85,105))
			self.Enemy:TakeDamage(self.Damage, self)	
			self.Enemy:ViewPunch(Angle(math.random(-1, 1)*self.Damage, math.random(-1, 1)*self.Damage, math.random(-1, 1)*self.Damage))
			
			local bleed = ents.Create("info_particle_system")
		bleed:SetKeyValue("effect_name", "blood_impact_red_01")
		bleed:SetPos(self.Enemy:GetPos() + Vector(0,0,70)) 
		bleed:Spawn()
		bleed:Activate() 
		bleed:Fire("Start", "", 0)
		bleed:Fire("Kill", "", 0.2)
			
			local moveAdd=Vector(0,0,250)
		if not self.Enemy:IsOnGround() then
		moveAdd=Vector(0,0,0)
		end
		self.Enemy:SetVelocity(moveAdd+((self.Enemy:GetPos()-self:GetPos()):GetNormal()*0)) -- apply the velocity
		
		end
		end
		self:EmitSound("npc/infected_zombies/claw_miss_"..math.random(2)..".wav", math.random(75,95), math.random(65,95))
		end)
		
		
		self.IsAttacking = false
		self:StartActivity( self.WalkAnim  )
		self:SetPoseParameter("move_x",self.WalkSpeedAnimation)
		end
		end
end

function ENT:IdleSounds()
if SERVER then
	local sounds = {}
	sounds[1] = (self.Idle1)
	sounds[2] = (self.Idle2)
	sounds[3] = (self.Idle3)
	sounds[4] = (self.Idle4)
		self:EmitSound( sounds[math.random(1,4)], 77, math.random(75,105) )
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
	sounds[3] = (self.Attack3)
	sounds[4] = (self.Attack4)
		self:EmitSound( sounds[math.random(1,4)], 100, math.random(75,105) )
		end
	
		self:RestartGesture(self.AttackAnim)  
		self:SetPoseParameter("move_x",0)
		coroutine.wait(self.AttackWaitTime)
		
		if !self:IsValid() then return end
		if self:Health() < 0 then return end
		
		if !v:IsValid() then 
		self:StartActivity( self.WalkAnim  )
		self:SetPoseParameter("move_x",self.WalkSpeedAnimation)
		self:EmitSound("npc/infected_zombies/claw_miss_"..math.random(2)..".wav", math.random(75,95), math.random(65,95))
		return end
		
		if v:Health() < 0 then 
		self:StartActivity( self.WalkAnim  )
		self:SetPoseParameter("move_x",self.WalkSpeedAnimation)
		self:EmitSound("npc/infected_zombies/claw_miss_"..math.random(2)..".wav", math.random(75,95), math.random(65,95))
		return end
		
		if (self:GetRangeTo(v) < 60) then

		local phys = v:GetPhysicsObject()
			if (phys != nil && phys != NULL && phys:IsValid()) then
			phys:ApplyForceCenter(self:GetForward():GetNormalized()*30000 + Vector(0, 0, 2))
			v:EmitSound("npc/infected_zombies/hit_punch_0"..math.random(8)..".wav", math.random(70,105), math.random(85,105))
			v:EmitSound(self.DoorBreak)
			v:TakeDamage(self.Damage, self)	
			end
			
		end
		self:EmitSound("npc/infected_zombies/claw_miss_"..math.random(2)..".wav", math.random(75,95), math.random(65,95))
		coroutine.wait(self.AttackFinishTime)	
		self:SetPoseParameter("move_x",self.WalkSpeedAnimation)
		self:StartActivity( self.WalkAnim  )
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
	sounds[3] = (self.Attack3)
	sounds[4] = (self.Attack4)
		self:EmitSound( sounds[math.random(1,4)], 100, math.random(75,105) )
		end
	
		self:RestartGesture(self.AttackAnim)  
		self:SetPoseParameter("move_x",0)
		coroutine.wait(self.AttackWaitTime)
		
		if !self:IsValid() then return end
		if self:Health() < 0 then return end
		
		if !v:IsValid() then 
		self:StartActivity( self.WalkAnim  )
		self:SetPoseParameter("move_x",self.WalkSpeedAnimation)
		self:EmitSound("npc/infected_zombies/claw_miss_"..math.random(2)..".wav", math.random(75,95), math.random(65,95))
		return end
		
		if v:Health() < 0 then 
		self:StartActivity( self.WalkAnim  )
		self:SetPoseParameter("move_x",self.WalkSpeedAnimation)
		self:EmitSound("npc/infected_zombies/claw_miss_"..math.random(2)..".wav", math.random(75,95), math.random(65,95))
		return end
		
			v:EmitSound("npc/infected_zombies/hit_punch_0"..math.random(8)..".wav", math.random(100,125), math.random(85,105))
			v:EmitSound(self.DoorBreak)
			v:TakeDamage(self.Damage, self)	
			
		coroutine.wait(self.AttackFinishTime)
		self:SetPoseParameter("move_x",self.WalkSpeedAnimation)		
		self:StartActivity( self.WalkAnim  )
			return true
		end
	end
	return false
end

function ENT:AlertSound()
	if SERVER then
local alertsounds = {}
	alertsounds[1] = (self.Alert1)
	alertsounds[2] = (self.Alert2)
	alertsounds[3] = (self.Alert3)
	alertsounds[4] = (self.Alert4)
	self:EmitSound( alertsounds[math.random(1,4)], 100, math.random(75,95) )
	end
end

function ENT:RunBehaviour()
	while ( true ) do
		if ( self:HaveEnemy() ) then
		self.HasNoEnemy = false
		
			if math.random(1,2) == 1 then
			self:RestartGesture( ACT_GMOD_GESTURE_TAUNT_ZOMBIE )
			self:AlertSound()
				local ents = ents.FindInSphere( self:GetPos(), 2000 )
				for _,v in pairs(ents) do
					if v:GetClass("nazi_zombie_*", "npc_nextbot_*", "mob_zombie_*") then
					v.SearchRadius = 5000
					v.LoseTargetDist = 6000
					end
				end
			else
			self:IdleSounds()
			end
			
			self:StartActivity( self.WalkAnim  )
			self:SetPoseParameter("move_x",self.WalkSpeedAnimation)
			self.loco:SetDesiredSpeed(self.Speed)
			self:ChaseEnemy() 
		else
			-- Wander around
		self.HasNoEnemy = true
			self:StartActivity( self.WalkAnim  )
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

function ENT:OnOtherKilled()
	if self.HasNoEnemy then
		local ents = ents.FindInSphere( self:GetPos(), 2000 )
		for _,v in pairs(ents) do
			if v:GetClass("nazi_zombie_*", "npc_nextbot_*", "mob_zombie_*") then
			self.SearchRadius = self.SearchRadius + 1000
			end
		end
	end
end

	if SERVER then
function ENT:OnKilled( dmginfo )

	local deathsounds = {}
		deathsounds[1] = (self.Death1)
		deathsounds[2] = (self.Death2)
		deathsounds[3] = (self.Death3)
		deathsounds[4] = (self.Death4)
		self:EmitSound( deathsounds[math.random(1,4)], 100, math.random(65,85) )
	
		local ents = ents.FindInSphere( self:GetPos(), 2000 )
		for _,v in pairs(ents) do
			if v:GetClass("nazi_zombie_*", "npc_nextbot_*", "mob_zombie_*") then
			v.SearchRadius = 5000
			v.LoseTargetDist = 6000
			end
		end
	
	self:BecomeRagdoll(dmginfo)
	
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
	dmginfo:ScaleDamage(1)
	end
	
	if math.random( 1,3 ) == 2 then
	local painsounds = {}
	painsounds[1] = (self.Pain1)
	painsounds[2] = (self.Pain2)
	painsounds[3] = (self.Pain3)
	painsounds[4] = (self.Pain4)
	self:EmitSound( painsounds[math.random(1,4)], 80, math.random(65,85) )
	end
	
end
	end
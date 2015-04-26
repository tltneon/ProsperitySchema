AddCSLuaFile()

ENT.Base             = "base_nextbot"
ENT.Spawnable        = false
ENT.AdminSpawnable   = false


--Stats--
ENT.Speed = 75
ENT.HuntSpeed = 110

ENT.FlinchSpeed = 0

ENT.health = 50
ENT.Damage = 25

ENT.AttackWaitTime = 0.5
ENT.AttackFinishTime = 0.3

ENT.FallDamage = 0


--Model Settings--
ENT.Model = "models/zombie/fast_torso.mdl"
ENT.AttackAnim = (ACT_MELEE_ATTACK1)
ENT.WalkAnim = (ACT_WALK)

ENT.FlinchAnim = (ACT_FLINCH_PHYSICS)
ENT.FallAnim = (ACT_IDLE_ON_FIRE)

ENT.AttackDoorAnim = "WallPound"

--Sounds--
ENT.Attack1 = Sound("npc/fast_zombie/wake1.wav")
ENT.Attack2 = Sound("npc/fast_zombie/wake1.wav")

ENT.DoorBreak = Sound("npc/zombie/zombie_pound_door.wav")

ENT.Alert1 = Sound("npc/fast_zombie/fz_alert_far1.wav")
ENT.Alert2 = Sound("npc/fast_zombie/fz_alert_close1.wav")
ENT.Alert3 = Sound("")

ENT.Death1 = Sound("npc/bonemesh/death1.mp3")
ENT.Death2 = Sound("npc/bonemesh/death2.mp3")
ENT.Death3 = Sound("npc/bonemesh/death3.mp3")

ENT.Flinch1 = Sound("")
ENT.Flinch2 = Sound("")
ENT.Flinch3 = Sound("")

ENT.Fall1 = Sound("npc/fast_zombie/wake1.wav")
ENT.Fall2 = Sound("npc/fast_zombie/wake1.wav")

ENT.Idle1 = Sound("npc/fast_zombie/fz_scream1.wav")
ENT.Idle2 = Sound("npc/fast_zombie/fz_frenzy1.wav")
ENT.Idle3 = Sound("")
ENT.Idle4 = Sound("")
ENT.Idle5 = Sound("")
ENT.Idle6 = Sound("")
ENT.Idle7 = Sound("")
ENT.Idle8 = Sound("")
ENT.Idle9 = Sound("")

ENT.Pain1 = Sound("")
ENT.Pain2 = Sound("")
ENT.Pain3 = Sound("")
ENT.Pain4 = Sound("")
ENT.Pain5 = Sound("")
ENT.Pain6 = Sound("")

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
	
    self:SetModel(self.Model)
	self:SetHealth(self.health)
	
	self.LoseTargetDist	= 4000	-- How far the enemy has to be before we lose them
	self.SearchRadius 	= 3000	-- How far to search for enemies
	
	self.IsAttacking = false
	self.HasNoEnemy = false
	
	--Misc--
	self:Precache()
	self.loco:SetStepHeight(35)
	self.loco:SetAcceleration(900)
	self.loco:SetDeceleration(900)
	self.LastPos = self:GetPos()
	self.nextbot = true
end

function ENT:Think()
if !IsValid(self) then return end

	if self.IsAttacking then
		if (GetConVarNumber("nb_stop") == 0) then
		if !self.Enemy then return end
		if !self.Enemy:IsValid() then return end
		if self.Enemy:Health() < 0 then return end
	self.loco:FaceTowards( self.Enemy:GetPos() )
		end
	end

    if !self.nxtThink then self.nxtThink = 0 end
    if CurTime() < self.nxtThink then return end

    self.nxtThink = CurTime() + 0.025
	
	-- First Step
        local bones = self:LookupBone("ValveBiped.Bip01_R_Forearm")
		
        local pos, ang = self:GetBonePosition(bones)

        local tr = {}
        tr.start = pos 
        tr.endpos = tr.start - ang:Right()*5 + ang:Forward()*20
        tr.filter = self
        tr = util.TraceLine(tr)

        if tr.Hit && !self.FeetOnGround then
		self:EmitSound("npc/zombie/foot"..math.random(3)..".wav", 70)
        end

        self.FeetOnGround = tr.Hit
		
	-- Second Step
		local bones2 = self:LookupBone("ValveBiped.Bip01_L_Forearm")
		
        local pos2, ang2 = self:GetBonePosition(bones2)

        local tr = {}
        tr.start = pos2 
        tr.endpos = tr.start - ang2:Right()*5 + ang2:Forward()*20
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

function ENT:OnStuck()
	if self.LastPos:Distance( self.Entity:GetPos() ) < 100 then
		self.Entity:SetPos( self.LastPos )
	end
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

	if (self:GetEnemy():GetPos():Distance(self:GetPos()) < 700) then
	self:SetColor(Color(255,155,155,255))
	self.loco:SetDesiredSpeed(self.HuntSpeed)
	else
	self:SetColor(Color(255,255,255,255))
	self.loco:SetDesiredSpeed(self.Speed)
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
		self:EmitSound(self.Miss)
		return end
		
		if v:Health() < 0 then 
		self:StartActivity( self.WalkAnim )
		self:EmitSound(self.Miss)
		return end
						
							if (self:GetRangeTo(v) < 25) then
						
								if SERVER then
							local sounds = {}
							sounds[1] = (self.Attack1)
							sounds[2] = (self.Attack2)
							self:EmitSound( sounds[math.random(1,2)] )
							end
							
								self:StartActivity(self.AttackAnim)
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
						self.loco:SetDesiredSpeed(self.Speed)
						end
						end
						end
						end
						
		
	local ent = ents.FindInSphere( self:GetPos(), 35) 
		for k,v in pairs( ent ) do
		
		if ( v:IsPlayer() && v:Alive() ) then
		
		if !self:IsValid() then return end
		if self:Health() < 0 then return end
		
		if !v:IsValid() then 
		self:StartActivity( self.WalkAnim )
		self:EmitSound(self.Miss)
		return end
		
		if v:Health() < 0 then 
		self:StartActivity( self.WalkAnim )
		self:EmitSound(self.Miss)
		return end
		
		if SERVER then
		local sounds = {}
	sounds[1] = (self.Attack1)
	sounds[2] = (self.Attack2)
		self:EmitSound( sounds[math.random(1,2)] )
		end
		
		self:StartActivity(self.AttackAnim)
		self.Enemy = v	
		self.IsAttacking = true
		coroutine.wait(self.AttackWaitTime)
		self:EmitSound(self.Miss)
		
		if (self:GetRangeTo(v) < 45) then

		if v:IsPlayer() then
			self:EmitSound(self.Hit)
			v:TakeDamage(self.Damage, self)			
			v:ViewPunch(Angle(math.random(-1, 1)*self.Damage, math.random(-1, 1)*self.Damage, math.random(-1, 1)*self.Damage))
			
			local bleed = ents.Create("info_particle_system")
		bleed:SetKeyValue("effect_name", "blood_impact_red_01")
		bleed:SetPos(v:GetPos() + Vector(0,0,60)) 
		bleed:Spawn()
		bleed:Activate() 
		bleed:Fire("Start", "", 0)
		bleed:Fire("Kill", "", 0.2)
			
			end

		end
		coroutine.wait(self.AttackFinishTime)	
		self:StartActivity( self.WalkAnim )	
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

function ENT:IdleSounds()
if SERVER then
	if math.random( 1,3 ) == 1 then
	local sounds = {}
	sounds[1] = (self.Idle1)
	sounds[2] = (self.Idle2)
		self:EmitSound( sounds[math.random(1,2)] )
	end
		end		
end
	
function ENT:AttackBreakable()
	local entstoattack = ents.FindInSphere(self:GetPos(), 20)
	for _,v in pairs(entstoattack) do
	
		if (v:GetClass() == "func_breakable") then
		
		if SERVER then
		local sounds = {}
	sounds[1] = (self.Attack1)
	sounds[2] = (self.Attack2)
		self:EmitSound( sounds[math.random(1,2)] )
		end
	
		self:StartActivity(self.AttackAnim)
		
		coroutine.wait(self.AttackWaitTime)
		self:EmitSound(self.Miss)
		
		if !self:IsValid() then return end
		if self:Health() < 0 then return end
		
		if !v:IsValid() then 
		self:StartActivity( self.WalkAnim )
		self:EmitSound(self.Miss)
		return end
		
		if v:Health() < 0 then 
		self:StartActivity( self.WalkAnim )
		self:EmitSound(self.Miss)
		return end
		
			v:EmitSound(self.DoorBreak)
			v:TakeDamage(self.Damage, self)	
			
		coroutine.wait(self.AttackFinishTime)
		self:StartActivity( self.WalkAnim )	
			return true
		end
	end
	return false
end	
	
function ENT:AttackProp()
	local entstoattack = ents.FindInSphere(self:GetPos(), 20)
	for _,v in pairs(entstoattack) do
	
		if (v:GetClass() == "prop_physics") then
		
		if SERVER then
		local sounds = {}
	sounds[1] = (self.Attack1)
	sounds[2] = (self.Attack2)
		self:EmitSound( sounds[math.random(1,2)] )
		end
	
	self:StartActivity(self.AttackAnim)
		coroutine.wait(self.AttackWaitTime)
		self:EmitSound(self.Miss)
		
		if !self:IsValid() then return end
		if self:Health() < 0 then return end
		
		if !v:IsValid() then 
		self:StartActivity( self.WalkAnim )
		self:EmitSound(self.Miss)
		return end
		
		if v:Health() < 0 then 
		self:StartActivity( self.WalkAnim )
		self:EmitSound(self.Miss)
		return end
		
		if (self:GetRangeTo(v) < 60) then
		
		local phys = v:GetPhysicsObject()
			if (phys != nil && phys != NULL && phys:IsValid()) then
			phys:ApplyForceCenter(self:GetForward():GetNormalized()*10000 + Vector(0, 0, 2))
			v:EmitSound(self.DoorBreak)
			v:TakeDamage(self.Damage, self)	
			end
			
		end	
		coroutine.wait(self.AttackFinishTime)
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
			self:ChaseEnemy() 
		else
			-- Wander around
		self.HasNoEnemy = true
			self:StartActivity( self.WalkAnim )
			self.loco:SetDesiredSpeed( self.Speed )
			self:IdleSounds()
			self:MoveToPos( self:GetPos() + Vector( math.Rand( -1, 1 ), math.Rand( -1, 1 ), 0 ) * 400 )
			self:StartActivity( ACT_IDLE )
		end
		coroutine.wait( 2 )
		self:IdleSounds()
	end
end	

	if SERVER then
function ENT:OnKilled( dmginfo )
	local deathsounds = {}
	deathsounds[1] = (self.Death1)
	deathsounds[2] = (self.Death2)
	deathsounds[3] = (self.Death3)
	self:EmitSound( deathsounds[math.random(1,3)] )
	self:BecomeRagdoll( dmginfo )
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
	
end
end
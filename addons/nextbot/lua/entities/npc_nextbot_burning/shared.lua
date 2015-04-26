AddCSLuaFile()

ENT.Base             = "base_nextbot"
ENT.Spawnable        = false
ENT.AdminSpawnable   = false


--Stats--
ENT.Speed = 75
ENT.FlinchSpeed = 0

ENT.health = 80
ENT.Damage = 10

ENT.AttackWaitTime = 0.5
ENT.AttackFinishTime = 0.5

ENT.FallDamage = 0


--Model Settings--
ENT.Model = "models/player/charple.mdl"

ENT.AttackAnim = (ACT_GMOD_GESTURE_RANGE_ZOMBIE)
ENT.WalkAnim = (ACT_HL2MP_WALK_ZOMBIE_05)

ENT.FlinchAnim = (none)
ENT.FallAnim = (none)

ENT.AttackDoorAnim = (ACT_GMOD_GESTURE_RANGE_ZOMBIE_SPECIAL)

--Sounds--
ENT.Attack1 = Sound("")
ENT.Attack2 = Sound("none")

ENT.DoorBreak = Sound("")

ENT.Death1 = Sound("npc/bonemesh/death1.mp3")
ENT.Death2 = Sound("npc/bonemesh/death2.mp3")
ENT.Death3 = Sound("npc/bonemesh/death3.mp3")

ENT.Alert1 = Sound("")
ENT.Alert2 = Sound("")
ENT.Alert3 = Sound("")

ENT.Flinch1 = Sound("none")
ENT.Flinch2 = Sound("none")
ENT.Flinch3 = Sound("none")

ENT.Fall1 = Sound("npc/bonemesh/pain1.mp3")
ENT.Fall2 = Sound("npc/bonemesh/pain2.mp3")

ENT.Idle1 = Sound("npc/bonemesh/idle1.mp3")
ENT.Idle2 = Sound("npc/bonemesh/idle2.mp3")
ENT.Idle3 = Sound("npc/bonemesh/idle3.mp3")
ENT.Idle4 = Sound("npc/bonemesh/idle4.mp3")
ENT.Idle5 = Sound("none")
ENT.Idle6 = Sound("none")
ENT.Idle7 = Sound("none")
ENT.Idle8 = Sound("none")
ENT.Idle9 = Sound("none")

ENT.Pain1 = Sound("npc/bonemesh/pain1.mp3")
ENT.Pain2 = Sound("npc/bonemesh/pain2.mp3")
ENT.Pain3 = Sound("none")
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
	
	self.LoseTargetDist	= 4000	-- How far the enemy has to be before we lose them
	self.SearchRadius 	= 3000	-- How far to search for enemies
	
	self.HasNoEnemy = false
	
	--Misc--
	self:Precache()
	self.loco:SetStepHeight(35)
	self.loco:SetAcceleration(900)
	self.loco:SetDeceleration(400)
	self.LastPos = self:GetPos()
	self.nextbot = true
end

function ENT:BehaveAct()
end

function ENT:Think()
if !IsValid(self) then return end
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

self.LastPos = self.Entity:GetPos() 
end

function ENT:OnStuck()
	if self.LastPos:Distance( self.Entity:GetPos() ) < 100 then
		self.Entity:SetPos( self.LastPos )
	end
end

function ENT:OnUnStuck()
	self:SetEnemy()
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
	local entstoattack = ents.FindInSphere(self:GetPos(), 55)
	for _,v in pairs(entstoattack) do
	
		if (v:GetClass() == "prop_physics") then

		
		if (self:GetRangeTo(v) < 125) then
	
		self:RestartGesture(ACT_GMOD_GESTURE_TAUNT_ZOMBIE)  
		local deathsounds = {}
	deathsounds[1] = (self.Death1)
	deathsounds[2] = (self.Death2)
	deathsounds[3] = (self.Death3)
	self:EmitSound( deathsounds[math.random(1,3)] )
		
		coroutine.wait(1)
		
	
		self:TakeDamage(math.huge, self)
		
		if SERVER then

			local explode = ents.Create("env_explosion")
	explode:SetPos(self:GetPos())
	explode:Spawn()
	explode:SetKeyValue( "iMagnitude", 100 ) -- larger explosion
	explode:Fire( "Explode", 0, 0 )
	explode:EmitSound("ambient/fire/gascan_ignite1.wav")
	end
	
		local effectdata = EffectData()
						effectdata:SetStart( self:GetPos() ) 
						effectdata:SetOrigin( self:GetPos() )
						effectdata:SetScale( 1 )
						util.Effect( "boss5explosion", effectdata )
		
		if (self:GetRangeTo(v) < 225) then
		v:Ignite(4,100)
		end
		
			end
			return true
		end
	end
	return false
end

function ENT:AttackBreakable()
	local entstoattack = ents.FindInSphere(self:GetPos(), 55)
	for _,v in pairs(entstoattack) do
	
		if (v:GetClass() == "func_breakable") then
		
		if (self:GetRangeTo(v) < 125) then
	
		self:RestartGesture(ACT_GMOD_GESTURE_TAUNT_ZOMBIE)  
		local deathsounds = {}
	deathsounds[1] = (self.Death1)
	deathsounds[2] = (self.Death2)
	deathsounds[3] = (self.Death3)
	self:EmitSound( deathsounds[math.random(1,3)] )
		
		coroutine.wait(1)
		
	
		self:TakeDamage(math.huge, self)
		
		if SERVER then

			local explode = ents.Create("env_explosion")
	explode:SetPos(self:GetPos())
	explode:Spawn()
	explode:SetKeyValue( "iMagnitude", 100 ) -- larger explosion
	explode:Fire( "Explode", 0, 0 )
	explode:EmitSound("ambient/fire/gascan_ignite1.wav")
	end
	
		local effectdata = EffectData()
						effectdata:SetStart( self:GetPos() ) 
						effectdata:SetOrigin( self:GetPos() )
						effectdata:SetScale( 1 )
						util.Effect( "boss5explosion", effectdata )
		
		if (self:GetRangeTo(v) < 225) then
		v:Ignite(4,100)
		end
		
			return true
		end
		end
	end
	return false
end

function ENT:BodyUpdate()
	local act = self:GetActivity()
	if ( act == self.WalkAnim ) then
		self:BodyMoveXY()
	end
	self:FrameAdvance()
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
	self:EmitSound( alertsounds[math.random(1,3)] )
end

function ENT:RunBehaviour()
	while ( true ) do
		if ( self:HaveEnemy() ) then
		self.HasNoEnemy = false
			self:AlertSound()
			self:StartActivity(self.WalkAnim)
			self.loco:SetDesiredSpeed( self.Speed )
			self:ChaseEnemy() 
		else
			-- Wander around
		self.HasNoEnemy = true
			self:StartActivity(self.WalkAnim)
			self.loco:SetDesiredSpeed( self.Speed )
			self:IdleSounds()
			self:MoveToPos( self:GetPos() + Vector( math.Rand( -1, 1 ), math.Rand( -1, 1 ), 0 ) * 400 )
			self:SetPoseParameter("move_x",0)
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
	
	if SERVER then
	if math.random( 1,1000) == 5 then
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
		self:EmitSound( sounds[math.random(1,9)])
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
							if (self:GetRangeTo(v) < 25) then
							
								self:RestartGesture(ACT_GMOD_GESTURE_TAUNT_ZOMBIE)
								coroutine.wait(1)
								self:EmitSound(self.DoorBreak)
								self:TakeDamage(math.huge, self)
								
								
								
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
						
						if SERVER then

							local explode = ents.Create("env_explosion")
						explode:SetPos(door:GetPos())
						explode:Spawn()
						explode:SetKeyValue( "iMagnitude", 100 )
						explode:SetOwner(self)	
						explode:Fire( "Explode", 0, 0 )
	
						local effectdata = EffectData()
						effectdata:SetStart( self:GetPos() ) 
						effectdata:SetOrigin( self:GetPos() )
						effectdata:SetScale( 1 )
						util.Effect( "boss5explosion", effectdata )
	
						local explodesounds = {}
						explodesounds[1] = ("ambient/explosions/explosion_5.wav")
						explodesounds[2] = ("ambient/explosions/explosion_6.wav")
						explodesounds[3] = ("ambient/explosions/explosion_8.wav")
						explodesounds[4] = ("ambient/explosions/explosion_9.wav")
						self:EmitSound( explodesounds[math.random(1,4)] )
	
						end
						
						door:Ignite(2,100)
						
						door:EmitSound("Wood_Plank.Break")
						
						local phys = door:GetPhysicsObject()
						if (phys != nil && phys != NULL && phys:IsValid()) then
						phys:ApplyForceCenter(self:GetForward():GetNormalized()*51000 + Vector(0, 0, 2))
						end
						
						door:SetSkin(v:GetSkin())
						door:SetColor(v:GetColor())
						door:SetMaterial(v:GetMaterial())
					end
						coroutine.wait(self.AttackFinishTime)	
						self:StartActivity( self.WalkAnim )
						end
						end
						end
						end
						
		
	local ent = ents.FindInSphere( self:GetPos(), 80) 
		for k,v in pairs( ent ) do
		
		if (v:IsPlayer() && v:Alive()) then
		if not ( v:IsValid() && v:Health() > 0 ) then return end
		
		if SERVER then
		self:EmitSound(self.Attack1)
		end
	
		if (self:GetRangeTo(v) < 125) then
	
		self:RestartGesture(ACT_GMOD_GESTURE_TAUNT_ZOMBIE)  
		local deathsounds = {}
	deathsounds[1] = (self.Death1)
	deathsounds[2] = (self.Death2)
	deathsounds[3] = (self.Death3)
	self:EmitSound( deathsounds[math.random(1,3)] )
		
		coroutine.wait(1)
		
	
		self:TakeDamage(math.huge, self)
		self:Explode()
		
		local effectdata = EffectData()
						effectdata:SetStart( self:GetPos() ) 
						effectdata:SetOrigin( self:GetPos() )
						effectdata:SetScale( 1 )
						util.Effect( "boss5explosion", effectdata )
		
		if (self:GetRangeTo(v) < 225) then
		v:Ignite(3)
		end
		
		end
		coroutine.wait(self.AttackFinishTime)	
		self:StartActivity( self.WalkAnim )
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

function ENT:Explode()
if SERVER then

			local explode = ents.Create("env_explosion")
	explode:SetPos(self:GetPos())
	explode:SetOwner(self:GetOwner())	
	explode:SetOwner(self)	
	explode:Spawn()
	explode:SetKeyValue( "iMagnitude", 100 )
	explode:Fire( "Explode", 0, 0 )
	explode:EmitSound("ambient/fire/gascan_ignite1.wav")
end
	
end

function ENT:OnOtherKilled()
end

function ENT:OnLeaveGround() 
end

function ENT:OnLandOnGround()
self:StartActivity( self.WalkAnim )
end

	if SERVER then
function ENT:OnKilled( dmginfo )

	local deathsounds = {}
	deathsounds[1] = (self.Death1)
	deathsounds[2] = (self.Death2)
	deathsounds[3] = (self.Death3)
	self:EmitSound( deathsounds[math.random(1,3)] )
	
	if not (dmginfo:IsExplosionDamage()) then
	local effectdata = EffectData()
	effectdata:SetStart( self:GetPos() ) 
	effectdata:SetOrigin( self:GetPos() )
	effectdata:SetScale( 1 )
	util.Effect( "boss5explosion", effectdata )
	
	local ents = ents.FindInSphere( self:GetPos(), 200 )
	for _,v in pairs(ents) do
	
		if v:IsPlayer() then
		v:TakeDamage(20, self)
		v:Ignite(3, 100)
		
		local moveAdd=Vector(0,0,350)
			if not v:IsOnGround() then
			moveAdd=Vector(0,0,0)
			end
			v:SetVelocity(moveAdd+((v:GetPos()-self:GetPos()):GetNormal()*200)) -- apply the velocity
		
		end
		
		if v:GetClass("prop_physics") then
		local phys = v:GetPhysicsObject()
			if (phys != nil && phys != NULL && phys:IsValid()) then
			phys:ApplyForceCenter(self:GetForward():GetNormalized()*30000 + Vector(0, 0, 2))
			v:TakeDamage(20, self)	
			v:Ignite(3, 100)
			end
		end	
		
	end
	else
	end
	
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

	if dmginfo:IsExplosionDamage() then
	dmginfo:ScaleDamage(10)
	else
	dmginfo:ScaleDamage(1)
	end

	if !dmginfo:GetAttacker():IsPlayer() then
		if dmginfo:GetAttacker():GetClass("nazi_zombie_*", "npc_nextbot_*", "mob_zombie_*") then
			if dmginfo:IsExplosionDamage() then
			dmginfo:ScaleDamage(0)
			end
		end
	end
	
end
	end
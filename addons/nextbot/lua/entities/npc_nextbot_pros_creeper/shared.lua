AddCSLuaFile()

ENT.Base             = "base_nextbot"
ENT.Spawnable        = false
ENT.AdminSpawnable   = false


--Stats--
ENT.Speed = 300
ENT.FlinchSpeed = 30

ENT.health = 135
ENT.Damage = 15

ENT.AttackWaitTime = 0.5
ENT.AttackFinishTime = 0.5

ENT.FallDamage = 0


--Model Settings--
ENT.Model = "models/NH2Zombies/creeper.mdl"

ENT.AttackAnim = (ACT_MELEE_ATTACK1)


ENT.WalkAnim = (ACT_RUN)

ENT.FlinchAnim = (ACT_MELEE_ATTACK1)
ENT.FallAnim = (ACT_IDLE_ON_FIRE)

ENT.AttackDoorAnim = (ACT_MELEE_ATTACK1)


--Sounds--
ENT.Attack1 = Sound("npc/zombie/zo_attack1.wav")
ENT.Attack2 = Sound("npc/zombie/zo_attack2.wav")

ENT.DoorBreak = Sound("npc/zombie/zombie_pound_door.wav")

ENT.Death1 = Sound("npc/zombie/zombie_die1.wav")
ENT.Death2 = Sound("npc/zombie/zombie_die2.wav")
ENT.Death3 = Sound("npc/zombie/zombie_die3.wav")

ENT.Alert1 = Sound("npc/zombie/zombie_alert1.wav")
ENT.Alert2 = Sound("npc/zombie/zombie_alert2.wav")
ENT.Alert3 = Sound("npc/zombie/zombie_alert3.wav")

ENT.Flinch1 = Sound("none")
ENT.Flinch2 = Sound("none")
ENT.Flinch3 = Sound("none")

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
	self.Entity:SetCollisionBounds( Vector(-4,-4,0), Vector(4,4,64) )
    self:SetCollisionGroup(COLLISION_GROUP_DEBRIS)
	
    self:SetModel(self.Model)
	self:SetMaterial("models/props_combine/portalball001_sheet")	
	self:SetHealth(self.health)
	
	local color = math.random(1,5)
		if color == 1 then self:SetColor(Color(150, 10, 10, 255))
		elseif color == 2 then self:SetColor(Color(10, 150, 10, 255)) 
		elseif color == 3 then self:SetColor(Color(10, 10, 150, 255))
		elseif color == 4 then self:SetColor(Color( 100, 100, 0, 255))
		elseif color == 5 then self:SetColor(Color( 255, 255, 255, 255))
	end
	
	self.LoseTargetDist	= 1000	-- How far the enemy has to be before we lose them
	self.SearchRadius 	= 2500	-- How far to search for enemies
	
	--Misc--
	self:Precache()
	self.loco:SetStepHeight(35)
	self.loco:SetAcceleration(400)
	self.loco:SetDeceleration(900)
	self.LastPos = self:GetPos()
	self.nextbot = true
end

function ENT:BehaveAct()
end

function ENT:Think()
self.LastPos = self.Entity:GetPos() 
end

function ENT:OnStuck()
	if self.LastPos:Distance( self.Entity:GetPos() ) < 100 then
		self.Entity:SetPos( self.LastPos )
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
	local entstoattack = ents.FindInSphere(self:GetPos(), 55)
	for _,v in pairs(entstoattack) do
	
		if (v:GetClass() == "prop_physics") then
		
		if SERVER then
		local sounds = {}
	sounds[1] = (self.Attack1)
	sounds[2] = (self.Attack2)
		self:EmitSound( sounds[math.random(1,2)] )
		end
	
	
		self:RestartGesture(self.AttackAnim)  
		coroutine.wait(self.AttackWaitTime)
		self:EmitSound(self.Miss)
		
		if not ( v:IsValid() ) then return end
		if (self:GetRangeTo(v) < 60) then
		if not ( v:IsValid() ) then return end
		
		if not ( v:IsValid() ) then return end
		local phys = v:GetPhysicsObject()
			if (phys != nil && phys != NULL && phys:IsValid()) then
			phys:ApplyForceCenter(self:GetForward():GetNormalized()*30000 + Vector(0, 0, 10))
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

function ENT:AttackBreakable()
	local entstoattack = ents.FindInSphere(self:GetPos(), 55)
	for _,v in pairs(entstoattack) do
	
		if (v:GetClass() == "func_breakable") then
		
		if SERVER then
		local sounds = {}
	sounds[1] = (self.Attack1)
	sounds[2] = (self.Attack2)
		self:EmitSound( sounds[math.random(1,2)] )
		end
	
	
	self:RestartGesture(self.AttackAnim)  
		coroutine.wait(self.AttackWaitTime)
		self:EmitSound(self.Miss)
		
		if not ( v:IsValid() ) then return end
			v:EmitSound(self.DoorBreak)
			v:TakeDamage(self.Damage, self)	
			
		coroutine.wait(self.AttackFinishTime)	
		self:StartActivity( self.WalkAnim )
			return true
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
	sounds[5] = (self.Idle5)
	sounds[6] = (self.Idle6)
	sounds[7] = (self.Idle7)
	sounds[8] = (self.Idle8)
	sounds[9] = (self.Idle9)
		self:EmitSound( sounds[math.random(1,9)])
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
			self:AlertSound()
			self:StartActivity(self.WalkAnim)
			self.loco:SetDesiredSpeed(self.Speed)
			self:ChaseEnemy() 
		else
			-- Wander around
			self:StartActivity(self.WalkAnim)
			self.loco:SetDesiredSpeed(self.Speed)
			self:IdleSounds()
			self:MoveToPos( self:GetPos() + Vector( math.Rand( -1, 1 ), math.Rand( -1, 1 ), 0 ) * 400 )
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
	if math.random( 1,20) == 5 then
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
	
	local door = ents.FindInSphere(self:GetPos(),60)
		if door then
			for i = 1, #door do
				local v = door[i]
				if !v:IsPlayer() and v != self and IsValid( v ) then
					if self:GetDoor( v ) == "door" then
					
						if v.Hitsleft == nil then
							v.Hitsleft = 10
						end
						
						if v != NULL and v.Hitsleft > 0 then
							if (self:GetRangeTo(v) < 65) then
							
								self:RestartGesture(self.AttackDoorAnim)
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
						
		
	local ent = ents.FindInSphere( self:GetPos(), 50) 
		for k,v in pairs( ent ) do
		
		if ((v:IsNPC() || (v:IsPlayer() && v:Alive() && !self.IgnorePlayer))) then
		if not ( v:IsValid() && v:Health() > 0 ) then return end
		
		if SERVER then
		local sounds = {}
	sounds[1] = (self.Attack1)
	sounds[2] = (self.Attack2)
		self:EmitSound( sounds[math.random(1,2)] )
		end
	
		self:RestartGesture(self.AttackAnim)  
		coroutine.wait(self.AttackWaitTime)
		self:EmitSound(self.Miss)
		
		if (self:GetRangeTo(v) < 65) then

		if v:IsPlayer() then
			v:EmitSound(self.Hit)
			v:TakeDamage(self.Damage, self)			
			v:ViewPunch(Angle(math.random(-1, 1)*self.Damage, math.random(-1, 1)*self.Damage, math.random(-1, 1)*self.Damage))
			
			local moveAdd=Vector(0,0,150)
		if not v:IsOnGround() then
		moveAdd=Vector(0,0,0)
		end
		v:SetVelocity(moveAdd+((self.Enemy:GetPos()-self:GetPos()):GetNormal()*100)) -- apply the velocity
			
			end

		if v:IsNPC() then
			v:EmitSound(self.Hit)
			v:TakeDamage(self.Damage, self)	
			end

		end
		coroutine.wait(self.AttackFinishTime)	
		end
		end
		
		if (self:GetEnemy() != nil) then
			if (self:GetEnemy():GetPos():Distance(self:GetPos()) < 50 || self:AttackProp()) then
			else
			if (self:GetEnemy():GetPos():Distance(self:GetPos()) < 50 || self:AttackBreakable()) then
			end
			end
			
		end
		coroutine.yield()
	end
	return "ok"
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
	local ragdoll = ents.Create( "prop_ragdoll" )
	ragdoll:SetModel( self:GetModel() )
	ragdoll:SetPos( self:GetPos() )
	ragdoll:SetAngles( self:GetAngles() )
	ragdoll:Spawn()
	ragdoll:SetSkin( self:GetSkin() )
	ragdoll:SetColor( self:GetColor() )


	local phys = ragdoll:GetPhysicsObject()
	if phys != nil then
		phys:EnableGravity(false)
	end
	

	undo.ReplaceEntity(self,ragdoll)
	cleanup.ReplaceEntity(self,ragdoll)


	if self:IsOnFire() then ragdoll:Ignite( math.Rand( 8, 10 ), 0 ) end


        for i=1,128 do
		local bone = ragdoll:GetPhysicsObjectNum( i )
		if IsValid( bone ) then
			local bonepos, boneang = self:GetBonePosition( ragdoll:TranslatePhysBoneToBone( i ) )
			bone:SetPos( bonepos )
			bone:SetAngles( boneang )
		end
	end
	if( GetConVarNumber("ai_keepragdolls") == 0 ) then
		ragdoll:SetCollisionGroup( 1 )//COLLISION_GROUP_DEBRIS )

	self:Remove()
	end
end

function ENT:OnInjured( dmginfo )
	if dmginfo:IsExplosionDamage() then
	dmginfo:ScaleDamage(10)
	else
	dmginfo:ScaleDamage(1)
	end

	if math.random( 1,20 ) == 5 then
	self:RestartGesture(self.FlinchAnim)
	
	local flinchsounds = {}
	flinchsounds[1] = (self.Flinch1)
	flinchsounds[2] = (self.Flinch2)
	flinchsounds[3] = (self.Flinch3)
	self:EmitSound( flinchsounds[math.random(1,2)] )
	
	if not ( self:IsValid() && self:Health() > 0 ) then return end
	self.loco:SetDesiredSpeed( self.FlinchSpeed )	
	
	timer.Simple(0.6, function() 
	if not ( self:IsValid() && self:Health() > 0 ) then return end
	self.loco:SetDesiredSpeed( self.Speed )		
	self:StartActivity(self.WalkAnim)
	end)
	
	end

	if math.random( 1,3 ) == 2 then
	local painsounds = {}
	painsounds[1] = (self.Pain1)
	painsounds[2] = (self.Pain2)
	painsounds[3] = (self.Pain3)
	painsounds[4] = (self.Pain4)
	painsounds[5] = (self.Pain5)
	painsounds[6] = (self.Pain6)
	self:EmitSound( painsounds[math.random(1,6)] )
	end
	
end
	end
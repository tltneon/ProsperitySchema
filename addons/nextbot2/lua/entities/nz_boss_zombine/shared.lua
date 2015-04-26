AddCSLuaFile()

ENT.Base             = "nz_base"
ENT.Spawnable        = false
ENT.AdminSpawnable   = false

--SpawnMenu--
list.Set( "NPC", "nz_boss_zombine", {
	Name = "(B) Elite Zombine",
	Class = "nz_boss_zombine",
	Category = "NextBot Zombies 2.0"
} )

--Stats--
ENT.ModelScale = 1.3 

ENT.Speed = 65
ENT.WalkSpeedAnimation = 0.6
ENT.FlinchSpeed = 10

ENT.health = 3550
ENT.Damage = 25

ENT.PhysForce = 30000
ENT.AttackRange = 65
ENT.InitialAttackRange = 70
ENT.DoorAttackRange = 25

ENT.AttackWaitTime = 0.8
ENT.AttackFinishTime = 0.2

--Model Settings--
ENT.Model = "models/zombie/zombineplayer.mdl"

ENT.AttackAnim = "FastAttack"

ENT.RageWalk = (ACT_RUN)
ENT.WalkAnim = (ACT_WALK)

ENT.AttackDoorAnim = (ACT_GMOD_GESTURE_RANGE_ZOMBIE)

--Sounds--
ENT.Attack1 = Sound("npc/zombine/attack1.wav")
ENT.Attack2 = Sound("npc/zombine/attack2.wav")

ENT.DoorBreak = Sound("npc/zombie/zombie_pound_door.wav")

ENT.Enrage1 = Sound("npc/zombine/enrage1.wav")
ENT.Enrage2 = Sound("npc/zombine/enrage2.wav")

ENT.Death1 = Sound("npc/zombine/death1.wav")
ENT.Death2 = Sound("npc/zombine/death2.wav")
ENT.Death3 = Sound("npc/zombine/death3.wav")

ENT.Idle1 = Sound("npc/zombine/idle1.wav")
ENT.Idle2 = Sound("npc/zombine/idle2.wav")
ENT.Idle3 = Sound("npc/zombine/idle3.wav")
ENT.Idle4 = Sound("npc/zombine/idle4.wav")

ENT.Pain1 = Sound("npc/zombine/pain1.wav")
ENT.Pain2 = Sound("npc/zombine/pain2.wav")
ENT.Pain3 = Sound("npc/zombine/pain3.wav")

ENT.Hit = Sound("npc/zombie/claw_strike1.wav")
ENT.Miss = Sound("npc/zombie/claw_miss1.wav")

function ENT:Precache()

--Models--
util.PrecacheModel(self.Model)
	
--Sounds--	
util.PrecacheSound(self.Attack1)
util.PrecacheSound(self.Attack2)

util.PrecacheSound(self.DoorBreak)

util.PrecacheSound(self.Enrage1)
util.PrecacheSound(self.Enrage2)

util.PrecacheSound(self.Death1)
util.PrecacheSound(self.Death2)
util.PrecacheSound(self.Death3)

util.PrecacheSound(self.Idle1)
util.PrecacheSound(self.Idle2)
util.PrecacheSound(self.Idle3)
util.PrecacheSound(self.Idle4)
	
util.PrecacheSound(self.Pain1)
util.PrecacheSound(self.Pain2)
util.PrecacheSound(self.Pain3)
	
util.PrecacheSound(self.Hit)
util.PrecacheSound(self.Miss)

end

function ENT:Initialize()

	--Stats--
	self:SetModel(self.Model)
	self:SetHealth(self.health)	
	self:SetModelScale( self.ModelScale, 0 )
	self:SetColor( Color( 255, 205, 205, 255 ) )
	
	self.LoseTargetDist	= (self.LoseTargetDist)
	self.SearchRadius 	= (self.SearchRadius)
	
	self.IsAttacking = false
	self.HasNoEnemy = false
	self.Status = 1
	self.Changing = false
	self.Throwing = false
	
	self.loco:SetStepHeight(35)
	self.loco:SetAcceleration(600)
	self.loco:SetDeceleration(900)
	
	--Misc--
	self:SetCollisionGroup(COLLISION_GROUP_DEBRIS)
	self:Precache()
	self:CreateBullseye()
	
end

function ENT:CustomThink()
	if self.Enemy and self.Enemy:IsValid() and self.Enemy:Health() > 0 then
		if self.Throwing then
			if (GetConVarNumber("nb_stop") == 0) then
			self.loco:FaceTowards( self.Enemy:GetPos() )
			end
		end
	end
end

function ENT:ZombineStart()
	self:BehaveStart()
end

function ENT:ZombineEnd()
	self:BehaveStart()
end

function ENT:CustomDeath( dmginfo )
	self:DeathAnimation( "nz_deathanim_base", self:GetPos(), ACT_HL2MP_RUN_ZOMBIE, 1 )
end

function ENT:ThrowGrenade( velocity )
	local ent = ents.Create("ent_nz_grenade")
	if ent:IsValid() and self:IsValid() then
		ent:SetPos(self:EyePos() + Vector(0,0,25))
		ent:Spawn()
		ent:SetOwner( self )
				
	local phys = ent:GetPhysicsObject()
	if phys:IsValid() then
	local ang = self:EyeAngles()
	ang:RotateAroundAxis(ang:Forward(), math.Rand(-10, 10))
	ang:RotateAroundAxis(ang:Up(), math.Rand(-10, 10))
	phys:SetVelocityInstantaneous(ang:Forward() * math.Rand( velocity, velocity + 300 ))
				
	end
	end
end

ENT.nxtCustomChaseEnemy = 0
function ENT:CustomChaseEnemy()

	if self.Attacking then return end

	if self:IsLineOfSightClear( self.Enemy ) then
		if self:GetRangeTo( self.Enemy ) > self.InitialAttackRange and self:GetRangeTo( self.Enemy ) < 325 then

		if !self.nxtCustomChaseEnemy then self.nxtCustomChaseEnemy = 0 end
		if CurTime() < self.nxtCustomChaseEnemy then return end

		self.nxtCustomChaseEnemy = CurTime() + 4
	
			self:RestartGesture( ACT_GMOD_GESTURE_ITEM_THROW )
			self.Throwing = true
	
			timer.Simple( 0.6, function()
			if !self:IsValid() then return end
			if self:Health() < 0 then return end
			if self.Attacking then return end
			self:ThrowGrenade( math.random(500, 600) )
			self.Throwing = false
			end)
			
			
		end
	end
	
end

function ENT:Enrage()
	self.Status = 2
	self.Changing = true
			
	self.loco:SetDesiredSpeed( 0 )
	self:SetSequence("Tantrum")
	self:SetPlaybackRate(0.2)
	self:SetCycle(0)
	self:EnrageSound()
		
	timer.Simple( 0.9, function()
	if !self:IsValid() then return end
	if self:Health() < 0 then return end
	self.Changing = false
	self:BehaveStart()
	end)
end

function ENT:CustomInjure( dmginfo )
	
	if ( dmginfo:IsBulletDamage() ) then

	local attacker = dmginfo:GetAttacker()
        // hack: get hitgroup
	local trace = {}
	trace.start = attacker:GetShootPos()
		
	trace.endpos = trace.start + ( ( dmginfo:GetDamagePosition() - trace.start ) * 2 )  
	trace.mask = MASK_SHOT
	trace.filter = attacker
		
	local tr = util.TraceLine( trace )
	hitgroup = tr.HitGroup
	
		self:EmitSound("kevlar/kevlar_hit"..math.random(2)..".wav", 65)
		
		if attacker:IsNPC() then
		dmginfo:ScaleDamage(0.75)
		else
		dmginfo:ScaleDamage(0.55)
		end
	
		if self:Health() < 2000 then
			if self.Changing then return end
			if self.Status == 2 then return end
			self:Enrage()
		end
	
	end

end

function ENT:FootSteps()
	self:EmitSound("npc/combine_soldier/gear"..math.random(6)..".wav", 65)
end

function ENT:AlertSound()
end

function ENT:PainSound()
	if math.random(1,10) == 1 then
	local sounds = {}
		sounds[1] = (self.Pain1)
		sounds[2] = (self.Pain2)
		sounds[3] = (self.Pain3)
		self:EmitSound( sounds[math.random(1,3)] )
	end
end

function ENT:EnrageSound()
	local sounds = {}
		sounds[1] = (self.Enrage1)
		sounds[2] = (self.Enrage2)
		self:EmitSound( sounds[math.random(1,2)] )
end

function ENT:DeathSound()
	local sounds = {}
		sounds[1] = (self.Death1)
		sounds[2] = (self.Death2)
		sounds[3] = (self.Death3)
		self:EmitSound( sounds[math.random(1,3)] )
end

function ENT:AttackSound()
	local sounds = {}
		sounds[1] = (self.Attack1)
		sounds[2] = (self.Attack2)
		self:EmitSound( sounds[math.random(1,2)] )
end

function ENT:IdleSound()
	local sounds = {}
	sounds[1] = (self.Idle1)
	sounds[2] = (self.Idle2)
	sounds[3] = (self.Idle3)
	sounds[4] = (self.Idle4)
	self:EmitSound( sounds[math.random(1,4)] )
end

function ENT:RunBehaviour()
	while ( true ) do
		if ( self:HaveEnemy() ) then
			self.HasNoEnemy = false
			self:AlertSound()
			
			if self.Status == 1 then
			self:StartActivity( self.WalkAnim )
			self.loco:SetDesiredSpeed( self.Speed )
			elseif self.Status == 2 then
			self:StartActivity( self.RageWalk )
			self.loco:SetDesiredSpeed( self.Speed + 200 )
			end
		
			self:ChaseEnemy() 
		else
			-- Wander around
			self.HasNoEnemy = true
			
			self:StartActivity( ACT_IDLE )
			
		end
		coroutine.wait( 0.50 )
		self:IdleSounds()
		coroutine.yield()
	end
end	

function ENT:CustomDoorAttack( ent )	
			
	self:AttackSound()
		
	timer.Simple( 0.5, function()
		if !self:CheckValid( ent ) then 
		self:EmitSound("npc/zombie/claw_miss"..math.random(2)..".wav", 77, math.random(60, 70))
		self:BehaveStart()
		return end
		
		ent:EmitSound(self.DoorBreak)
	end)
	
	self:PlaySequenceAndWait( self.AttackAnim, 0.8 )
	self:BehaveStart()		
	
end

function ENT:CustomPropAttack( ent )
	self:AttackSound()
		
	timer.Simple( 0.5, function()
		if !self:CheckValid( ent ) then 
		self:EmitSound("npc/zombie/claw_miss"..math.random(2)..".wav", 77, math.random(60, 70))
		self:BehaveStart()
		return end
		
		if (self:GetRangeTo( ent ) < (self.AttackRange)) then

		local phys = ent:GetPhysicsObject()
			if (phys != nil && phys != NULL && phys:IsValid() ) then
			phys:ApplyForceCenter(self:GetForward():GetNormalized()*(self.PhysForce) + Vector(0, 0, 2))
			ent:EmitSound(self.DoorBreak)
			ent:TakeDamage(self.Damage, self)	
			end
		end
	end)
	
	self:PlaySequenceAndWait( self.AttackAnim, 0.8 )
	self:BehaveStart()
	
end

function ENT:AttackEffect( time, speed, damage )
	timer.Simple(time, function() 
		if !self:IsValid() then return end
		if self:Health() < 0 then return end
		if !self:CheckValid( self.Enemy ) then return end
	
		if (self:GetRangeTo(self.Enemy) < (self.AttackRange)) then
			
			self:EmitSound("npc/zombie/claw_strike"..math.random(2)..".wav", 77, math.random(60, 70))
			self.Enemy:TakeDamage( damage, self)	
			
			if !self.Enemy:IsNPC() then
				self.Enemy:ViewPunch(Angle(math.random(-1, 1)*self.Damage, math.random(-1, 1)*self.Damage, math.random(-1, 1)*self.Damage))
			end
			
			self:BleedVisual( 0.2, self.Enemy:GetPos() + Vector(0,0,50) )	
			
	end	
		self:EmitSound("npc/zombie/claw_miss"..math.random(2)..".wav", 77, math.random(60, 70))
	end)
		
	self:PlaySequenceAndWait( self.AttackAnim, speed )
	self:BehaveStart()
end

ENT.nxtAttack = 0
function ENT:Attack()

	if !self.nxtAttack then self.nxtAttack = 0 end
    if CurTime() < self.nxtAttack then return end

    self.nxtAttack = CurTime() + 1.2
		
		if ( (self.Enemy:IsValid() and self.Enemy:Health() > 0 ) ) then
		
		if self.Changing then return end
		if self.Throwing then return end
		
		self:AttackSound()
		self.Enemy = self.Enemy	
		self.IsAttacking = true
		
		if self.Status == 1 then
		self:AttackEffect( 0.5, 0.8, self.Damage )
		else
		self:AttackEffect( 0.3, 1.5, self.Damage + 5 )
		end
		
		self.IsAttacking = false
		end
end
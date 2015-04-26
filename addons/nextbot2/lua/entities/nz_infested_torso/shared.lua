AddCSLuaFile()

ENT.Base             = "nz_base"
ENT.Spawnable        = false
ENT.AdminSpawnable   = false

--SpawnMenu--
list.Set( "NPC", "nz_infested_torso", {
	Name = "Infested Torso",
	Class = "nz_infested_torso",
	Category = "NextBot Zombies 2.0"
} )

--Stats--
ENT.Bone1 = ("ValveBiped.Bip01_R_Forearm")
ENT.Bone2 = ("ValveBiped.Bip01_L_Forearm")

ENT.Speed = 35
ENT.WalkSpeedAnimation = 0.6
ENT.FlinchSpeed = 30

ENT.health = 55
ENT.Damage = 25

ENT.PhysForce = 9000
ENT.AttackRange = 35
ENT.InitialAttackRange = 40
ENT.DoorAttackRange = 20

ENT.AttackWaitTime = 0.5
ENT.AttackFinishTime = 0.2

--Model Settings--
ENT.Model = "models/Zombie/Classic_torso.mdl"

ENT.AttackAnim = (ACT_MELEE_ATTACK1)

ENT.WalkAnim = (ACT_WALK)
ENT.Idle = (ACT_IDLE)

ENT.AttackDoorAnim = (ACT_GMOD_GESTURE_RANGE_ZOMBIE)

--Sounds--
ENT.Attack1 = Sound("npc/zombie/zo_attack1.wav")
ENT.Attack2 = Sound("npc/zombie/zo_attack2.wav")

ENT.DoorBreak = Sound("npc/zombie/zombie_pound_door.wav")

ENT.Alert1 = Sound("npc/zombie/zombie_alert1.wav")
ENT.Alert2 = Sound("npc/zombie/zombie_alert2.wav")
ENT.Alert3 = Sound("npc/zombie/zombie_alert3.wav")

ENT.Death1 = Sound("npc/zombie/zombie_die1.wav")
ENT.Death2 = Sound("npc/zombie/zombie_die2.wav")
ENT.Death3 = Sound("npc/zombie/zombie_die3.wav")

ENT.Idle1 = Sound("npc/zombie/zombie_voice_idle1.wav")
ENT.Idle2 = Sound("npc/zombie/zombie_voice_idle2.wav")
ENT.Idle3 = Sound("npc/zombie/zombie_voice_idle3.wav")
ENT.Idle4 = Sound("npc/zombie/zombie_voice_idle4.wav")
ENT.Idle5 = Sound("npc/zombie/zombie_voice_idle5.wav")

ENT.Pain1 = Sound("npc/zombie/zombie_pain1.wav")
ENT.Pain2 = Sound("npc/zombie/zombie_pain2.wav")
ENT.Pain3 = Sound("npc/zombie/zombie_pain3.wav")
ENT.Pain4 = Sound("npc/zombie/zombie_pain4.wav")
ENT.Pain5 = Sound("npc/zombie/zombie_pain5.wav")

ENT.Hit = Sound("npc/zombie/claw_strike1.wav")
ENT.Miss = Sound("npc/zombie/claw_miss1.wav")

function ENT:Precache()

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

util.PrecacheSound(self.Idle1)
util.PrecacheSound(self.Idle2)
util.PrecacheSound(self.Idle3)
util.PrecacheSound(self.Idle4)
util.PrecacheSound(self.Idle5)
	
util.PrecacheSound(self.Pain1)
util.PrecacheSound(self.Pain2)
util.PrecacheSound(self.Pain3)
util.PrecacheSound(self.Pain4)	
util.PrecacheSound(self.Pain5)
	
util.PrecacheSound(self.Hit)
util.PrecacheSound(self.Miss)

end

function ENT:Initialize()

	--Stats--
	self:SetModel(self.Model)
	self:SetHealth(self.health)	
	
	self.LoseTargetDist	= (self.LoseTargetDist)
	self.SearchRadius 	= (self.SearchRadius)
	
	self.IsAttacking = false
	self.HasNoEnemy = false
	
	self.loco:SetStepHeight(35)
	self.loco:SetAcceleration(400)
	self.loco:SetDeceleration(900)
	
	--Misc--
	self:SetCollisionGroup(COLLISION_GROUP_DEBRIS)
	self:Precache()
	self:CreateBullseye()
	
end

function ENT:RunBehaviour()
	while ( true ) do
		if ( self:HaveEnemy() ) then
			self.HasNoEnemy = false
			
			self:StartActivity(self.WalkAnim)
			self.loco:SetDesiredSpeed( self.Speed )

			self:ChaseEnemy()
			
		else
			self.HasNoEnemy = true
			
			self:StartActivity(self.Idle)
			
			self:CustomWander()
		end
		coroutine.wait( 0.50 )
	end
end

function ENT:CustomDeath( dmginfo )

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
	
		if hitgroup == HITGROUP_HEAD then
			self:EmitSound("hits/headshot_"..math.random(9)..".wav", 70)
			self:BleedVisual( 0.2, self:GetPos() + Vector(0,0,5) )
		end
	
	end

	self:BecomeRagdoll( dmginfo )
	
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
			
		if hitgroup == HITGROUP_HEAD then
			if attacker:IsNPC() then
				dmginfo:ScaleDamage(5)
			else
				dmginfo:ScaleDamage(4)
			end
		else
			if attacker:IsNPC() then
				dmginfo:ScaleDamage(0.70)
			else
				dmginfo:ScaleDamage(0.60)
			end
		end
		
	end

end

function ENT:FootSteps()
	self:EmitSound("npc/zombie/foot"..math.random(3)..".wav", 70)
end

function ENT:AlertSound()
	local sounds = {}
		sounds[1] = (self.Alert1)
		sounds[2] = (self.Alert2)
		sounds[3] = (self.Alert3)
		self:EmitSound( sounds[math.random(1,3)] )
end

function ENT:PainSound()
	if math.random(1,3) == 1 then
	local sounds = {}
		sounds[1] = (self.Pain1)
		sounds[2] = (self.Pain2)
		sounds[3] = (self.Pain3)
		sounds[4] = (self.Pain4)
		sounds[5] = (self.Pain5)
		self:EmitSound( sounds[math.random(1,5)] )
	end
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
		sounds[5] = (self.Idle5)
		self:EmitSound( sounds[math.random(1,5)] )
end

function ENT:CustomDoorAttack( ent )	
			
	self:AttackSound()
	self:StartActivity(self.AttackAnim)
	coroutine.wait(self.AttackWaitTime)
		
	timer.Simple( 0.5, function()
		if !self:CheckValid( ent ) then 
		self:EmitSound("npc/zombie/claw_miss"..math.random(2)..".wav", 77, math.random(60, 70))
		self:BehaveStart()
		return end
		
		ent:EmitSound(self.DoorBreak)
	end)
	
	coroutine.wait(self.AttackFinishTime)
	self:StartActivity(self.WalkAnim)	
	
end

function ENT:CustomPropAttack( ent )

	self:AttackSound()
	self:StartActivity(self.AttackAnim)
	coroutine.wait(self.AttackWaitTime)
		
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
	
	coroutine.wait(self.AttackFinishTime)
	self:StartActivity(self.WalkAnim)		
	
end

function ENT:BleedEffect( ent )
	if self:CheckValid( ent ) then
	
		ent:TakeDamage(5, self)	
		ent:EmitSound("player/pl_pain"..math.random(5,7)..".wav", 70)
		
		if !ent:IsNPC() then
		ent:ViewPunch(Angle(math.random(-1, 1)*5, math.random(-1, 1)*5, math.random(-1, 1)*5))
		end
	
		self:BleedVisual( 0.2, ent:GetPos() + Vector(0,0,50) )	
		
	else
	ent.IsBleeding = false
	end
end

function ENT:Bleed( ent )

	if ent.IsBleeding then return end
	ent.IsBleeding = true
	
	timer.Simple(6, function() 
		ent.IsBleeding = false
	end)
	
	timer.Simple(2, function() 
		if ent:IsValid() and ent:Health() > 0 then
			if self:IsValid() and self:Health() > 0 then
			self:BleedEffect( ent )
			end
		end
	end)
	
	timer.Simple(4, function() 
		if ent:IsValid() and ent:Health() > 0 then
			if self:IsValid() and self:Health() > 0 then
			self:BleedEffect( ent )
			end
		end
	end)
	
end

ENT.nxtAttack = 0
function ENT:Attack()

	if !self.nxtAttack then self.nxtAttack = 0 end
    if CurTime() < self.nxtAttack then return end

    self.nxtAttack = CurTime() + 1.2
		
		if ( (self.Enemy:IsValid() and self.Enemy:Health() > 0 ) ) then
		
		self:AttackSound()
		self.Enemy = self.Enemy	
		self.IsAttacking = true
		self:StartActivity(self.AttackAnim)
		coroutine.wait( self.AttackWaitTime )
		
		if !self:IsValid() then return end
		if self:Health() < 0 then return end
		if !self:CheckValid( self.Enemy ) then return end
		
		if (self:GetRangeTo(self.Enemy) < (self.AttackRange)) then
			
			self:EmitSound(self.Hit)
			self.Enemy:TakeDamage(self.Damage, self)	
			self:Bleed( self.Enemy )
			
			if !self.Enemy:IsNPC() then
			self.Enemy:ViewPunch(Angle(math.random(-1, 1)*self.Damage, math.random(-1, 1)*self.Damage, math.random(-1, 1)*self.Damage))
			end
			
			self:BleedVisual( 0.2, self.Enemy:GetPos() + Vector(0,0,50) )	
			
		else
		self:EmitSound(self.Miss)
		end
		
		coroutine.wait(self.AttackFinishTime)
		self:StartActivity( self.WalkAnim )
		
		self.IsAttacking = false
		end
end
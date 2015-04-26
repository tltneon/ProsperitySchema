AddCSLuaFile()

ENT.Base             = "nz_base"
ENT.Spawnable        = false
ENT.AdminSpawnable   = false

--SpawnMenu--
list.Set( "NPC", "nz_infected", {
	Name = "Infected",
	Class = "nz_infected",
	Category = "NextBot Zombies 2.0"
} )

--Stats--
ENT.Speed = 120
ENT.WalkSpeedAnimation = 0.7
ENT.FlinchSpeed = 0

ENT.health = 120
ENT.Damage = 25

ENT.PhysForce = 15000
ENT.AttackRange = 55
ENT.InitialAttackRange = 50
ENT.DoorAttackRange = 25

ENT.AttackWaitTime = 0.8
ENT.AttackFinishTime = 0.2

--Model Settings--
ENT.Model = "models/infected/zombie_01.mdl"
ENT.Model2 = "models/infected/zombie_02.mdl"
ENT.Model3 = "models/infected/zombie_03.mdl"

ENT.AttackAnim = (ACT_MELEE_ATTACK1)

ENT.WalkAnim = (ACT_RUN)
ENT.WalkAnim2 = (ACT_HL2MP_WALK_ZOMBIE_03)

ENT.FlinchAnim = (ACT_HL2MP_ZOMBIE_SLUMP_RISE)

ENT.AttackDoorAnim = (ACT_GMOD_GESTURE_RANGE_ZOMBIE)

--Sounds--
ENT.Attack1 = Sound("npc/infected/zo_attack1.wav")
ENT.Attack2 = Sound("npc/infected/zo_attack2.wav")

ENT.DoorBreak = Sound("npc/zombie/zombie_pound_door.wav")

ENT.Alert1 = Sound("npc/infected/zombie_alert1.wav")
ENT.Alert2 = Sound("npc/infected/zombie_alert2.wav")
ENT.Alert3 = Sound("npc/infected/zombie_alert3.wav")
ENT.Alert4 = Sound("npc/infected/zombie_alert4.wav")

ENT.Death1 = Sound("npc/infected/zombie_die1.wav")
ENT.Death2 = Sound("npc/infected/zombie_die2.wav")
ENT.Death3 = Sound("npc/infected/zombie_die3.wav")
ENT.Death4 = Sound("npc/infected/zombie_die4.wav")
ENT.Death5 = Sound("npc/infected/zombie_die5.wav")
ENT.Death6 = Sound("npc/infected/zombie_die6.wav")

ENT.Idle1 = Sound("npc/infected/zombie_voice_idle1.wav")
ENT.Idle2 = Sound("npc/infected/zombie_voice_idle2.wav")
ENT.Idle3 = Sound("npc/infected/zombie_voice_idle3.wav")
ENT.Idle4 = Sound("npc/infected/zombie_voice_idle4.wav")
ENT.Idle5 = Sound("npc/infected/zombie_voice_idle5.wav")
ENT.Idle6 = Sound("npc/infected/zombie_voice_idle6.wav")
ENT.Idle7 = Sound("npc/infected/zombie_voice_idle7.wav")
ENT.Idle8 = Sound("npc/infected/zombie_voice_idle8.wav")

ENT.Pain1 = Sound("npc/infected/zombie_pain1.wav")
ENT.Pain2 = Sound("npc/infected/zombie_pain2.wav")
ENT.Pain3 = Sound("npc/infected/zombie_pain3.wav")
ENT.Pain4 = Sound("npc/infected/zombie_pain4.wav")
ENT.Pain5 = Sound("npc/infected/zombie_pain5.wav")
ENT.Pain6 = Sound("npc/infected/zombie_pain6.wav")

ENT.Hit = Sound("npc/zombie/claw_strike1.wav")
ENT.Miss = Sound("npc/zombie/claw_miss1.wav")

function ENT:Precache()

--Models--
util.PrecacheModel(self.Model)
util.PrecacheModel(self.Model2)
util.PrecacheModel(self.Model3)	
	
--Sounds--	
util.PrecacheSound(self.Attack1)
util.PrecacheSound(self.Attack2)

util.PrecacheSound(self.DoorBreak)

util.PrecacheSound(self.Death1)
util.PrecacheSound(self.Death2)
util.PrecacheSound(self.Death3)
util.PrecacheSound(self.Death4)
util.PrecacheSound(self.Death5)
util.PrecacheSound(self.Death6)

util.PrecacheSound(self.Alert1)
util.PrecacheSound(self.Alert2)
util.PrecacheSound(self.Alert3)
util.PrecacheSound(self.Alert4)

util.PrecacheSound(self.Idle1)
util.PrecacheSound(self.Idle2)
util.PrecacheSound(self.Idle3)
util.PrecacheSound(self.Idle4)
util.PrecacheSound(self.Idle5)
util.PrecacheSound(self.Idle6)	
util.PrecacheSound(self.Idle7)
util.PrecacheSound(self.Idle8)
	
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
	
	local model = math.random(1,3)
	if model == 1 then self:SetModel(self.Model)
	elseif model == 2 then self:SetModel(self.Model2)
	elseif model == 3 then self:SetModel(self.Model3)
	end
	
	local anim = math.random(1,4)
	if anim == 1 then
	self.WalkAnim = ACT_HL2MP_RUN_ZOMBIE
	self.WalkSpeedAnimation = 0.70
	elseif anim == 2 then
	self.WalkAnim = ACT_HL2MP_RUN_KNIFE
	self.WalkSpeedAnimation = 0.80
	elseif anim == 3 then
	self.WalkAnim = ACT_RUN
	elseif anim == 4 then
	self.WalkAnim = ACT_WALK
	end
	
	self:SetHealth(self.health)	
	
	self.LoseTargetDist	= (self.LoseTargetDist)
	self.SearchRadius 	= (self.SearchRadius)
	
	self.IsAttacking = false
	self.HasNoEnemy = false
	self.BrokeLeg = false
	self.Flinching = false
	
	self.loco:SetStepHeight(35)
	self.loco:SetAcceleration(400)
	self.loco:SetDeceleration(900)
	
	--Misc--
	self:SetCollisionGroup(COLLISION_GROUP_DEBRIS)
	self:Precache()
	self:CreateBullseye()
	
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
			self:BleedVisual( 0.2, self:GetPos() + Vector(0,0,55) )	
		end
	
	end

	if dmginfo:IsExplosionDamage() then
		self:BecomeRagdoll(dmginfo)
	else
		self:DeathAnimation( "nz_deathanim_base", self:GetPos(), self.WalkAnim, 1 )
	end
	
end

ENT.nxtFlinch = 0
function ENT:Flinch()
	
	if !self.nxtFlinch then self.nxtFlinch = 0 end
    if CurTime() < self.nxtFlinch then return end

    self.nxtFlinch = CurTime() + 4
	
	if !self:CheckValid( self ) then return end
	
	self:StartActivity( self.FlinchAnim )
	self:SetCycle(math.Rand(0.8, 0.9))
		
	self.loco:SetDesiredSpeed( 0 )
	self:SetPoseParameter("move_x",0.4)	
	
	self.Flinching = true
	
	timer.Simple(0.5, function() 
	if !self:IsValid() then return end
	if self:Health() < 0 then return end
	
	self:SetPoseParameter("move_x",self.WalkSpeedAnimation)	
	self.loco:SetDesiredSpeed( self.Speed )	
	self:StartActivity(self.WalkAnim)
	
	self.Flinching = false
	end)
		
end

ENT.nxtLegFlinch = 0
function ENT:LegFlinch()

	if !self.nxtLegFlinch then self.nxtLegFlinch = 0 end
    if CurTime() < self.nxtLegFlinch then return end

    self.nxtLegFlinch = CurTime() + 2

	if !self:IsValid() then return end
	if self:Health() < 0 then return end
	
	self:StartActivity( self.FlinchAnim )
	self:SetCycle(math.Rand(0.8, 0.8))

	self.loco:SetDesiredSpeed( 0 )	
	self.WalkSpeedAnimation = 0.9
	self:SetPoseParameter("move_x",self.WalkSpeedAnimation)
	self.BrokeLeg = true
	
	timer.Simple(0.4, function() 
	if !self:IsValid() then return end
	if self:Health() < 0 then return end
	
	self.Speed = self.Speed - 80
	self.loco:SetDesiredSpeed( self.Speed )		
		
	self.WalkAnim = self.WalkAnim2
	self:StartActivity( self.WalkAnim2 )
	
	self.WalkSpeedAnimation = 1
	self:SetPoseParameter("move_x",self.WalkSpeedAnimation)
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
			
		if hitgroup == HITGROUP_LEFTLEG or hitgroup == HITGROUP_RIGHTLEG then
			if attacker:IsNPC() then
			dmginfo:ScaleDamage(0.65)
			else
			dmginfo:ScaleDamage(0.55)
			end
			
			if dmginfo:GetDamage() > 14 then
			self:LegFlinch()
			end
			
		else
		
			if dmginfo:GetDamage() > 14 then
			self:Flinch()
			end
		
		end
	
		if hitgroup == HITGROUP_HEAD then
			if attacker:IsNPC() then
				if dmginfo:GetDamageType() == DMG_BUCKSHOT then
				dmginfo:ScaleDamage(6)
				else
				dmginfo:ScaleDamage(5)
				end
			else
				if dmginfo:GetDamageType() == DMG_BUCKSHOT then
				dmginfo:ScaleDamage(5)
				else
				dmginfo:ScaleDamage(4)
				end
			end
		else
			if attacker:IsNPC() then
			dmginfo:ScaleDamage(0.80)
			else
			dmginfo:ScaleDamage(0.70)
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
		sounds[4] = (self.Alert4)
		self:EmitSound( sounds[math.random(1,4)] )
end

function ENT:PainSound()
	if math.random(1,3) == 1 then
	local sounds = {}
		sounds[1] = (self.Pain1)
		sounds[2] = (self.Pain2)
		sounds[3] = (self.Pain3)
		sounds[4] = (self.Pain4)
		sounds[5] = (self.Pain5)
		sounds[6] = (self.Pain6)
		self:EmitSound( sounds[math.random(1,6)] )
	end
end

function ENT:DeathSound()
	local sounds = {}
		sounds[1] = (self.Death1)
		sounds[2] = (self.Death2)
		sounds[3] = (self.Death3)
		sounds[4] = (self.Death4)
		sounds[5] = (self.Death5)
		sounds[6] = (self.Death6)
		self:EmitSound( sounds[math.random(1,6)] )
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
		sounds[6] = (self.Idle6)
		sounds[7] = (self.Idle7)
		sounds[8] = (self.Idle8)
		self:EmitSound( sounds[math.random(1,8)] )
end

function ENT:CustomWander()
	self:StartActivity(ACT_IDLE)
end

function ENT:CustomDoorAttack( ent )	
			
	self:AttackSound()
	self:StartActivity(self.AttackAnim)
	self:SetPlaybackRate( 1.1 )
	self:SetPoseParameter("move_x",0)
	self.loco:SetDesiredSpeed(0)
	coroutine.wait(self.AttackWaitTime)
	
	if !self:CheckValid( ent ) then 
	self:EmitSound(self.Miss)
	self:StartActivity(self.WalkAnim)
	return end
	
	ent:EmitSound(self.DoorBreak)
end

function ENT:CustomPropAttack( ent )
	self:AttackSound()
	self:StartActivity(self.AttackAnim)  
	self:SetPlaybackRate( 1.1 )
	self:SetPoseParameter("move_x",0)
	coroutine.wait(self.AttackWaitTime)
		
	if !self:CheckValid( ent ) then 
	self:EmitSound(self.Miss)
	self:StartActivity(self.WalkAnim)
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
	self:SetPoseParameter("move_x",self.WalkSpeedAnimation)
end

ENT.nxtAttack = 0
function ENT:Attack()

	if !self.nxtAttack then self.nxtAttack = 0 end
    if CurTime() < self.nxtAttack then return end

    self.nxtAttack = CurTime() + 1.2
		
		if ( (self.Enemy:IsValid() and self.Enemy:Health() > 0 ) ) then
		
		if self.Flinching then return end
			
		self:AttackSound()
		self.Enemy = self.Enemy	
		self.IsAttacking = true
		
		self:StartActivity( self.AttackAnim )
		self:SetPlaybackRate( 1.1 )
		
		coroutine.wait(self.AttackWaitTime)
		
		if !self:IsValid() then return end
		if self:Health() < 0 then return end
		if !self:CheckValid( self.Enemy ) then return end
		
		if self.IsFlinching or self.IsReviving then return end
		
		if (self:GetRangeTo(self.Enemy) < (self.AttackRange)) then
			
			self:EmitSound(self.Hit)
			self.Enemy:TakeDamage(self.Damage, self)	
			
			if !self.Enemy:IsNPC() then
			self.Enemy:ViewPunch(Angle(math.random(-1, 1)*self.Damage, math.random(-1, 1)*self.Damage, math.random(-1, 1)*self.Damage))
			end
			
			self:BleedVisual( 0.2, self.Enemy:GetPos() + Vector(0,0,50) )	
			
		end	
		self:EmitSound(self.Miss)
		
		coroutine.wait(self.AttackFinishTime)
		self:StartActivity(self.WalkAnim)
		
		self.IsAttacking = false
		self:SetPoseParameter("move_x",self.WalkSpeedAnimation)
		end
end
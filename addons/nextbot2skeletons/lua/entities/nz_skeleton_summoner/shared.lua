AddCSLuaFile()

ENT.Base             = "nz_base"
ENT.Spawnable        = false
ENT.AdminSpawnable   = false

--SpawnMenu--
list.Set( "NPC", "nz_skeleton_summoner", {
	Name = "Summoner Skeleton",
	Class = "nz_skeleton_summoner",
	Category = "NextBot Zombies 2.0"
} )

--Stats--
ENT.Speed = 105
ENT.WalkSpeedAnimation = 0.7
ENT.FlinchSpeed = 0

ENT.health = 100
ENT.Damage = 25

ENT.PhysForce = 30000
ENT.AttackRange = 50
ENT.DoorAttackRange = 25

ENT.AttackWaitTime = 0.8
ENT.AttackFinishTime = 0.2

--Model Settings--
ENT.Model = "models/player/skeleton.mdl"

ENT.AttackAnim = (ACT_GMOD_GESTURE_RANGE_ZOMBIE)

ENT.WalkAnim = (ACT_HL2MP_RUN_MAGIC)
ENT.WalkAnim2 = (ACT_HL2MP_WALK_ZOMBIE_03)

ENT.FlinchAnim = (ACT_HL2MP_ZOMBIE_SLUMP_RISE)

ENT.AttackDoorAnim = (ACT_GMOD_GESTURE_RANGE_ZOMBIE)

--Sounds--
ENT.Attack1 = Sound("npc/zombie_poison/pz_throw2.wav")
ENT.Attack2 = Sound("npc/zombie_poison/pz_throw3.wav")

ENT.DoorBreak = Sound("npc/zombie/zombie_pound_door.wav")

ENT.Alert1 = Sound("npc/zombie/zombie_alert1.wav")
ENT.Alert2 = Sound("npc/zombie/zombie_alert2.wav")
ENT.Alert3 = Sound("npc/zombie/zombie_alert3.wav")

ENT.Death1 = Sound("npc/zombie/zombie_die1.wav")
ENT.Death2 = Sound("npc/zombie/zombie_die2.wav")
ENT.Death3 = Sound("npc/zombie/zombie_die3.wav")

ENT.Idle1 = Sound("npc/zombie_poison/pz_pain1.wav")
ENT.Idle2 = Sound("npc/zombie_poison/pz_pain2.wav")
ENT.Idle3 = Sound("npc/zombie_poison/pz_pain3.wav")

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
	self:SetColor( Color( math.random(0,255),math.random(0,255),math.random(0,255),255 ) ) 
	
	self.LoseTargetDist	= (self.LoseTargetDist)
	self.SearchRadius 	= (self.SearchRadius)
	
	self.IsAttacking = false
	self.HasNoEnemy = false
	self.Flinching = false
	
	self.loco:SetStepHeight(35)
	self.loco:SetAcceleration(300)
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
			
			local bleed = ents.Create("info_particle_system")
		bleed:SetKeyValue("effect_name", "blood_impact_red_01")
		bleed:SetPos(self:GetPos() + Vector(0,0,55)) 
		bleed:Spawn()
		bleed:Activate() 
		bleed:Fire("Start", "", 0)
		bleed:Fire("Kill", "", 0.2)
			
		else
		end
	
	end

	if dmginfo:IsExplosionDamage() then
		self:BecomeRagdoll(dmginfo)
	else
		local zombie = ents.Create("nz_deathanim_base")
			if !self:IsValid() then return end
			if zombie:IsValid() then 
			zombie:SetPos(self:GetPos())
			zombie:SetModel(self:GetModel())
			zombie:SetAngles(self:GetAngles())
			zombie:Spawn()
			
			if self.HasNoEnemy then
			zombie:StartActivity(ACT_HL2MP_WALK_ZOMBIE_06)
			else
			zombie:StartActivity( self.WalkAnim )
			end
			
			zombie:SetSkin(self:GetSkin())
			zombie:SetColor(self:GetColor())
			zombie:SetMaterial(self:GetMaterial())
			self:Remove()
			end
	end
	
end

ENT.nxtFlinch = 0
function ENT:Flinch()
	
	if !self.nxtFlinch then self.nxtFlinch = 0 end
    if CurTime() < self.nxtFlinch then return end

    self.nxtFlinch = CurTime() + 3.5
	
	if !self:CheckValid( self ) then return end
	
	self:StartActivity( self.FlinchAnim )
	self:SetCycle(math.Rand(0.7, 0.9))
		
	self.loco:SetDesiredSpeed( 0 )
	self:SetPoseParameter("move_x",0.4)	
	
	self.Flinching = true
	
	timer.Simple(0.7, function() 
	if !self:IsValid() then return end
	if self:Health() < 0 then return end
	
	self:SetPoseParameter("move_x",self.WalkSpeedAnimation)	
	self.loco:SetDesiredSpeed( self.Speed )	
	self:StartActivity(self.WalkAnim)
	
	self.Flinching = false
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
			
			if dmginfo:GetDamage() > 12 then
			self:Flinch()
			end
			
		end
		
	end

end

function ENT:FootSteps()
	self:EmitSound("npc/zombie/foot"..math.random(3)..".wav", 70)
end

function ENT:AlertSound()
	local alertsounds = {}
	alertsounds[1] = (self.Alert1)
	alertsounds[2] = (self.Alert2)
	alertsounds[3] = (self.Alert3)
	self:EmitSound( alertsounds[math.random(1,3)], math.random(80,85), math.random(70, 75) )
end

function ENT:PainSound()
	if math.random(1,3) == 1 then
	local painsounds = {}
	painsounds[1] = (self.Pain1)
	painsounds[2] = (self.Pain2)
	painsounds[3] = (self.Pain3)
	painsounds[4] = (self.Pain4)
	painsounds[5] = (self.Pain5)
	self:EmitSound( painsounds[math.random(1,5)], math.random(80,95), math.random(70, 85) )
	end
end

function ENT:DeathSound()
	local deathsounds = {}
	deathsounds[1] = (self.Death1)
	deathsounds[2] = (self.Death2)
	deathsounds[3] = (self.Death3)
	self:EmitSound( deathsounds[math.random(1,3)], math.random(80,95), math.random(70, 85) )
end

function ENT:AttackSound()
	local sounds = {}
	sounds[1] = (self.Attack1)
	sounds[2] = (self.Attack2)
	self:EmitSound( sounds[math.random(1,2)], math.random(75,80), math.random(70, 85) )
end

function ENT:IdleSound()
	local sounds = {}
	sounds[1] = (self.Idle1)
	sounds[2] = (self.Idle2)
	sounds[3] = (self.Idle3)
	self:EmitSound( sounds[math.random(1,3)], math.random(80,95), math.random(70, 85) )
end

function ENT:SpawnSkeletons()
	
	local infectednpc = ents.Create("nz_skeleton")
	if infectednpc then
	infectednpc:SetPos(self:GetPos() + Vector(5,20,0))
	infectednpc:Spawn()
	infectednpc:SetEnemy( self:GetEnemy() )
	infectednpc.Risen = true
	end
	
end

ENT.nxtCustomChaseEnemy = 0
function ENT:CustomChaseEnemy()

	if !self.nxtCustomChaseEnemy then self.nxtCustomChaseEnemy = 0 end
    if CurTime() < self.nxtCustomChaseEnemy then return end

    self.nxtCustomChaseEnemy = CurTime() + 10

	local enemy = self:GetEnemy()
	
		timer.Simple( 1 + math.random(1,3), function()
		if !self:IsValid() then return end
		if self:Health() < 0 then return end
		
			if self:GetRangeTo( enemy ) > 200 and self:GetRangeTo( enemy ) < 800 then
			self:SpawnSkeletons()
			self:RestartGesture( ACT_GMOD_GESTURE_ITEM_THROW ) 
			end
			
		end)
	
end

function ENT:CustomWander()
	self:StartActivity(ACT_HL2MP_WALK_ZOMBIE_06)
	self:IdleSounds()
end

function ENT:CustomPropAttack( ent )
	local attack = math.random(1,2)
	if attack == 1 then
	self:Leap()
	elseif attack == 2 then
	self:AttackSound()
	self:RestartGesture(self.AttackAnim)  
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
	self:SetPoseParameter( "move_x", self.WalkSpeedAnimation)
	end
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
		self:RestartGesture(self.AttackAnim)
		
		timer.Simple(0.9, function() 
		if !self:IsValid() then return end
		if self:Health() < 0 then return end
		if !self:CheckValid( self.Enemy ) then return end
		
		if self.Flinching then return end
		
		if (self:GetRangeTo(self.Enemy) < (self.AttackRange)) then
			
			self.Enemy:EmitSound(self.Hit, 95, 135)
			self.Enemy:TakeDamage(self.Damage, self)	
			
			if !self.Enemy:IsNPC() then
			self.Enemy:ViewPunch(Angle(math.random(-1, 1)*self.Damage, math.random(-1, 1)*self.Damage, math.random(-1, 1)*self.Damage))
			end
			
			local bleed = ents.Create("info_particle_system")
		bleed:SetKeyValue("effect_name", "blood_impact_red_01")
		bleed:SetPos(self.Enemy:GetPos() + Vector(0,0,50)) 
		bleed:Spawn()
		bleed:Activate() 
		bleed:Fire("Start", "", 0)
		bleed:Fire("Kill", "", 0.2)
			
		end	
		self:EmitSound(self.Miss, 95, 115)
		end)
		
		self.IsAttacking = false
		self:SetPoseParameter( "move_x", self.WalkSpeedAnimation )
		end
end
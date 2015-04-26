AddCSLuaFile()

ENT.Base             = "nz_base"
ENT.Spawnable        = false
ENT.AdminSpawnable   = false

--SpawnMenu--
list.Set( "NPC", "nz_seekers", {
	Name = "Seekers",
	Class = "nz_seekers",
	Category = "NextBot Zombies 2.0"
} )

--Stats--
ENT.SearchRadius = 3000
ENT.LoseTargetDist = 5000

ENT.Speed = 145
ENT.WalkSpeedAnimation = 0.8
ENT.FlinchSpeed = 0

ENT.health = 100
ENT.Damage = 15

ENT.PhysForce = 15000
ENT.AttackRange = 50
ENT.DoorAttackRange = 25

ENT.NextAttack = 1.3

--Model Settings--
ENT.Model1 = "models/zombie/seeker_01.mdl"
ENT.Model2 = "models/zombie/seeker_02.mdl"
ENT.Model3 = "models/zombie/seeker_03.mdl"

ENT.AttackAnim = (ACT_GMOD_GESTURE_RANGE_ZOMBIE)

ENT.WalkAnim = (ACT_HL2MP_RUN_ZOMBIE)
ENT.WalkAnim2 = (ACT_HL2MP_WALK_ZOMBIE_03)

ENT.FlinchAnim = (ACT_HL2MP_ZOMBIE_SLUMP_RISE)

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

function ENT:Initialize()

	--Stats--
	self.Anims = { ACT_HL2MP_RUN_ZOMBIE, ACT_HL2MP_RUN_FAST, ACT_HL2MP_RUN_FIST, ACT_HL2MP_RUN_CHARGING, ACT_HL2MP_RUN_KNIFE }
	
    local model = math.random(1,3)
	if model == 1 then
	self:SetModel(self.Model1)
	self.WalkAnim = (table.Random(self.Anims))
	elseif model == 2 then
	self:SetModel(self.Model2)
	self.WalkAnim = (table.Random(self.Anims))
	elseif model == 3 then
	self:SetModel(self.Model3)
	self.WalkAnim = (table.Random(self.Anims))
	end
	
	self:SetHealth(self.health)	
	
	self.LoseTargetDist	= (self.LoseTargetDist)
	self.SearchRadius 	= (self.SearchRadius)
	
	self.IsAttacking = false
	self.HasNoEnemy = false
	self.BrokeLeg = false
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

    self.nxtFlinch = CurTime() + 3.5
	
	if !self:CheckValid( self ) then return end
	
	self:StartActivity( self.FlinchAnim )
	self:SetCycle(math.Rand(0.7, 0.9))
		
	self.loco:SetDesiredSpeed( 0 )
	self:SetPoseParameter("move_x",0.4)	
	
	self.Flinching = true
	
	timer.Simple(0.8, function() 
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

    self.nxtLegFlinch = CurTime() + 1.5

	if !self:IsValid() then return end
	if self:Health() < 0 then return end
	
	self:StartActivity( self.FlinchAnim )
	self:SetCycle(math.Rand(0.7, 0.8))

	self.loco:SetDesiredSpeed( 0 )	
	self.WalkSpeedAnimation = 0.9
	self:SetPoseParameter("move_x",self.WalkSpeedAnimation)
	self.BrokeLeg = true
	
	timer.Simple(0.8, function() 
	if !self:IsValid() then return end
	if self:Health() < 0 then return end
	
	self.Speed = self.Speed - 100
	self.loco:SetDesiredSpeed( self.Speed )		
		
	self.WalkAnim = self.WalkAnim2
	self:StartActivity( self.WalkAnim2 )
	
	self.WalkSpeedAnimation = 0.9
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
			dmginfo:ScaleDamage(0.75)
			else
			dmginfo:ScaleDamage(0.65)
			end
			
			if dmginfo:GetDamage() > 12 then
			self:LegFlinch()
			end
			
		else
		
			if dmginfo:GetDamage() > 12 then
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
			dmginfo:ScaleDamage(0.90)
			else
			dmginfo:ScaleDamage(0.80)
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
	alertsounds[4] = (self.Alert4)
	self:EmitSound( alertsounds[math.random(1,4)], math.random(80,95), math.random(70, 105) )
end

function ENT:PainSound()
	if math.random(1,3) == 1 then
	local painsounds = {}
	painsounds[1] = (self.Pain1)
	painsounds[2] = (self.Pain2)
	painsounds[3] = (self.Pain3)
	painsounds[4] = (self.Pain4)
	self:EmitSound( painsounds[math.random(1,4)], math.random(80,95), math.random(70, 105) )
	end
end

function ENT:DeathSound()
	local deathsounds = {}
	deathsounds[1] = (self.Death1)
	deathsounds[2] = (self.Death2)
	deathsounds[3] = (self.Death3)
	deathsounds[4] = (self.Death4)
	self:EmitSound( deathsounds[math.random(1,4)], math.random(80,95), math.random(70, 105) )
end

function ENT:AttackSound()
	local sounds = {}
	sounds[1] = (self.Attack1)
	sounds[2] = (self.Attack2)
	sounds[3] = (self.Attack3)
	sounds[4] = (self.Attack4)
	self:EmitSound( sounds[math.random(1,4)], math.random(80,95), math.random(70, 105) )
end

function ENT:IdleSound()
	if math.random(1,6) == 1 then
	local sounds = {}
	sounds[1] = (self.Idle1)
	sounds[2] = (self.Idle2)
	sounds[3] = (self.Idle3)
	sounds[4] = (self.Idle4)
	self:EmitSound( sounds[math.random(1,4)] )
	end
end

ENT.nxtAlertZombies = 0
function ENT:AlertZombies()

	if !self.nxtAlertZombies then self.nxtAlertZombies = 0 end
    if CurTime() < self.nxtAlertZombies then return end

    self.nxtAlertZombies = CurTime() + 10

	self:RestartGesture( ACT_GMOD_GESTURE_TAUNT_ZOMBIE )
	self:AlertSound()
			
	local enemy = self:GetEnemy()		
	local ents = ents.FindInSphere( self:GetPos(), 250 )
		for _,v in pairs(ents) do
			if self:GetRangeTo( enemy ) < 250 then
				if v:GetClass("nazi_zombie_*", "nz_*", "npc_nextbot_*", "mob_zombie_*") then
					if v.HasNoEnemy then
					v:SetEnemy( enemy )
					end
				end
			end
		end
end

function ENT:RunBehaviour()
	while ( true ) do
	
		if ( self:HaveEnemy() ) then
		self.HasNoEnemy = false
		
			self:AlertZombies()
			
			self:StartActivity( self.WalkAnim  )
			self:SetPoseParameter("move_x",self.WalkSpeedAnimation)
			self.loco:SetDesiredSpeed(self.Speed)
			
			self:ChaseEnemy() 
			
		else
		self.HasNoEnemy = true
		
			self:StartActivity( self.WalkAnim  )
			self:SetPoseParameter("move_x",self.WalkSpeedAnimation)	
			self.loco:SetDesiredSpeed( self.Speed )
			
			self:IdleSound()
			self:MoveToPos(self:GetPos() + Vector(math.random(-256, 256), math.random(-256, 256), 0), {
			repath = 3,
			maxage = 2
			})
			
		end
	end
	coroutine.yield()
end	

ENT.nxtAttack3 = 0
function ENT:CustomDoorAttack( ent )

	if !self.nxtAttack3 then self.nxtAttack3 = 0 end
    if CurTime() < self.nxtAttack3 then return end

    self.nxtAttack3 = CurTime() + self.NextAttack

	self:AttackSound()
	self:RestartGesture(self.AttackAnim)  
	
	self:AttackEffect( 0.9, ent, self.Damage, 2 )
	
end

ENT.nxtAttack2 = 0
function ENT:CustomPropAttack( ent )

	if !self.nxtAttack2 then self.nxtAttack2 = 0 end
    if CurTime() < self.nxtAttack2 then return end

    self.nxtAttack2 = CurTime() + self.NextAttack

	self:AttackSound()
	self:RestartGesture(self.AttackAnim)  
	
	self:AttackEffect( 0.9, ent, self.Damage, 1 )
	
end

function ENT:AttackEffect( time, ent, dmg, type )

	timer.Simple(time, function() 
		if !self:IsValid() then return end
		if self:Health() < 0 then return end
		if !self:CheckValid( ent ) then return end
		if self.Flinching then return end
		
		if self:GetRangeTo( ent ) < self.AttackRange then
			
			ent:TakeDamage(dmg, self)	
			
			if ent:IsPlayer() or ent:IsNPC() then
				self:BleedVisual( 0.2, ent:GetPos() + Vector(0,0,50) )	
				self:EmitSound("npc/infected_zombies/hit_punch_0"..math.random(8)..".wav", math.random(100,125), math.random(85,105))
			end
			
			if ent:IsPlayer() then
				ent:ViewPunch(Angle(math.random(-1, 1)*self.Damage, math.random(-1, 1)*self.Damage, math.random(-1, 1)*self.Damage))
			end
			
			if type == 1 then
				local phys = ent:GetPhysicsObject()
				if (phys != nil && phys != NULL && phys:IsValid() ) then
					phys:ApplyForceCenter(self:GetForward():GetNormalized()*(self.PhysForce) + Vector(0, 0, 2))
					ent:EmitSound(self.DoorBreak)
				end
			elseif type == 2 then
				if ent != NULL and ent.Hitsleft != nil then
					if ent.Hitsleft > 0 then
						ent.Hitsleft = ent.Hitsleft - self.HitPerDoor	
						ent:EmitSound(self.DoorBreak)
					end
				end
			end
							
		else	
		self:EmitSound("npc/infected_zombies/claw_miss_"..math.random(2)..".wav", math.random(75,95), math.random(65,95))
		end
		
	end)
	
	timer.Simple( time + 0.6, function()
		if !self:IsValid() then return end
		if self:Health() < 0 then return end
		self.IsAttacking = false
	end)

end

ENT.nxtAttack = 0
function ENT:Attack()

	if !self.nxtAttack then self.nxtAttack = 0 end
    if CurTime() < self.nxtAttack then return end

    self.nxtAttack = CurTime() + self.NextAttack
		
		if ( (self.Enemy:IsValid() and self.Enemy:Health() > 0 ) ) then
		if self.Flinching then return end
		
		self:AttackSound()
		self.IsAttacking = true
		self:RestartGesture(self.AttackAnim)
		
		self:AttackEffect( 0.9, self.Enemy, self.Damage, 0 )
		
		end
end
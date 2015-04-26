AddCSLuaFile()

ENT.Base             = "nz_base"
ENT.Spawnable        = false
ENT.AdminSpawnable   = false

--SpawnMenu--
list.Set( "NPC", "nz_infested", {
	Name = "Infested",
	Class = "nz_infested",
	Category = "NextBot Zombies 2.0"
} )

--Stats--
ENT.Speed = 80
ENT.WalkSpeedAnimation = 0.6
ENT.FlinchSpeed = 30

ENT.health = 135
ENT.Damage = 25

ENT.PhysForce = 15000
ENT.AttackRange = 60
ENT.DoorAttackRange = 25

ENT.NextAttack = 1.5

--Model Settings--
ENT.Model = "models/player/zombie_classic.mdl"

ENT.AttackAnim = (ACT_GMOD_GESTURE_RANGE_ZOMBIE)

ENT.WalkAnim = (ACT_HL2MP_RUN_ZOMBIE)
ENT.WalkAnim2 = (ACT_HL2MP_WALK_ZOMBIE_03)

ENT.FlinchAnim = (ACT_HL2MP_ZOMBIE_SLUMP_RISE)

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
	self.IsSlowed = false
	self.BrokeLeg = false
	self.Revive = false
	
	self.loco:SetStepHeight(35)
	self.loco:SetAcceleration(200)
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
			self:BecomeRagdoll( dmginfo )	
		elseif hitgroup == HITGROUP_STOMACH or hitgroup == HITGROUP_GEAR or hitgroup == HITGROUP_CHEST then
			if dmginfo:GetDamage() > 10 or dmginfo:GetDamageType() == DMG_BUCKSHOT then
				self:Split( dmginfo )
				SafeRemoveEntity( self )
			end
		end
		
		
	else
		self:BecomeRagdoll( dmginfo )
	end
	
	
end

function ENT:Split( dmginfo )
	if !self:IsValid() then return end
	self.Revive = true
	
	local ragdoll2 = ents.Create("prop_ragdoll") -- create the legs
		ragdoll2:SetPos(self:GetPos())
		ragdoll2:SetAngles(self:GetAngles())	
		ragdoll2:SetModel("models/zombie/classic_legs.mdl")
		ragdoll2:SetVelocity(self:GetVelocity())
		ragdoll2:Spawn()
		ragdoll2:Activate()
		self.Ragdoll = ragdoll2	
		
		timer.Simple(0.6, function() 
		if !ragdoll2 then return end
		ragdoll2:SetCollisionGroup( COLLISION_GROUP_DEBRIS ) 
		end)
	
	local zombie = ents.Create("nz_infested_torso") -- spawn the torso
		zombie:SetPos(self:GetPos() + Vector(0,0,30))
		self:SetAngles(self:GetAngles())	
		zombie:Spawn()
		zombie:SetEnemy( self:GetEnemy() )
		
		self.Revive = false
	
end

ENT.nxtLegSlow = 0
function ENT:LegSlow()
	
	if !self.nxtLegSlow then self.nxtLegSlow = 0 end
    if CurTime() < self.nxtLegSlow then return end

    self.nxtLegSlow = CurTime() + 2
	
	if !self:IsValid() then return end
	if self:Health() < 0 then return end
	
		
	self:StartActivity( self.WalkAnim2 )
	self.loco:SetDesiredSpeed( self.FlinchSpeed )
	self.IsSlowed = true
	
	timer.Simple(1.2, function() 
	if !self:IsValid() then return end
	if self:Health() < 0 then return end
	
	self.loco:SetDesiredSpeed( self.Speed )	
	self:StartActivity( self.WalkAnim )
	
	self.IsSlowed = false
	end)
		
end

--ENT.nxtLegFlinch = 0
--function ENT:LegFlinch()

	--if !self.nxtLegFlinch then self.nxtLegFlinch = 0 end
    --if CurTime() < self.nxtLegFlinch then return end

   -- self.nxtLegFlinch = CurTime() + 1.5

	--if !self:IsValid() then return end
	--if self:Health() < 0 then return end
		
	--self:StartActivity( self.FlinchAnim )
	--self:SetCycle(math.Rand(0.7, 0.8))
	--self:PainSound()
	--self.loco:SetDesiredSpeed( 0 )	
	--self.WalkSpeedAnimation = 0.9
	--self:SetPoseParameter("move_x",self.WalkSpeedAnimation)
	--self.BrokeLeg = true
	
	--timer.Simple(0.6, function() 
	--if !self:IsValid() then return end
	--if self:Health() < 0 then return end
	--self.loco:SetDesiredSpeed( self.Speed - 35 )		
		
	--self.WalkAnim = self.WalkAnim2
	--self:StartActivity( self.WalkAnim2 )
	
	--self.WalkSpeedAnimation = 0.9
	--self:SetPoseParameter("move_x",self.WalkSpeedAnimation)
	--end)
		
--end

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
				if dmginfo:GetDamageType() == DMG_BUCKSHOT then
				dmginfo:ScaleDamage(0.75)
				else
				dmginfo:ScaleDamage(0.65)
				end
			else
				if dmginfo:GetDamageType() == DMG_BUCKSHOT then
				dmginfo:ScaleDamage(0.55)
				else
				dmginfo:ScaleDamage(0.45)
				end
			dmginfo:ScaleDamage(0.45)
			end
			
			if dmginfo:GetDamage() > 4 then
			self:LegSlow()
			end
			
		end
			
	
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
	if self.Revive then return end
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
		
		if self:GetRangeTo( ent ) < self.AttackRange then
			
			ent:TakeDamage( self.Damage, self )
			
			if ent:IsPlayer() or ent:IsNPC() then
				self:BleedVisual( 0.2, ent:GetPos() + Vector(0,0,50) )	
				self:EmitSound(self.Hit)
				self:Bleed( ent )
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
		self:EmitSound(self.Miss)
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
		
		self:AttackSound()
		self.IsAttacking = true
		self:RestartGesture(self.AttackAnim)
		
		self:AttackEffect( 0.9, self.Enemy, self.Damage, 0 )
		
		end
end
AddCSLuaFile()

ENT.Base             = "nz_base"
ENT.Spawnable        = false
ENT.AdminSpawnable   = false

--SpawnMenu--
list.Set( "NPC", "nz_zombine", {
	Name = "Zombine",
	Class = "nz_zombine",
	Category = "NextBot Zombies 2.0"
} )

--Stats--
ENT.Speed = 65
ENT.WalkSpeedAnimation = 0.6
ENT.FlinchSpeed = 10

ENT.health = 550
ENT.Damage = 25

ENT.PhysForce = 15000
ENT.AttackRange = 48
ENT.DoorAttackRange = 25

ENT.NextAttack = 1.3

--Model Settings--
ENT.Model = "models/zombie/zombineplayer.mdl"

ENT.AttackAnim = (ACT_GMOD_GESTURE_RANGE_ZOMBIE)

ENT.WalkAnim = (ACT_HL2MP_RUN_ZOMBIE)
ENT.WalkAnim2 = "walk_all"

ENT.FlinchAnim = (ACT_FLINCH_PHYSICS)

ENT.AttackDoorAnim = (ACT_GMOD_GESTURE_RANGE_ZOMBIE)

--Sounds--
ENT.Attack1 = Sound("npc/zombine/attack1.wav")
ENT.Attack2 = Sound("npc/zombine/attack2.wav")

ENT.DoorBreak = Sound("npc/zombie/zombie_pound_door.wav")

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
	
	self.LoseTargetDist	= (self.LoseTargetDist)
	self.SearchRadius 	= (self.SearchRadius)
	
	local anim = math.random(1,2)
	if anim == 1 then
	self.WalkAnim = "walk_all"
	elseif anim == 2 then
	self.WalkAnim = (ACT_HL2MP_RUN_ZOMBIE)
	end
	
	self.IsAttacking = false
	self.HasNoEnemy = false
	self.Flinching = false
	
	self.loco:SetStepHeight(35)
	self.loco:SetAcceleration(200)
	self.loco:SetDeceleration(900)
	
	--Misc--
	self:SetCollisionGroup(COLLISION_GROUP_DEBRIS)
	self:Precache()
	self:CreateBullseye()
	
end

function ENT:SwitchAnims()
	if self.WalkAnim == "walk_all" then
		self:ResetSequence( self.WalkAnim )
	elseif self.WalkAnim == (ACT_HL2MP_RUN_ZOMBIE) then
		self:StartActivity( self.WalkAnim )
	end
end

function ENT:ZombineStart()
	self:SwitchAnims()
end

function ENT:ZombineEnd()
	self:SwitchAnims()
end

function ENT:CustomDeath( dmginfo )

	if dmginfo:IsExplosionDamage() then
		self:BecomeRagdoll(dmginfo)
	else
		self:DeathAnimation( "nz_deathanim_base", self:GetPos(), self.WalkAnim, 1 )
	end

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
	
		self:EmitSound("kevlar/kevlar_hit"..math.random(2)..".wav", 70, math.random(70,85) )
		
		if attacker:IsNPC() then
			dmginfo:ScaleDamage(0.75)
		else
			dmginfo:ScaleDamage(0.65)
		end
		
		if dmginfo:GetDamage() > 20 then
			self:Flinch()
		end
		
	end

end

ENT.nxtFlinch = 0
function ENT:Flinch()
	
	if !self.nxtFlinch then self.nxtFlinch = 0 end
    if CurTime() < self.nxtFlinch then return end

    self.nxtFlinch = CurTime() + 3.5
	
	if !self:CheckValid( self ) then return end
	
	self:RestartGesture( self.FlinchAnim )
	self.loco:SetDesiredSpeed( self.FlinchSpeed )
	self:SetPoseParameter("move_x",0.4)	
	
	self.Flinching = true
	
	timer.Simple(0.7, function() 
	if !self:IsValid() then return end
	if self:Health() < 0 then return end
	
	self:SetPoseParameter("move_x",self.WalkSpeedAnimation)	
	self.loco:SetDesiredSpeed( self.Speed )	
	self:SwitchAnims()
	
	self.Flinching = false
	end)
		
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
			
			self:SwitchAnims()
			
			self:SetPoseParameter("move_x",self.WalkSpeedAnimation)	
			self.loco:SetDesiredSpeed( self.Speed )
		
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
		if self.IsFlinching then return end
		
		if self:GetRangeTo( ent ) < self.AttackRange then
			
			ent:TakeDamage(dmg, self)	
			
			if ent:IsPlayer() or ent:IsNPC() then
				self:BleedVisual( 0.2, ent:GetPos() + Vector(0,0,50) )	
				self:EmitSound(self.Hit)
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
		if self.Flinching then return end
		
		self:AttackSound()
		self.IsAttacking = true
		self:RestartGesture(self.AttackAnim)
		
		self:AttackEffect( 0.9, self.Enemy, self.Damage, 0 )
		
		end
end
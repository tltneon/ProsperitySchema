AddCSLuaFile()

ENT.Base             = "base_nextbot"
ENT.Spawnable        = false
ENT.AdminSpawnable   = false


--Stats--
ENT.Speed = 75
ENT.FlinchSpeed = 0

ENT.health = 2700
ENT.Damage = 20

ENT.AttackWaitTime = 1
ENT.AttackFinishTime = 1

ENT.FallDamage = 0


--Model Settings--
ENT.Model = "models/zombie/poison.mdl"

ENT.AttackAnim = (ACT_RANGE_ATTACK1)
ENT.WalkAnim = (ACT_WALK)
ENT.IdleAnim = (ACT_IDLE)

ENT.FlinchAnim = (none)
ENT.FallAnim = (ACT_IDLE_ON_FIRE)

ENT.AttackDoorAnim = (ACT_RANGE_ATTACK2)

--Sounds--
ENT.Attack1 = Sound("npc/zombie_poison/pz_warn1.wav")
ENT.Attack2 = Sound("npc/zombie_poison/pz_warn2.wav")

ENT.Death1 = Sound("npc/zombie_poison/pz_die1.wav")
ENT.Death2 = Sound("npc/zombie_poison/pz_die2.wav")
ENT.Death3 = Sound("none")

ENT.Alert1 = Sound("npc/zombie_poison/pz_alert1.wav")
ENT.Alert2 = Sound("npc/zombie_poison/pz_alert2.wav")
ENT.Alert3 = Sound("none")

ENT.Flinch1 = Sound("npc/zombie_poison/pz_alert1.wav")
ENT.Flinch2 = Sound("npc/zombie_poison/pz_alert2.wav")
ENT.Flinch3 = Sound("none")

ENT.Fall1 = Sound("npc/zombie_poison/pz_throw2.wav")
ENT.Fall2 = Sound("npc/zombie_poison/pz_throw3.wav")

ENT.Idle1 = Sound("npc/zombie_poison/pz_idle2.wav")
ENT.Idle2 = Sound("npc/zombie_poison/pz_idle3.wav")
ENT.Idle3 = Sound("npc/zombie_poison/pz_idle4.wav")
ENT.Idle4 = Sound("none")
ENT.Idle5 = Sound("none")
ENT.Idle6 = Sound("none")
ENT.Idle7 = Sound("none")
ENT.Idle8 = Sound("none")
ENT.Idle9 = Sound("none")

ENT.Pain1 = Sound("npc/zombie_poison/pz_pain1.wav")
ENT.Pain2 = Sound("npc/zombie_poison/pz_pain2.wav")
ENT.Pain3 = Sound("npc/zombie_poison/pz_pain3.wav")
ENT.Pain4 = Sound("none")
ENT.Pain5 = Sound("none")
ENT.Pain6 = Sound("none")

ENT.Hit = Sound("npc/zombie/claw_strike1.wav")
ENT.Miss = Sound("npc/zombie/claw_miss1.wav")
ENT.DoorBreak = Sound("npc/zombie/zombie_pound_door.wav")

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
	if GetConVarNumber("pukepus_collide") == 0 then
	self:SetCollisionGroup(COLLISION_GROUP_DEBRIS)
	end
	
    self:SetModel(self.Model)
	self:SetHealth(GetConVarNumber("pukepus_health"))
	self:SetModelScale( 2, 0 )
	self:SetMaterial("Models/Barnacle/barnacle_sheet")
	
	self.LoseTargetDist	= GetConVarNumber("pukepus_distcheck")	-- How far the enemy has to be before we lose them
	self.SearchRadius 	= GetConVarNumber("pukepus_dist")	-- How far to search for enemies

	self.IsAttacking = false
	self.HasNoEnemy = false
	
	local bones = {
	"ValveBiped.Bip01_L_UpperArm",
	"ValveBiped.Bip01_L_Forearm",
	"ValveBiped.Bip01_L_Hand",
	"ValveBiped.Bip01_L_Finger1",
	"ValveBiped.Bip01_L_Finger11",
	"ValveBiped.Bip01_L_Finger12",
	"ValveBiped.Bip01_L_Finger2",
	"ValveBiped.Bip01_L_Finger21",
	"ValveBiped.Bip01_L_Finger22",
	"ValveBiped.Bip01_L_Finger3",
	"ValveBiped.Bip01_L_Finger31",
	"ValveBiped.Bip01_L_Finger32",
	"ValveBiped.Bip01_R_UpperArm",
	"ValveBiped.Bip01_R_Forearm",
	"ValveBiped.Bip01_R_Hand",
	"ValveBiped.Bip01_R_Finger1",
	"ValveBiped.Bip01_R_Finger11",
	"ValveBiped.Bip01_R_Finger12",
	"ValveBiped.Bip01_R_Finger2",
	"ValveBiped.Bip01_R_Finger21",
	"ValveBiped.Bip01_R_Finger22",
	"ValveBiped.Bip01_R_Finger3",
	"ValveBiped.Bip01_R_Finger31",
	"ValveBiped.Bip01_R_Finger32"
}

	for _, bone in pairs(bones) do
		local boneid = self:LookupBone(bone)
		if boneid and boneid > 0 then
			self:ManipulateBoneScale(boneid, Vector(0.1,0.1,0.1))
		end
	end
	
	--Misc--
	self:Precache()
	self.loco:SetStepHeight(35)	
	self.loco:SetAcceleration(900)
	self.loco:SetDeceleration(900)
	self.LastPos = self:GetPos()
	self.nextbot = true
end

function ENT:BehaveAct()
end

function ENT:Think()
if !IsValid(self) then return end

	if self.IsAttacking then
		if (GetConVarNumber("nb_stop") == 0) then
		self.loco:FaceTowards( self.Enemy:GetPos() )
		end
	end

	self.LastPos = self.Entity:GetPos() 

    if !self.nxtThink then self.nxtThink = 0 end
    if CurTime() < self.nxtThink then return end

    self.nxtThink = CurTime() + 0.025

	-- First Step
        local bones = self:LookupBone("ValveBiped.Bip01_R_Foot")
		
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
		local bones2 = self:LookupBone("ValveBiped.Bip01_L_Foot")
		
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
	local entstoattack = ents.FindInSphere(self:GetPos(), 25)
	for _,v in pairs(entstoattack) do
	
		if (v:GetClass() == "prop_physics") then
		
		self:EmitSound("npc/barnacle/barnacle_die2.wav")
		self:EmitSound("npc/barnacle/barnacle_digesting1.wav")
		self:EmitSound("npc/barnacle/barnacle_digesting2.wav")

		coroutine.wait(0.3)	
		
		for i=1,GetConVarNumber("pukepus_fleshperattack") do
		flesh = ents.Create("poison_flesh") 
		if flesh:IsValid() then
		flesh:SetPos(self:EyePos() + Vector(0,0,50))
		flesh:SetOwner(self)
		flesh:Spawn()
	
		local phys = flesh:GetPhysicsObject()
			if phys:IsValid() then
				local ang = self:EyeAngles()
				ang:RotateAroundAxis(ang:Forward(), math.Rand(-30, 30))
				ang:RotateAroundAxis(ang:Up(), math.Rand(-30, 30))
				phys:SetVelocityInstantaneous(ang:Forward() * math.Rand(25, 90))
		end
		end
		end
			return true
		end
	end
	return false
end

function ENT:AttackBreakable()
	local entstoattack = ents.FindInSphere(self:GetPos(), 25)
	for _,v in pairs(entstoattack) do
	
		if (v:GetClass() == "func_breakable") then

	self:EmitSound("npc/barnacle/barnacle_die2.wav")
		self:EmitSound("npc/barnacle/barnacle_digesting1.wav")
		self:EmitSound("npc/barnacle/barnacle_digesting2.wav")

		coroutine.wait(0.3)	

		
		for i=1,GetConVarNumber("pukepus_fleshperattack") do
		flesh = ents.Create("poison_flesh") 
		if flesh:IsValid() then
		flesh:SetPos(self:EyePos() + Vector(0,0,50))
		flesh:SetOwner(self)
		flesh:Spawn()
	
		local phys = flesh:GetPhysicsObject()
			if phys:IsValid() then
				local ang = self:EyeAngles()
				ang:RotateAroundAxis(ang:Forward(), math.Rand(-30, 30))
				ang:RotateAroundAxis(ang:Up(), math.Rand(-30, 30))
				phys:SetVelocityInstantaneous(ang:Forward() * math.Rand(25, 90))
		end
		end
		end
			return true
		end
	end
	return false
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
	self:EmitSound("npc/barnacle/barnacle_digesting2.wav")
end
end

function ENT:AlertSound()
self:EmitSound("npc/barnacle/barnacle_die2.wav")
end

function ENT:RunBehaviour()
	while ( true ) do
		if ( self:HaveEnemy() ) then
		self.HasNoEnemy = false
			self:AlertSound()
			self:ResetSequence("firewalk")
			self.loco:SetDesiredSpeed(GetConVarNumber("pukepus_speed"))
			self:ChaseEnemy() 
		else
			-- Wander around
		self.HasNoEnemy = true
			self:ResetSequence("firewalk")
			self.loco:SetDesiredSpeed(GetConVarNumber("pukepus_speed"))
			self:IdleSounds()
			self:MoveToPos( self:GetPos() + Vector( math.Rand( -1, 1 ), math.Rand( -1, 1 ), 0 ) * 400 )
			self:StartActivity(ACT_IDLE)
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
	self:EmitSound("npc/barnacle/barnacle_digesting2.wav")
	end
	end
	
	local door = ents.FindInSphere(self:GetPos(),50)
		if door then
			for i = 1, #door do
				local v = door[i]
				if !v:IsPlayer() and v != self and IsValid( v ) then
					if self:GetDoor( v ) == "door" then
					
						if v.Hitsleft == nil then
							v.Hitsleft = 10
						end
						
						if v != NULL and v.Hitsleft > 0 then
							if (self:GetRangeTo(v) < 55) then
							
							function BreakSounds()
							if not ( v:IsValid() ) then return end
							v:EmitSound(self.DoorBreak)
							end
				
								self:StartActivity(self.WalkAnim)
								
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
						door:EmitSound("Wood_Plank.Break")
						
						local phys = door:GetPhysicsObject()
						if (phys != nil && phys != NULL && phys:IsValid()) then
						phys:ApplyForceCenter(self:GetForward():GetNormalized()*80000 + Vector(0, 0, 2))
						end
						
						door:SetSkin(v:GetSkin())
						door:SetColor(v:GetColor())
						door:SetMaterial(v:GetMaterial())
					end
						self:ResetSequence("firewalk")
						self.loco:SetDesiredSpeed(GetConVarNumber("pukepus_speed"))
						end
						end
						end
						end
						
		
	local ent = ents.FindInSphere( self:GetPos(), 90) 
		for k,v in pairs( ent ) do
		
		if ( v:IsPlayer() && v:Alive() ) then
		if not ( v:IsValid() && v:Health() > 0 ) then return end
		
	if SERVER then
			
		self:EmitSound("npc/barnacle/barnacle_die2.wav")
		self:EmitSound("npc/barnacle/barnacle_digesting1.wav")
		self:EmitSound("npc/barnacle/barnacle_digesting2.wav")

		self.Enemy = v
		self.IsAttacking = true
		coroutine.wait(0.2)	

		
		
		for i=1,GetConVarNumber("pukepus_fleshperattack") do
		flesh = ents.Create("poison_flesh") 
		if flesh:IsValid() then
		flesh:SetPos(self:EyePos() + Vector(0,0,50))
		flesh:SetOwner(self)
		flesh:Spawn()
	
		local phys = flesh:GetPhysicsObject()
			if phys:IsValid() then
				local ang = self:EyeAngles()
				ang:RotateAroundAxis(ang:Forward(), math.Rand(-100, 100))
				ang:RotateAroundAxis(ang:Up(), math.Rand(-100, 100))
				phys:SetVelocityInstantaneous(ang:Forward() * math.Rand(200, 200))
		end
		end
		end		
		self.IsAttacking = false
		end
		end
		end

		if (self:GetRangeTo(self.Enemy) < 50 or self:AttackProp()) then
			else
			if (self:GetRangeTo(self.Enemy) < 50 or self:AttackBreakable()) then
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
end

function ENT:OnKilled( dmginfo )
	self:BecomeRagdoll( dmginfo )
	self:EmitSound("npc/zombie_poison/pz_call1.wav")
end

function ENT:OnInjured( dmginfo )

	if self.HasNoEnemy and dmginfo:GetAttacker():IsPlayer() then
		if self:IsValid() and self:Health() > 0 then
	local attacker = dmginfo:GetAttacker()
	self.SearchRadius 	= self:GetRangeTo(attacker) + 1000
	self.Enemy = attacker
	end -- If we don't have an enemy and we get injured by a player then we chase the player
		end

	if !dmginfo:GetAttacker():IsPlayer() and dmginfo:IsExplosionDamage() then
	dmginfo:ScaleDamage(0)
	end

	if dmginfo:IsExplosionDamage() then
	dmginfo:ScaleDamage(10)
	else
	dmginfo:ScaleDamage(0.7)
	end
	
	if math.random( 1,5) == 1 then
	local painsounds = {}
	painsounds[1] = (self.Pain1)
	painsounds[2] = (self.Pain2)
	self:EmitSound( painsounds[math.random(1,2)] )
	end
end
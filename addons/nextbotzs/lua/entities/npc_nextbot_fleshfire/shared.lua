AddCSLuaFile()

ENT.Base             = "base_nextbot"
ENT.Spawnable        = false
ENT.AdminSpawnable   = false


--Stats--
ENT.Speed = 95
ENT.WalkSpeedAnimation = 1
ENT.FlinchSpeed = 0

ENT.health = 1500
ENT.Damage = 20

ENT.AttackWaitTime = 0.8
ENT.AttackFinishTime = 0.2

ENT.FallDamage = 15


--Model Settings--
ENT.Model = "models/player/charple.mdl"

ENT.ExplodeAnim = (ACT_GMOD_GESTURE_MELEE_SHOVE_2HAND)
ENT.AttackAnim = (ACT_GMOD_GESTURE_RANGE_ZOMBIE)
ENT.WalkAnim = (ACT_HL2MP_WALK_ZOMBIE_01)

ENT.FlinchAnim = (none)
ENT.FallAnim = (none)

ENT.AttackDoorAnim = (ACT_GMOD_GESTURE_RANGE_ZOMBIE)

--Sounds--
ENT.Attack1 = Sound("")
ENT.Attack2 = Sound("")

ENT.Enrage = Sound("")

ENT.Alert1 = Sound("")
ENT.Alert2 = Sound("")
ENT.Alert3 = Sound("")

ENT.DoorBreak = Sound("npc/zombie/zombie_pound_door.wav")

ENT.Death1 = Sound("")
ENT.Death2 = Sound("")
ENT.Death3 = Sound("")

ENT.Flinch1 = Sound("")
ENT.Flinch2 = Sound("")
ENT.Flinch3 = Sound("none")

ENT.Fall1 = Sound("")
ENT.Fall2 = Sound("")

ENT.Idle1 = Sound("")
ENT.Idle2 = Sound("")
ENT.Idle3 = Sound("")
ENT.Idle4 = Sound("")
ENT.Idle5 = Sound("none")
ENT.Idle6 = Sound("none")
ENT.Idle7 = Sound("none")
ENT.Idle8 = Sound("none")
ENT.Idle9 = Sound("none")

ENT.Pain1 = Sound("")
ENT.Pain2 = Sound("")
ENT.Pain3 = Sound("")
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

util.PrecacheSound(self.Enrage)

util.PrecacheSound(self.Alert1)
util.PrecacheSound(self.Alert2)
util.PrecacheSound(self.Alert3)

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
	if GetConVarNumber("fleshfire_collide") == 0 then
	self:SetCollisionGroup(COLLISION_GROUP_DEBRIS)
	end
	
	self:SetModel(self.Model)
	self:SetHealth(GetConVarNumber("fleshfire_health"))
	self:SetModelScale(1.1,0)
	
	self.LoseTargetDist	= GetConVarNumber("fleshfire_distcheck")	-- How far the enemy has to be before we lose them
	self.SearchRadius 	= GetConVarNumber("fleshfire_dist")	-- How far to search for enemies
	
	self:SetMaterial("models/flesh")
	self:SetColor(Color(255, 241, 241, 255))
	
	self.IsAttacking = false
	self.HasNoEnemy = false
	
	self:Ignite(9999999,65)
	
	--Misc--
	self:Precache()
	self.loco:SetStepHeight(35)	
	self.loco:SetAcceleration(900)
	self.loco:SetDeceleration(400)
	self.LastPos = self:GetPos()
	self.nextbot = true
end

function ENT:Think()
if !IsValid(self) then return end

	if self.IsAttacking then
		if (GetConVarNumber("nb_stop") == 0) then
		self.loco:FaceTowards( self.Enemy:GetPos() )
		end
	end

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
		
		if SERVER then
		self:EmitSound("npc/barnacle/barnacle_tongue_pull"..math.random(2)..".wav")
		end
		
		self:RestartGesture(self.AttackAnim)
		self:SetPoseParameter("move_x",0)
		coroutine.wait(self.AttackWaitTime)	
		
		if !self:IsValid() then return end
		if self:Health() < 0 then return end
		
		if !v:IsValid() then 
		self:StartActivity( self.WalkAnim )
		self:SetPoseParameter("move_x",self.WalkSpeedAnimation)
		self:EmitSound(self.Miss)
		return end
		
		if v:Health() < 0 then 
		self:StartActivity( self.WalkAnim )
		self:SetPoseParameter("move_x",self.WalkSpeedAnimation)
		self:EmitSound(self.Miss)
		return end
		
		if (self:GetRangeTo(v) < 65) then
			
			v:EmitSound(self.DoorBreak)
			v:TakeDamage(GetConVarNumber("fleshfire_damage"), self)	
			v:Ignite(GetConVarNumber("fleshfire_fireduration"),65)
		
		local phys = v:GetPhysicsObject()
			if (phys != nil && phys != NULL && phys:IsValid()) then
			phys:ApplyForceCenter(self:GetForward():GetNormalized()*20000 + Vector(0, 0, 2))
			end
				
			end	
			self:EmitSound(self.Miss)
				
		coroutine.wait(self.AttackFinishTime)		
		self:SetPoseParameter("move_x",self.WalkSpeedAnimation)
		self:StartActivity( self.WalkAnim )
			return true
		end
	end
	return false
end

function ENT:AttackBreakable()
	local entstoattack = ents.FindInSphere(self:GetPos(), 25)
	for _,v in pairs(entstoattack) do
	
		if (v:GetClass() == "func_breakable") then
		
		if SERVER then
		self:EmitSound("npc/barnacle/barnacle_tongue_pull"..math.random(2)..".wav")
		end
		
		self:RestartGesture(self.AttackAnim)
		self:SetPoseParameter("move_x",0)
		coroutine.wait(self.AttackWaitTime)	
		
		if !self:IsValid() then return end
		if self:Health() < 0 then return end
		
		if !v:IsValid() then 
		self:StartActivity( self.WalkAnim )
		self:SetPoseParameter("move_x",self.WalkSpeedAnimation)
		self:EmitSound(self.Miss)
		return end
		
		if v:Health() < 0 then 
		self:StartActivity( self.WalkAnim )
		self:SetPoseParameter("move_x",self.WalkSpeedAnimation)
		self:EmitSound(self.Miss)
		return end
		
		if (self:GetRangeTo(v) < 65) then
			
			v:EmitSound(self.DoorBreak)
			v:TakeDamage(GetConVarNumber("fleshfire_damage"), self)	
			v:Ignite(GetConVarNumber("fleshfire_fireduration"),65)
				
			end	
			self:EmitSound(self.Miss)
				
		coroutine.wait(self.AttackFinishTime)		
		self:SetPoseParameter("move_x",self.WalkSpeedAnimation)
		self:StartActivity( self.WalkAnim )
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
	self:EmitSound("npc/barnacle/barnacle_tongue_pull"..math.random(3)..".wav")
	end
end

function ENT:AlertSound()
self:EmitSound("npc/barnacle/barnacle_tongue_pull"..math.random(3)..".wav")
end

function ENT:RunBehaviour()
	while ( true ) do
		if ( self:HaveEnemy() ) then
		self.HasNoEnemy = false
			self:AlertSound()
			self:StartActivity(self.WalkAnim)
			self:SetPoseParameter("move_x",self.WalkSpeedAnimation)
			
			self.loco:SetDesiredSpeed(GetConVarNumber("nightmare_speed"))
			self:ChaseEnemy() 
		else
			-- Wander around
		self.HasNoEnemy = true
			self:StartActivity(self.WalkAnim)
			self:SetPoseParameter("move_x",self.WalkSpeedAnimation)
			
			self.loco:SetDesiredSpeed(GetConVarNumber("nightmare_speed"))
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
	
	if (self:GetPos():Distance(self.Enemy:GetPos()) < 1000) then	
	if math.random( 1,500) == 5 then
	self:IdleSounds()
	end
		end
	
	local door = ents.FindInSphere(self:GetPos(),55)
		if door then
			for i = 1, #door do
				local v = door[i]
				if !v:IsPlayer() and v != self and IsValid( v ) then
					if self:GetDoor( v ) == "door" then
					
						if v.Hitsleft == nil then
							v.Hitsleft = 10
						end
						
						if v != NULL and v.Hitsleft > 0 then
							if (self:GetRangeTo(v) < 60) then
					
							self:RestartGesture(self.AttackDoorAnim)
							coroutine.wait(self.AttackWaitTime)
					
		if !self:IsValid() then return end
		if self:Health() < 0 then return end
		
		if !v:IsValid() then 
		self:StartActivity( self.WalkAnim )
		self:SetPoseParameter("move_x",self.WalkSpeedAnimation)
		self:EmitSound(self.Miss)
		return end
		
		if v:Health() < 0 then 
		self:StartActivity( self.WalkAnim )
		self:SetPoseParameter("move_x",self.WalkSpeedAnimation)
		self:EmitSound(self.Miss)
		return end
		
				if (self:GetRangeTo(v) < 55) then
				v:EmitSound(self.DoorBreak)
				v:Ignite(GetConVarNumber("fleshfire_fireduration"),65)
				end
				self:EmitSound(self.Miss)
								
								if v != NULL and v.Hitsleft != nil then
									if v.Hitsleft > 0 then
									v.Hitsleft = v.Hitsleft - 2
									
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
						phys:ApplyForceCenter(self:GetForward():GetNormalized()*50000 + Vector(0, 0, 2))
						end
						
						door:SetSkin(v:GetSkin())
						door:SetColor(v:GetColor())
						door:SetMaterial(v:GetMaterial())
						door:Ignite(GetConVarNumber("fleshfire_fireduration"),65)
					end
						coroutine.wait(self.AttackFinishTime)	
						self:StartActivity( self.WalkAnim )
						end
						end
						end
						end
						
		local ent = ents.FindInSphere(self:GetPos(),90)
	for k,v in pairs( ent ) do
		if (v:IsPlayer() && v:Alive()) then
		self.Enemy = v
		self:Attack()
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

ENT.nxtAttack = 0
function ENT:Attack()

	if !self.nxtAttack then self.nxtAttack = 0 end
    if CurTime() < self.nxtAttack then return end

    self.nxtAttack = CurTime() + 1.2

if SERVER then
		self:EmitSound("npc/barnacle/barnacle_tongue_pull"..math.random(2)..".wav")
		end
	
		local attack = math.random(1,2)
		if attack == 1 then
	
		timer.Simple(0.7, function() 
		if !self:IsValid() then return end
		if self:Health() < 0 then return end
		
		if !self.Enemy:IsValid() then 
		self:StartActivity( self.WalkAnim )
		self:SetPoseParameter("move_x",self.WalkSpeedAnimation)
		self:EmitSound(self.Miss)
		return end
		
		if self.Enemy:Health() < 0 then 
		self:StartActivity( self.WalkAnim )
		self:SetPoseParameter("move_x",self.WalkSpeedAnimation)
		self:EmitSound(self.Miss)
		return end
		
		if (self:GetRangeTo(self.Enemy) < 55) then
		self.Enemy:EmitSound(self.Hit)
		self.Enemy:TakeDamage(GetConVarNumber("fleshfire_damage"), self)	
		self.Enemy:ViewPunch(Angle(math.random(-1, 1)*self.Damage, math.random(-1, 1)*self.Damage, math.random(-1, 1)*self.Damage))
		
		local bleed = ents.Create("info_particle_system")
		bleed:SetKeyValue("effect_name", "blood_impact_red_01")
		bleed:SetPos(self.Enemy:GetPos() + Vector(0,0,70)) 
		bleed:Spawn()
		bleed:Activate() 
		bleed:Fire("Start", "", 0)
		bleed:Fire("Kill", "", 0.2)
		
		local moveAdd=Vector(0,0,150)
		if not self.Enemy:IsOnGround() then
		moveAdd=Vector(0,0,0)
		end
		self.Enemy:SetVelocity(moveAdd+((self.Enemy:GetPos()-self:GetPos()):GetNormal()*100)) -- apply the velocity

		self.Enemy:Ignite(GetConVarNumber("fleshfire_fireduration"),65)
	
			end
			self:EmitSound(self.Miss)
		end)

		self.Enemy = self.Enemy
		self.IsAttacking = true
		
	self:RestartGesture(self.AttackAnim)			
	
		else 
		if attack == 2 then	
	self:RestartGesture(self.ExplodeAnim)		
	
	timer.Simple( 0.5, function()
	if !self.Enemy:IsValid() then 
		self:StartActivity( self.WalkAnim )
		self:SetPoseParameter("move_x",self.WalkSpeedAnimation)
		self:EmitSound(self.Miss)
	return end
		
	if self.Enemy:Health() < 0 then 
		self:StartActivity( self.WalkAnim )
		self:SetPoseParameter("move_x",self.WalkSpeedAnimation)
		self:EmitSound(self.Miss)
	return end
	
		local explode = ents.Create("env_explosion")
	explode:SetPos(self:GetPos() + Vector(0,0,8))
	explode:SetOwner(self)	
	explode:Spawn()
	explode:SetKeyValue( "iMagnitude", "75" )
	explode:SetOwner(self)	
	explode:Fire( "Explode", 0, 0 )
	explode:EmitSound("ambient/fire/gascan_ignite1.wav")
		
	local effectdata = EffectData()
	effectdata:SetStart(self:GetPos() + Vector(0,0,8))
	effectdata:SetOrigin(self:GetPos() + Vector(0,0,8))
	effectdata:SetScale( 1 )
	util.Effect( "HelicopterMegaBomb", effectdata )	
	
	self:TakeDamage(50)
	end)
	
		self:StartActivity( self.WalkAnim )
		self.IsAttacking = false

	end	
end
end

	if SERVER then
function ENT:OnKilled( dmginfo )

	local effectdata = EffectData()
	effectdata:SetStart( dmginfo:GetDamagePosition() ) 
	effectdata:SetOrigin( dmginfo:GetDamagePosition() )
	effectdata:SetScale( 1 )
	util.Effect( "HelicopterMegaBomb", effectdata )

	self:EmitSound("ambient/fire/gascan_ignite1.wav")
	self:SetColor(Color(255, 1, 1, 255))
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

	if !dmginfo:GetAttacker():IsPlayer() and dmginfo:IsExplosionDamage() then
	dmginfo:ScaleDamage(0)
	end

	if dmginfo:IsExplosionDamage() then
	dmginfo:ScaleDamage(5)
	else
	dmginfo:ScaleDamage(0.7)
	end
	
	if dmginfo:IsDamageType( DMG_DIRECT ) or dmginfo:IsDamageType( DMG_BURN ) and !dmginfo:GetAttacker():IsPlayer() then
	dmginfo:ScaleDamage(0)
	else
	dmginfo:ScaleDamage(0.7)
	end
		
end
	end
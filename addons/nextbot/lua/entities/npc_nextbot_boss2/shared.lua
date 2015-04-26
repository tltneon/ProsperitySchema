AddCSLuaFile()

ENT.Base             = "base_nextbot"
ENT.Spawnable        = false
ENT.AdminSpawnable   = false


--Stats--
ENT.Speed = 80
ENT.WalkSpeedAnimation = 0.8
ENT.FlinchSpeed = 0

ENT.health = 1500
ENT.Damage = 10

ENT.AttackWaitTime = 1
ENT.AttackFinishTime = 0.5

ENT.FallDamage = 0


--Model Settings--
ENT.Model = "models/player/corpse1.mdl"

ENT.AttackAnim = (ACT_GMOD_GESTURE_RANGE_ZOMBIE)
ENT.SpawnAnim = ( ACT_GMOD_GESTURE_ITEM_PLACE )

ENT.WalkAnim = (ACT_HL2MP_WALK_ZOMBIE_06)

ENT.AttackDoorAnim = (ACT_GMOD_GESTURE_RANGE_ZOMBIE)

--Sounds--
ENT.Attack1 = Sound("npc/zombie/zo_attack1.wav")
ENT.Attack2 = Sound("npc/zombie/zo_attack2.wav")

ENT.Death1 = Sound("npc/zombie_poison/pz_die1.wav")
ENT.Death2 = Sound("npc/zombie_poison/pz_die2.wav")

ENT.Pain1 = Sound("physics/flesh/flesh_bloody_break.wav")
ENT.Pain2 = Sound("physics/flesh/flesh_bloody_break.wav")

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
	
util.PrecacheSound(self.Pain1)
util.PrecacheSound(self.Pain2)
	
util.PrecacheSound(self.Hit)
util.PrecacheSound(self.Miss)

end

function ENT:Initialize()

	--Stats--
	self:SetCollisionGroup(COLLISION_GROUP_DEBRIS)
	
    self:SetModel(self.Model)
	self:SetHealth( self.health )
	self:SetColor(Color(95, 255, 95, 255)) -- greenish color
	self:SetMaterial("models/flesh")
	self:SetModelScale( 1.8, 0 )
	
	self.LoseTargetDist	= 4000	-- How far the enemy has to be before we lose them
	self.SearchRadius 	= 3000	-- How far to search for enemies

	self.IsAttacking = false
	self.HasNoEnemy = false
	
	--Misc--
	self:Precache()
	self.loco:SetStepHeight(35)	
	self.loco:SetAcceleration(900)
	self.loco:SetDeceleration(900)
	self.LastPos = self:GetPos()
	self.nextbot = true
end

function ENT:SpawnMinions()
	if SERVER then
	if !self:IsValid() then return end
	if self:Health() < 0 then return end
	
	local infectednpc = ents.Create("npc_nextbot_poisonremains")
	infectednpc:SetPos(self:GetPos() + Vector(5,20,0))
	infectednpc:Spawn()
	infectednpc:EmitSound("physics/flesh/flesh_bloody_break.wav")
	
	local effectdata = EffectData()
	effectdata:SetStart( infectednpc:GetPos() ) 
	effectdata:SetOrigin( infectednpc:GetPos() )
	effectdata:SetScale( 0.8 )
	util.Effect( "poisonexplosion", effectdata )
	self:EmitSound("ambient/fire/gascan_ignite1.wav", 125, math.random(85,110))
	
	local ents = ents.FindInSphere( self:GetPos(), 150 )
	for _,v in pairs(ents) do
	
		if v:IsPlayer() then
		v:TakeDamage(10, self)
		v:EmitSound("npc/headcrab_poison/ph_hiss1.wav")
	
		local painsounds = {}
		painsounds[1] = ("player/pl_pain7.wav")
		painsounds[2] = ("player/pl_pain6.wav")
		painsounds[3] = ("player/pl_pain5.wav")
		v:EmitSound( painsounds[math.random(1,3)] )
		
		local moveAdd=Vector(0,0,250)
			if not v:IsOnGround() then
			moveAdd=Vector(0,0,0)
			end
			v:SetVelocity(moveAdd+((v:GetPos()-self:GetPos()):GetNormal()*100)) -- apply the velocity
		end
		
		if v:GetClass("prop_physics") then
		local phys = v:GetPhysicsObject()
			if (phys != nil && phys != NULL && phys:IsValid()) then
			phys:ApplyForceCenter(self:GetForward():GetNormalized()*10000 + Vector(0, 0, 2))
			v:TakeDamage(10, self)	
			end
		end	
		
	end
	
	end	
		
end

function ENT:Think()
if !IsValid(self) then return end

	if ( self.EffectTimer or 0 ) < CurTime() then
	self.EffectTimer = CurTime() + 0.425
	local effectdata = EffectData()
	effectdata:SetStart( self:GetPos() + Vector(0,0,48) ) 
	effectdata:SetOrigin( self:GetPos() + Vector(0,0,48) )
	effectdata:SetScale( 0.8 )
	util.Effect( "poisonfire", effectdata )
	end
	
	if ( self.DamageTimer or 0 ) < CurTime() then
	self.DamageTimer = CurTime() + 1
	local ents = ents.FindInSphere( self:GetPos(), 100 )
	for _,v in pairs(ents) do
	
		if v:IsPlayer() then
		v:TakeDamage(5, self)
		v:EmitSound("npc/headcrab_poison/ph_hiss1.wav")
	
		local painsounds = {}
		painsounds[1] = ("player/pl_pain7.wav")
		painsounds[2] = ("player/pl_pain6.wav")
		painsounds[3] = ("player/pl_pain5.wav")
		v:EmitSound( painsounds[math.random(1,3)] )
		
		local moveAdd=Vector(0,0,250)
			if not v:IsOnGround() then
			moveAdd=Vector(0,0,0)
			end
			v:SetVelocity(moveAdd+((v:GetPos()-self:GetPos()):GetNormal()*200)) -- apply the velocity
		end
		
		if v:GetClass("prop_physics") then
		local phys = v:GetPhysicsObject()
			if (phys != nil && phys != NULL && phys:IsValid()) then
			phys:ApplyForceCenter(self:GetForward():GetNormalized()*10000 + Vector(0, 0, 2))
			v:TakeDamage(10, self)	
			end
		end	
	end
	
	end

	if GetConVarNumber( "nb_stop" ) == 0 then
		if ( self.SpawnTimer or 0 ) < CurTime() then
		self.SpawnTimer = CurTime() + 14
		self:RestartGesture( self.SpawnAnim )
		
		timer.Simple(1, function()
		if !self:IsValid() then return end
		if self:Health() < 0 then return end
		self:SpawnMinions()
		end)
		
		end
	end
	
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
        tr.endpos = tr.start - ang:Right()*5 + ang:Forward()*10
        tr.filter = self
        tr = util.TraceLine(tr)

        if tr.Hit && !self.FeetOnGround then
		self:EmitSound("npc/zombie_poison/pz_left_foot1.wav", 68)
		
		local sounds = {}
			sounds[1] = ("physics/flesh/flesh_squishy_impact_hard1.wav")
			sounds[2] = ("physics/flesh/flesh_squishy_impact_hard2.wav")
			sounds[3] = ("physics/flesh/flesh_squishy_impact_hard3.wav")
			sounds[4] = ("physics/flesh/flesh_squishy_impact_hard4.wav")
			self:EmitSound( sounds[math.random(1,4)], 65, math.random(85,95) )
		
        end

        self.FeetOnGround = tr.Hit
		
	-- Second Step
		local bones2 = self:LookupBone("ValveBiped.Bip01_L_Foot")
		
        local pos2, ang2 = self:GetBonePosition(bones2)

        local tr = {}
        tr.start = pos2 
        tr.endpos = tr.start - ang2:Right()*5 + ang2:Forward()*10
        tr.filter = self
        tr = util.TraceLine(tr)

        if tr.Hit && !self.FeetOnGround2 then
		self:EmitSound("npc/zombie_poison/pz_left_foot1.wav", 68)
		
		local sounds = {}
			sounds[1] = ("physics/flesh/flesh_squishy_impact_hard1.wav")
			sounds[2] = ("physics/flesh/flesh_squishy_impact_hard2.wav")
			sounds[3] = ("physics/flesh/flesh_squishy_impact_hard3.wav")
			sounds[4] = ("physics/flesh/flesh_squishy_impact_hard4.wav")
			self:EmitSound( sounds[math.random(1,4)], 65, math.random(85,95) )
		
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
		local sounds = {}
	sounds[1] = (self.Attack1)
	sounds[2] = (self.Attack2)
		self:EmitSound( sounds[math.random(1,2)], 75, math.random(65,80) )
		end
	
		self:RestartGesture(self.AttackAnim)  
		self:SetPoseParameter("move_x",0)
		coroutine.wait(self.AttackWaitTime)
		self:EmitSound(self.Miss)
		
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
		
		if (self:GetRangeTo(v) < 60) then

		local phys = v:GetPhysicsObject()
			if (phys != nil && phys != NULL && phys:IsValid()) then
			phys:ApplyForceCenter(self:GetForward():GetNormalized()*50000 + Vector(0, 0, 2))
			v:EmitSound(self.DoorBreak)
			v:TakeDamage( self.Damage, self)	
			end
			end
		coroutine.wait(self.AttackFinishTime)	
		self:StartActivity( self.WalkAnim )
		self:SetPoseParameter("move_x",self.WalkSpeedAnimation)
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
		local sounds = {}
	sounds[1] = (self.Attack1)
	sounds[2] = (self.Attack2)
		self:EmitSound( sounds[math.random(1,2)], 75, math.random(65,80) )
		end
	
		self:RestartGesture(self.AttackAnim) 
		self:SetPoseParameter("move_x",0)	
		coroutine.wait(self.AttackWaitTime)
		self:EmitSound(self.Miss)
		
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
		
			v:EmitSound(self.DoorBreak)
			v:TakeDamage( self.Damage, self)	
			
		coroutine.wait(self.AttackFinishTime)	
		self:StartActivity( self.WalkAnim )
		self:SetPoseParameter("move_x",self.WalkSpeedAnimation)
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

function ENT:RunBehaviour()
	while ( true ) do
		if ( self:HaveEnemy() ) then
		self.HasNoEnemy = false
			self:StartActivity( self.WalkAnim )
			self:SetPoseParameter("move_x",self.WalkSpeedAnimation)
			self.loco:SetDesiredSpeed( self.Speed )
			self:ChaseEnemy() 
		else
			-- Wander around
		self.HasNoEnemy = true
			self:StartActivity( self.WalkAnim )
			self:SetPoseParameter("move_x",self.WalkSpeedAnimation)
			self.loco:SetDesiredSpeed( self.Speed )
			self:IdleSounds()
			self:MoveToPos( self:GetPos() + Vector( math.Rand( -1, 1 ), math.Rand( -1, 1 ), 0 ) * 400 )
			self:SetPoseParameter("move_x",0)
		end
		coroutine.wait( 1 )
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
	
	local door = ents.FindInSphere(self:GetPos(),25)
		if door then
			for i = 1, #door do
				local v = door[i]
				if !v:IsPlayer() and v != self and IsValid( v ) then
					if self:GetDoor( v ) == "door" then
					
						if v.Hitsleft == nil then
							v.Hitsleft = 10
						end
						
						if v != NULL and v.Hitsleft > 0 then
						
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
						
							if (self:GetRangeTo(v) < 25) then
							
								self:RestartGesture(self.AttackDoorAnim)
								self.loco:SetDesiredSpeed(0)
								self:SetPoseParameter("move_x",0)
								coroutine.wait(self.AttackWaitTime)	
								v:EmitSound(self.DoorBreak)
								
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
						door:SetColor(v:GetColor())
						door:EmitSound("Wood_Plank.Break")	
						door:SetSkin(v:GetSkin())
						door:SetMaterial(v:GetMaterial())
						
						local phys = door:GetPhysicsObject()
						if (phys != nil && phys != NULL && phys:IsValid()) then
						phys:ApplyForceCenter(self:GetForward():GetNormalized()*50000 + Vector(0, 0, 2))
						end
						
					end
						coroutine.wait(self.AttackFinishTime)	
						self:StartActivity( self.WalkAnim )
						self.loco:SetDesiredSpeed(self.Speed)
						self:SetPoseParameter("move_x",self.WalkSpeedAnimation)
						end
						end
						end
						end

		local ent = ents.FindInSphere(self:GetPos(),100)
	for k,v in pairs( ent ) do
		if (v:IsPlayer() && v:Alive()) then
		self.Enemy = v
		self:Attack()
		end
	end						
		
		if GetConVarNumber( "nb_attackprop" ) == 1 then
		if (self:GetRangeTo(self.Enemy) < 50 or self:AttackProp()) then
			else
			if (self:GetRangeTo(self.Enemy) < 50 or self:AttackBreakable()) then
			end 
		end
	end
	
		coroutine.yield()
	end
	return "ok"
end

function ENT:Attack()
		
	if !self.nxtAttack then self.nxtAttack = 0 end
    if CurTime() < self.nxtAttack then return end

    self.nxtAttack = CurTime() + 4
		
		if ( (self.Enemy:IsValid() and self.Enemy:Health() > 0 ) ) then
		
		if self.IsFlinching or self.IsReviving then return end
		
		self:RestartGesture( self.SpawnAnim )  
		self.Enemy = self.Enemy
		self.IsAttacking = true
		
		timer.Simple(1, function()
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
		
			if self.Enemy:IsPlayer() then
			self:SpawnMinions()
			end
		
		end)
		
		self:StartActivity( self.WalkAnim )
		self:SetPoseParameter("move_x",self.WalkSpeedAnimation)
		self.IsAttacking = false
		end
end

	if SERVER then
function ENT:OnKilled( dmginfo )
	
	local deathanim = ents.Create("boss2_deathanim")
			if !self:IsValid() then return end
			if deathanim:IsValid() then 
			deathanim:SetPos(self:GetPos())
			deathanim:SetModel(self:GetModel())
			deathanim:SetAngles(self:GetAngles())
			deathanim:Spawn()
			
			deathanim:SetModelScale( 1.4, 0 )
			
			deathanim:SetSkin(self:GetSkin())
			deathanim:SetColor(self:GetColor())
			deathanim:SetMaterial(self:GetMaterial())
			self:Remove()
			end
	
	local deathsounds = {}
	deathsounds[1] = (self.Death1)
	deathsounds[2] = (self.Death2)
	self:EmitSound( deathsounds[math.random(1,2)], 77, math.random(65,80) )
	
	self:EmitSound("ambient/fire/gascan_ignite1.wav", 125, math.random(85,110))
	
	local effectdata = EffectData()
	effectdata:SetStart( dmginfo:GetDamagePosition() ) 
	effectdata:SetOrigin( dmginfo:GetDamagePosition() )
	effectdata:SetScale( 3 )
	util.Effect( "megapoisonexplosion", effectdata )
	
	local ents = ents.FindInSphere( self:GetPos(), 250 )
	for _,v in pairs(ents) do
	
		if v:IsPlayer() then
		v:TakeDamage(20, self)
		v:EmitSound("npc/headcrab_poison/ph_hiss1.wav")
	
		local painsounds = {}
		painsounds[1] = ("player/pl_pain7.wav")
		painsounds[2] = ("player/pl_pain6.wav")
		painsounds[3] = ("player/pl_pain5.wav")
		v:EmitSound( painsounds[math.random(1,3)] )
		
		local moveAdd=Vector(0,0,350)
			if not v:IsOnGround() then
			moveAdd=Vector(0,0,0)
			end
			v:SetVelocity(moveAdd+((v:GetPos()-self:GetPos()):GetNormal()*200)) -- apply the velocity
		
		end
		
		if v:GetClass("prop_physics") then
		local phys = v:GetPhysicsObject()
			if (phys != nil && phys != NULL && phys:IsValid()) then
			phys:ApplyForceCenter(self:GetForward():GetNormalized()*10000 + Vector(0, 0, 2))
			v:TakeDamage(20, self)	
			end
		end	
		
	end

end

function ENT:OnInjured( dmginfo )

	if self.HasNoEnemy and dmginfo:GetAttacker():IsPlayer() then
		if self:IsValid() and self:Health() > 0 then
	local attacker = dmginfo:GetAttacker()
	self.SearchRadius 	= self:GetRangeTo(attacker) + 1000
	self.Enemy = attacker
	end -- If we don't have an enemy and we get injured by a player then we chase the player
		end

	if !dmginfo:GetAttacker():IsPlayer() then
		if dmginfo:GetAttacker():GetClass("nazi_zombie_*", "npc_nextbot_*", "mob_zombie_*") then
			if dmginfo:IsExplosionDamage() then
			dmginfo:ScaleDamage(0)
			end
		end
	end
	
	if dmginfo:IsExplosionDamage() then
	dmginfo:ScaleDamage(10)
	else
	dmginfo:ScaleDamage(0.6)
	end
	
	if math.random( 1,12 ) == 1 then
	local painsounds = {}
	painsounds[1] = (self.Pain1)
	painsounds[2] = (self.Pain2)
	self:EmitSound( painsounds[math.random(1,2)], math.random(80,90), math.random(65,80) )
	
	local effectdata = EffectData()
	effectdata:SetStart( dmginfo:GetDamagePosition() ) 
	effectdata:SetOrigin( dmginfo:GetDamagePosition() )
	effectdata:SetScale( 0.8 )
	util.Effect( "poisonexplosion", effectdata )
	self:EmitSound("ambient/fire/gascan_ignite1.wav", 125, math.random(85,110))
	
	local ents = ents.FindInSphere( self:GetPos(), 150 )
	for _,v in pairs(ents) do
	
		if v:IsPlayer() then
		v:TakeDamage(10, self)
		v:EmitSound("npc/headcrab_poison/ph_hiss1.wav")
	
		local painsounds = {}
		painsounds[1] = ("player/pl_pain7.wav")
		painsounds[2] = ("player/pl_pain6.wav")
		painsounds[3] = ("player/pl_pain5.wav")
		v:EmitSound( painsounds[math.random(1,3)] )
		
		local moveAdd=Vector(0,0,250)
			if not v:IsOnGround() then
			moveAdd=Vector(0,0,0)
			end
			v:SetVelocity(moveAdd+((v:GetPos()-self:GetPos()):GetNormal()*100)) -- apply the velocity
		end
		
		if v:GetClass("prop_physics") then
		local phys = v:GetPhysicsObject()
			if (phys != nil && phys != NULL && phys:IsValid()) then
			phys:ApplyForceCenter(self:GetForward():GetNormalized()*10000 + Vector(0, 0, 2))
			v:TakeDamage(10, self)	
			end
		end	
	end
	
	end
end
	end		
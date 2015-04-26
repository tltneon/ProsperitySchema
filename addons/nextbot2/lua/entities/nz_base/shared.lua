AddCSLuaFile()

ENT.Base             = "base_nextbot"
ENT.Spawnable        = false
ENT.AdminSpawnable   = false

--Stats--
ENT.FootAngles = 5
ENT.FootAngles2 = 5

ENT.Bone1 = "ValveBiped.Bip01_R_Foot"
ENT.Bone2 = "ValveBiped.Bip01_L_Foot"

ENT.SearchRadius = 2000
ENT.LoseTargetDist = 4000

ENT.Speed = 0
ENT.WalkSpeedAnimation = 0
ENT.FlinchSpeed = 0

ENT.Health = 0
ENT.Damage = 0

ENT.PhysForce = 15000
ENT.AttackRange = 60
ENT.InitialAttackRange = 90

ENT.HitPerDoor = 1
ENT.DoorAttackRange = 25

ENT.AttackWaitTime = 0
ENT.AttackFinishTime = 0

ENT.NextAttack = 1.3

ENT.FallDamage = 0

--Model Settings--
ENT.Model = ""

ENT.AttackAnim = (NONE)

ENT.WalkAnim = (NONE)

ENT.FlinchAnim = (NONE)
ENT.FallAnim = (NONE)

ENT.AttackDoorAnim = (NONE)

--Sounds--
ENT.Attack1 = Sound("")
ENT.Attack2 = Sound("")

ENT.DoorBreak = Sound("")

ENT.Death1 = Sound("")
ENT.Death2 = Sound("")
ENT.Death3 = Sound("")

ENT.Fall1 = Sound("")
ENT.Fall2 = Sound("")

ENT.Idle1 = Sound("")
ENT.Idle2 = Sound("")
ENT.Idle3 = Sound("")
ENT.Idle4 = Sound("")

ENT.Pain1 = Sound("")
ENT.Pain2 = Sound("")
ENT.Pain3 = Sound("")

ENT.Hit = Sound("")
ENT.Miss = Sound("")

function ENT:Precache()
end

function ENT:Initialize()
end
	
function ENT:CreateBullseye( height )
	local bullseye = ents.Create("npc_bullseye")
	bullseye:SetPos( self:GetPos() + Vector(0,0,height or 50) )
	bullseye:SetAngles( self:GetAngles() )
	bullseye:SetParent( self )
	bullseye:SetSolid( SOLID_NONE )
	bullseye:SetCollisionGroup( COLLISION_GROUP_IN_VEHICLE )
	
	bullseye:SetOwner( self )
	bullseye:Spawn()
	bullseye:Activate()
	bullseye:SetHealth( 9999999 )
	
	self.Bullseye = bullseye
end
	
function ENT:CreateRelationShip()
	if ( self.RelationTimer or 0 ) < CurTime() then	
	local bullseye = self.Bullseye
	
	if !self:CheckValid( bullseye ) then 
	SafeRemoveEntity( bullseye )
	return end
	
	self.LastPos = self:GetPos( )
	
	local ents = ents.GetAll()
	table.Add(ents)
	for _,v in pairs(ents) do
		if v:GetClass() != self and v:GetClass() != "npc_bullseye" and v:GetClass() != "npc_grenade_frag" and v:IsNPC() then
			if GetConVarNumber("nb_npc") == 1 then
			v:AddEntityRelationship( bullseye, 1, 10 )
			else
			v:AddEntityRelationship( bullseye, 3, 10 )
			end
		end
	end
	self.RelationTimer = CurTime() + 2
	end
end	
	
function ENT:CustomThink()
end	

function ENT:SpawnFunction( ply, tr, ClassName )

	if ( !tr.Hit ) then return end

	local SpawnPos = tr.HitPos + tr.HitNormal * 16

	if util.PointContents( tr.HitPos ) == CONTENTS_EMPTY then
	local ent = ents.Create( Class )
	ent:SetPos( SpawnPos )
	ent:Spawn()
	end

	return ent

end
	
function ENT:FaceTowards( ent ) 
	self.loco:FaceTowards( ent:GetPos() )
	self.loco:FaceTowards( ent:GetPos() )
	self.loco:FaceTowards( ent:GetPos() )
	self.loco:FaceTowards( ent:GetPos() )
	self.loco:FaceTowards( ent:GetPos() )
	self.loco:FaceTowards( ent:GetPos() )
	self.loco:FaceTowards( ent:GetPos() )
end	
	
function ENT:Think()
if !IsValid(self) then return end
	
		self:CreateRelationShip()
		self:CustomThink()
		self:CheckEnemies()
		
		local enemy = self:GetEnemy()
		
		if enemy and enemy:IsValid() and enemy:Health() > 0 then
			if self.IsAttacking then
				if (GetConVarNumber("nb_stop") == 0) then
				self:FaceTowards( enemy )
				end
			end
		else
		self.IsAttacking = false
		end
		
	-- Step System --
    if !self.nxtThink then self.nxtThink = 0 end
    if CurTime() < self.nxtThink then return end

    self.nxtThink = CurTime() + 0.025
	
	-- First Step
        local bones = self:LookupBone(self.Bone1)
		
        local pos, ang = self:GetBonePosition(bones)

        local tr = {}
        tr.start = pos
        tr.endpos = tr.start - ang:Right()* self.FootAngles + ang:Forward()* self.FootAngles2
        tr.filter = self
        tr = util.TraceLine(tr)

        if tr.Hit && !self.FeetOnGround then
		self:FootSteps()
        end

        self.FeetOnGround = tr.Hit
		
	-- Second Step
		local bones2 = self:LookupBone(self.Bone2)
		
        local pos2, ang2 = self:GetBonePosition(bones2)

        local tr = {}
        tr.start = pos2
        tr.endpos = tr.start - ang2:Right()* self.FootAngles + ang2:Forward()* self.FootAngles2
        tr.filter = self
        tr = util.TraceLine(tr)

        if tr.Hit && !self.FeetOnGround2 then
		self:FootSteps()
        end

        self.FeetOnGround2 = tr.Hit
end

ENT.nxtAttack = 0
function ENT:Attack()
end

function ENT:CustomDeath( dmginfo )
self:BecomeRagdoll( dmginfo )
end

function ENT:CustomInjure( dmginfo )
end

function ENT:FootSteps()
end

function ENT:AlertSound()
end

function ENT:PainSound()
end

function ENT:DeathSound()
end

function ENT:AttackSound()
end

function ENT:IdleSound()
end

function ENT:IdleSounds()
	if self.Enemy then
		if math.random(1,3) == 1 then
		self:IdleSound()
		end
	else
		if math.random(1,18) == 1 then
		self:IdleSound()
		end
	end
end

function ENT:RunBehaviour()
	while ( true ) do
		if ( self:HaveEnemy() ) then
			self.HasNoEnemy = false
			self:AlertSound()
			
			self:StartActivity(self.WalkAnim)
			self:SetPoseParameter("move_x",self.WalkSpeedAnimation)	
			
			self.loco:SetDesiredSpeed( self.Speed )

			self:ChaseEnemy()
			
		else
			-- Wander around
			self.HasNoEnemy = true
			
			self:StartActivity(self.WalkAnim)
			self:SetPoseParameter("move_x",self.WalkSpeedAnimation)	
			self.loco:SetDesiredSpeed( self.Speed )
			
			self:CustomWander()
			self:SetPoseParameter("move_x",0)	
		end
		self:SetPoseParameter("move_x",0)	
		coroutine.wait( 0.50 )
		self:SetPoseParameter("move_x",0)
		coroutine.yield()
	end
end	
	
function ENT:CustomWander()

end

function ENT:CheckEnemies()
	if ( self.CheckTimer or 0 ) < CurTime() then	
	
	local enemy = self:GetEnemy()
	if enemy then
	
	local ent = ents.FindInSphere( self:GetPos(), 250 )
		for k,v in pairs( ent ) do
		
			if ( v:IsValid() and v:Health() > 0 ) and ( enemy:IsValid() and enemy:Health() > 0 ) then
				if ( enemy and v ) and self:GetRangeTo( v ) < 250 and self:GetRangeTo( enemy ) > 251 then
					self:CheckClass( v )
				end
			end
			
		end
		
	end
	
	self.CheckTimer = CurTime() + 3
	end
end

function ENT:CheckClass( ent )
	if ( string.find(ent:GetClass(), "npc_bullseye") ) or ( string.find(ent:GetClass(), "npc_nextbot_*") ) or ( string.find(ent:GetClass(), "npc_grenade_frag") ) then return end
	
	local enemy = self:GetEnemy()
	
	if GetConVarNumber("nb_npc") == 1 then		
		if ent and ( ent != enemy ) and ( ent:IsNPC() or ent:IsPlayer() ) and ent:IsValid() and ent:Health() > 0 then
			self.Enemy = ent
			self:BehaveStart()
		end
	else
		if ent and ( ent != enemy ) and ( ent:IsNPC() ) and ent:IsValid() and ent:Health() > 0 then
			self.Enemy = ent
			self:BehaveStart()
		end
	end
	
end
	
function ENT:CheckRangeToEnemy()
	if self:HaveEnemy() then
		
	local enemy = self:GetEnemy()
	
	if GetConVarNumber("nb_npc") == 1 then
		if ( enemy:IsNPC() and enemy:Health() > 0 ) or ( enemy:IsPlayer() and enemy:Alive() ) then
			if self:GetRangeTo( enemy ) < self.InitialAttackRange then
				self:Attack()
			end
		end	
	else
		if ( enemy:IsPlayer() and enemy:Alive() ) then
			if self:GetRangeTo( enemy ) < self.InitialAttackRange then
				if !enemy:IsValid() then return end
				if enemy:Health() < 0 then return end
				if self:IsLineOfSightClear( enemy ) then
					self:Attack()
				end
			end
		end	
	end
		
	if self:GetRangeTo( enemy ) < self.AttackRange / 3 then
		self:SetPoseParameter("move_x",0)	
	else
		self:SetPoseParameter("move_x",self.WalkSpeedAnimation)	
	end
	
	end
end	
	
function ENT:ChaseEnemy( options )

	local enemy = self:GetEnemy()
	if !enemy then self:FindEnemy() return end
	local options = options or {}
	
	local path = Path( "Chase" )
	path:SetMinLookAheadDistance( 300 )
	path:SetGoalTolerance( 20 )
	path:Compute( self, enemy:GetPos() )
	
	if (  !path:IsValid() ) then return "failed" end 

	while ( path:IsValid() and self:HaveEnemy() ) do
	
		if ( path:GetAge() > 0.1 ) then	
			if enemy and enemy:IsValid() and enemy:Health() > 0 then
			path:Compute( self, enemy:GetPos() )
			end
		end
		
		path:Update( self )
		
		if ( self.loco:IsStuck() ) then
			self:HandleStuck()
			return "stuck"
		end
	
	if enemy and enemy:IsValid() and enemy:Health() > 0 then
		if self:GetRangeTo( enemy ) < 600 then	
			if math.random( 1,500) == 5 then
			self:IdleSounds()
			end
		end
	end
	
	if GetConVarNumber("ai_ignoreplayers") == 1 then 
		if enemy:IsPlayer() then
		self:FindEnemy()
		self:BehaveStart()
		end
	end
	
	self:CustomChaseEnemy()
	self:CheckRangeToEnemy()
	
	if GetConVarNumber( "nb_attackprop" ) == 1 then
		if enemy and enemy:IsValid() and enemy:Health() > 0 then
			if self:GetRangeTo( enemy ) < 25 or self:AttackObject() then	
			elseif self:GetRangeTo( enemy ) < 25 or self:AttackDoor() then	
			end
		end
	end
	
		coroutine.yield()
	end
	return "ok"
end

function ENT:CheckValid( ent )
	if !ent then 
	return false
	end

	if !self:IsValid() then 
	return false
	end
	
	if self:Health() < 0 then 
	return false
	end
		
	if !ent:IsValid() then 
	self:BehaveStart()
	return false
	end
		
	if ent:Health() < 0 then 
	self:BehaveStart()
	return false
	end
	
	return true
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

function ENT:AttackDoor()

	local door = ents.FindInSphere(self:GetPos(),25)
		if door then
			for i = 1, #door do
				local v = door[i]
					if self:GetDoor( v ) == "door" then
					
					if v.Hitsleft == nil then
						v.Hitsleft = 10
					end
						
					if v != NULL and v.Hitsleft > 0 then

						if (self:GetRangeTo(v) < (self.DoorAttackRange)) then
							
							if self:GetRangeTo( v ) < 10 then
								self:SetPoseParameter( "move_x", 0.3 )
							else
								self:SetPoseParameter( "move_x", self.WalkSpeedAnimation )
							end
							
							self:CustomDoorAttack( v )
							
						end
						
					end
						
					if v != NULL and v.Hitsleft < 1 then
						
						local door = ents.Create("prop_physics")
						if door then
						door:SetModel(v:GetModel())
						door:SetPos(v:GetPos())
						door:SetAngles(v:GetAngles())
						door:Spawn()
						door.FalseProp = true
						door:EmitSound("Wood_Plank.Break")
						
						local phys = door:GetPhysicsObject()
						if (phys != nil && phys != NULL && phys:IsValid()) then
						phys:ApplyForceCenter(self:GetForward():GetNormalized()*20000 + Vector(0, 0, 2))
						end
						
						door:SetSkin(v:GetSkin())
						door:SetColor(v:GetColor())
						door:SetMaterial(v:GetMaterial())
						
						SafeRemoveEntity( v )
							
						end	
						
						self:BehaveStart()
						
					end	
				end
			end
		end
end

function ENT:CustomChaseEnemy()

end

function ENT:CustomDoorAttack( ent )	
			
	self:AttackSound()
	self:RestartGesture(self.AttackDoorAnim)
	self:SetPoseParameter("move_x",0)
	self.loco:SetDesiredSpeed(0)
	coroutine.wait(self.AttackWaitTime)
	
	if !self:CheckValid( ent ) then 
	self:EmitSound(self.Miss)
	self:StartActivity(self.WalkAnim)
	return end
	
	ent:EmitSound(self.DoorBreak)
	coroutine.wait(self.AttackFinishTime)
	
	self:StartActivity(self.WalkAnim)
	self:SetPoseParameter( "move_x", self.WalkSpeedAnimation)
	
end


function ENT:CustomPropAttack( ent )

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

function ENT:CheckProp( ent )
	if !ent:IsValid() then return end
	
	if ent:GetPhysicsObject():GetVolume() < 2600 then
		if (phys != nil && phys != NULL && phys:IsValid() ) then
	
		if ent:GetModel() == "models/props_debris/wood_board06a.mdl" or ent:GetModel() == "models/props_debris/wood_board05a.mdl" or ent:GetModel() == "models/props_debris/wood_board05a.mdl" then
		return true
		elseif ent:GetModel() == "models/props_debris/wood_board05a.mdl" or ent:GetModel() == "models/props_debris/wood_board04a.mdl" or ent:GetModel() == "models/props_debris/wood_board03a.mdl" then
		return true
		elseif ent:GetModel() == "models/props_debris/wood_board07a.mdl" or ent:GetModel() == "models/props_debris/wood_board02a.mdl" then
		return true
		end
		
		end
		return false	
	end
	
	return true
end

function ENT:AttackObject()
	local entstoattack = ents.FindInSphere(self:GetPos(), 25)
	for _,v in pairs(entstoattack) do
	
		if ( v:GetClass() == "func_breakable" || v:GetClass() == "func_physbox" || v:GetClass() == "prop_physics_multiplayer" || v:GetClass() == "prop_physics" ) then
		if v.FalseProp then return end
		if !self:CheckProp( v ) then return end
		
		if self:GetRangeTo( v ) < 10 then
			self:SetPoseParameter( "move_x", 0.3 )
		else
			self:SetPoseParameter( "move_x", self.WalkSpeedAnimation )
		end
	
		self:CustomPropAttack( v )
		
			return true
		end
	end
	return false
end

function ENT:OnKilled( dmginfo )
	self:DeathSound()
	self:CustomDeath( dmginfo )
end

function ENT:InjureCheck( attacker1, attacker2 )
	if GetConVarNumber( "ai_ignoreplayers" ) == 1 and attacker1 then 
	return false
	end
	
	if GetConVarNumber( "ai_ignoreplayers" ) == 1 and GetConVarNumber( "nb_npc" ) == 0 and ( attacker1 or attacker2 ) then 
	return false
	end
	
	if GetConVarNumber( "nb_npc" ) == 0 and attacker2 then 
	return false 
	end
	
	return true
end

function ENT:DeathAnimation( anim, pos, activity, scale )
	local zombie = ents.Create( anim )
	if !self:IsValid() then return end
	
	if zombie:IsValid() then 
		zombie:SetPos( pos )
		zombie:SetModel(self:GetModel())
		zombie:SetAngles(self:GetAngles())
		zombie:Spawn()			
		zombie:SetSkin(self:GetSkin())
		zombie:SetColor(self:GetColor())
		zombie:SetMaterial(self:GetMaterial())
		zombie:SetModelScale( scale, 0 )
			
		if self.HasNoEnemy then
			zombie:StartActivity( activity )
		else
			zombie:StartActivity( self.WalkAnim )
		end

		SafeRemoveEntity( self )
	end
end

function ENT:BleedVisual( time, pos, dmginfo )
	local bleed = ents.Create("info_particle_system")
	bleed:SetKeyValue("effect_name", "blood_impact_red_01")
	bleed:SetPos( pos ) 
	bleed:Spawn()
	bleed:Activate() 
	bleed:Fire("Start", "", 0)
	bleed:Fire("Kill", "", time)
end

function ENT:OnInjured( dmginfo )
	
	local attacker = dmginfo:GetAttacker()
	local inflictor = dmginfo:GetInflictor()
	local player = attacker:IsPlayer()
	local npc = attacker:IsNPC()
	
	if self.HasNoEnemy and ( player or npc ) then
		if self:IsValid() and self:Health() > 0 then
			if ( player or npc ) then
				if self:GetRangeTo( attacker ) < 1000 then
					if self:InjureCheck( player, npc ) then
					self:SetEnemy( attacker )
					end
				else
					if self:InjureCheck( player, npc ) then
					self:FaceTowards( attacker )
					self.SearchRadius = self.SearchRadius + 500
					end
				end
			end
		end
	end
	
	if self.nxtPainSound then
	self:PainSound( dmginfo )
	end
	
	self:CustomInjure( dmginfo )
	
	if dmginfo:IsExplosionDamage() then
		dmginfo:ScaleDamage( 10 )
	end
	
end

function ENT:OnOtherKilled()
	if self.HasNoEnemy then
		local ents = ents.FindInSphere( self:GetPos(), 500 )
		for _,v in pairs(ents) do
			if v:GetClass("nazi_zombie_*", "npc_nextbot_*", "mob_zombie_*", "nz_*") and v != self then
			self:FaceTowards( v )
			self.SearchRadius = self.SearchRadius + 500
			end
		end
	end
end

function ENT:GetEnemy()
	return self.Enemy
end

function ENT:HaveEnemy()
	local enemy = self:GetEnemy()

	if ( enemy and IsValid( enemy ) ) then
		if ( self:GetRangeTo( enemy:GetPos() ) > self.LoseTargetDist ) then
			return self:FindEnemy()
		elseif ( enemy:IsPlayer() and !enemy:Alive() ) then
			return self:FindEnemy()
		elseif ( enemy:IsNPC() and enemy:Health() < 0 ) then
			return self:FindEnemy()
	end	
			
		return true
	else
		return self:FindEnemy()
	end
	
end

function ENT:SetEnemy( ent )
	self.Enemy = ent
end

function ENT:FindEnemy()
	local _ents = ents.FindInCone(self:GetPos(),self:GetForward() * self.SearchRadius,self.SearchRadius,155)
	for k,v in pairs( _ents ) do
	
	if self:IsLineOfSightClear( v ) then
	
	if GetConVarNumber("nb_npc") == 1 then
			local enemy = math.random(1,2)
			if enemy == 1 then
				if v:IsPlayer() and v:Alive() then
					if GetConVarNumber("ai_ignoreplayers") == 0 then
					self:SetEnemy( v )
					return true
					end
				else
					if v:IsNPC() and v != self and !string.find(v:GetClass(), "npc_nextbot_*") and !string.find(v:GetClass(), "npc_bullseye") and !string.find(v:GetClass(), "npc_grenade_frag") then
					self:SetEnemy( v )
					return true
					end
				end
			else
				if v:IsNPC() and v != self and !string.find(v:GetClass(), "npc_nextbot_*") and !string.find(v:GetClass(), "npc_bullseye") and !string.find(v:GetClass(), "npc_grenade_frag") then
				self:SetEnemy( v )
				return true
				end
			end
	else
		if ( v:IsPlayer() and v:Alive() ) then
			if GetConVarNumber("ai_ignoreplayers") == 0 then
			self:SetEnemy( v )
			return true
			end
		end
	end

	end
	
	end	
	self:SetEnemy( nil )
	return false
end 

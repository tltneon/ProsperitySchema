AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )
include('shared.lua')

ENT.Model = "models/horror/zm_f4zt.mdl"
ENT.health = 200
ENT.Alerted = false
ENT.Territorial = false
ENT.Bleeds = true
ENT.Leaps = true
ENT.Chasing = false
ENT.Flinches = false
ENT.moving = false
ENT.FriendlyToPlayer = false
ENT.Damage = 5
ENT.AcidBlood = true
ENT.BleedsRed = true
ENT.LeapDamage = 15
ENT.LeapSpeed = 1000
ENT.LeapDistance = 300
ENT.MinLeapDistance = 200
ENT.MeleeAttacking = false;
ENT.Leaping = false
ENT.alert1 = "chorror/emily_reversed1.wav"
ENT.alert2 = "chorror/emily_reversed3.wav"
ENT.alert3 = "chorror/emily_reversed5.wav"
ENT.idle1 = "chorror/emily_reversed9.wav"
ENT.idle2 = "chorror/emily_reversed1.wav"
ENT.idle3 = "chorror/emily_reversed3.wav"
ENT.idle4 = "chorror/emily_reversed5.wav"
ENT.attack1 = "chorror/stinger2.wav"
ENT.attack2 = "chorror/leap1.wav"
ENT.attack3 = "chorror/fz_frenzy4.wav"
ENT.attackmiss1 = "chorror/psstright.wav"
ENT.attackmiss2 = "chorror/psstleft.wav"
ENT.attackmiss3 = "chorror/bass7.wav"
ENT.attackleap = "chorror/leap1.wav"
ENT.hurt1 = "chorror/bass4.wav"
ENT.hurt2 = "chorror/bass.wav"
ENT.hurt3 = "chorror/bass6.wav"
ENT.hurt4 = "chorror/bass_walls.wav"
ENT.die1 = "chorror/cryscreams.mp3"
ENT.die2 = "chorror/cryscreams.mp3"
ENT.die3 = "chorror/cryscreams.mp3"
ENT.die4 = "chorror/cryscreams.mp3"
ENT.dead = false;
ENT.target = NULL

local schedJump = ai_schedule.New( "Jump" ) 
schedJump:EngTask( "TASK_PLAY_SEQUENCE" , ACT_JUMP )


function ENT:Initialize()
   self:SetModel( self.Model )
   self:SetHullType( HULL_MEDIUM )
   self:SetHullSizeNormal()
   self:SetSolid( SOLID_BBOX )
   self:SetMoveType( MOVETYPE_STEP )
   self:CapabilitiesAdd( CAP_MOVE_GROUND)
   self:CapabilitiesAdd( CAP_SQUAD )
   self:CapabilitiesAdd( CAP_MOVE_JUMP)
   self:CapabilitiesAdd( CAP_MOVE_CLIMB)
   self:SetMaxYawSpeed( 5000 )
   self:SetHealth(self.health)
   self.teleportPos = self:GetPos()
   self.startPos = self:GetPos()
end

function ENT:HasPropInFrontOfMe()
	local entstoattack = ents.FindInSphere(self:GetPos() + self:GetForward()*75,47)
	for _,v in pairs(entstoattack) do
		if v:GetClass() == "prop_physics" then
		return true
		end
	end
	return false
end

function ENT:Think()
        //---------------
	local function setmeleefalse()
		if self:IsValid( self ) && self:Health() < 0 then return end
		self.MeleeAttacking = false
		self.Leaping = false
		self:SetSchedule(SCHED_RUN_RANDOM)
	end
        //---------------
	local function Attack_Melee()
		if self:IsValid( self ) && self:Health() < 0 then return end
		local entstoattack = ents.FindInSphere(self:GetPos() + self:GetForward()*75,47)
		local randomsound = math.random(1,3)
		local hit = false
		if entstoattack != nil then
			for _,v in pairs(entstoattack) do
				if ( (v:IsNPC() || ( v:IsPlayer() && v:Alive())) && (v != self) && (v:GetClass() != "npc_drone_xenomorph") && (v:GetClass() != self:GetClass()) || (v:GetClass() == "prop_physics")) then
					v:TakeDamage( self.Damage, self )  
					if v:IsPlayer() then
						v:ViewPunch(Angle(math.random(-1,1)*self.Damage,math.random(-1,1)*self.Damage,math.random(-1,1)*self.Damage))
					end
					if v:GetClass() == "prop_physics" then
						local phys = v:GetPhysicsObject()
						if phys != nil && phys != NULL then
							phys:ApplyForceOffset(self:GetForward()*1800,Vector(math.random(-1,1),math.random(-1,1),math.random(-1,1)))
						end
					end
					hit = true
				end
			end
		end
		if hit == false then
			if randomsound == 1 then
	      		self:EmitSound( self.attackmiss1)
			elseif randomsound == 2 then
	      		self:EmitSound( self.attackmiss2)
			elseif randomsound == 3 then
	      		self:EmitSound( self.attackmiss3)
			end
		else
			//make the sound
			if randomsound == 1 then
	      		self:EmitSound( self.attack1,350,math.random(80,120))
			elseif randomsound == 2 then
	      		self:EmitSound( self.attack2,350,math.random(80,120))
			elseif randomsound == 3 then
	      		self:EmitSound( self.attack3,350,math.random(80,120))
			end
		end
		timer.Create( "melee_done_timer" .. self.Entity:EntIndex( ), 0.25, 1, setmeleefalse )
	end
		if self:GetEnemy() != nil then
		if self:GetEnemy():GetPos():Distance(self:GetPos()) < 220 then
		self:SetColor( Color (0, 0, 0, math.random(0,255)) )
		self:SetRenderMode( 1 )
		else
		self:SetColor(Color (0,0,0,0))
		self:SetRenderMode( 1 )
		end
	else
		self:SetColor(Color (0,0,0,0))
		self:SetRenderMode( 1 )
	end
        //---------------

    if GetConVarNumber("ai_disabled") == 0 then
		
		if self:GetEnemy() != nil then
		self:UpdateEnemyMemory(self:GetEnemy(),self:GetEnemy():GetPos())
		end

		local randomteleport = math.random(1,320)
		if randomteleport == 1 then
			local subrandom = math.random(1,8)
			if subrandom == 1 && self:GetEnemy() != nil && util.IsInWorld(self:GetEnemy():GetPos() + self:GetEnemy():GetForward() * 100) then
			self.teleportPos = self:GetEnemy():GetPos() + self:GetEnemy():GetForward() * 100
			elseif subrandom == 2 then
			self.teleportPos = self.startPos
			else
			self.teleportPos = self:GetPos()
			end
		end
		
		//make the sound
		local randomsound = math.random(1,240)
		if randomsound == 1 then
	      	self:EmitSound( self.idle1,350,math.random(80,120))
		elseif randomsound == 2 then
	      	self:EmitSound( self.idle2,350,math.random(80,120))
		elseif randomsound == 3 then
	      	self:EmitSound( self.idle3,350,math.random(80,120))
		elseif randomsound == 4 then
	      	self:EmitSound( self.idle4,350,math.random(80,120))
		end

		//print( "Think start" );
		//Get all the npc's and other entities.
		local enttable = ents.FindByClass("npc_*")
		local monstertable = ents.FindByClass("monster_*")
		table.Add(monstertable,enttable)//merge

		//sort through each ent.
		for _, x in pairs(monstertable) do
		
			if (x:GetClass() != self:GetClass() && x:GetClass() != "npc_grenade_frag" && x:IsNPC()) then
				x:AddEntityRelationship( self, 1, 10 )
			end
		end

		if self.TakingCover == false then
			//if(math.random(1,20) == 1) then
				self:FindCloseEnemies()//get guys close to me
			//end
		end//Hit them.
		
		if self:GetEnemy() != nil then
				// && self:GetPos():Distance(self:GetEnemy():GetPos()) > self.MinLeapDistance 
				if math.random(1,15) == 1 && self:GetPos():Distance(self:GetEnemy():GetPos()) < self.LeapDistance && self.Leaps == true && self.Leaping == false then
					self:SetSchedule(SCHED_RANGE_ATTACK1 )
					self.Leaping = true
					local enemypos = self:GetEnemy():GetPos()
					//make sure we don't jump into the ground.
					if enemypos.z < self:GetPos().z then
						enemypos.z = self:GetPos().z
					end
					if math.random(1,2) == 1 then
  					self:SetVelocity( (enemypos-self:GetPos() + Vector(0,0,50)):GetNormalized() * self.LeapSpeed )
					else
  					self:SetVelocity( self:GetForward() * self.LeapSpeed + Vector(0,0,60) )
					end
					timer.Simple(0.5,function() setmeleefalse() end)
				end
				if (self:GetEnemy():GetPos():Distance(self:GetPos()) < 70) || self:HasPropInFrontOfMe() then
					if self.MeleeAttacking == false then
						if self.Leaping == false then
							self:SetSchedule( SCHED_MELEE_ATTACK1 )
						else
							self:EmitSound( self.attackleap)
							self:SetLocalVelocity( Vector( 0, 0, 0 ) )
						end
						timer.Create( "melee_attack_timer" .. self.Entity:EntIndex( ), 0.25, 1, Attack_Melee )
						self.MeleeAttacking = true;
					end
				end
		else
			self.MeleeAttacking = false
			self:FindEnemyDan()
		end

		local friends = ents.FindByClass("npc_xenomorph")
		for _, x in pairs(friends) do
		x:AddEntityRelationship( self, 3, 10 )
		end

		local friends = ents.FindByClass("npc_drone_xenomorph")
		for _, x in pairs(friends) do
		x:AddEntityRelationship( self, 3, 10 )
		end

		local friends = ents.FindByClass("npc_facehugger")
		for _, x in pairs(friends) do
		x:AddEntityRelationship( self, 3, 10 )
		end

    end
    //-----------------

end

function ENT:SelectSchedule()
	if self:GetEnemy() != NULL && self:GetEnemy() != nil then
	if self:GetEnemy():GetPos():Distance(self:GetPos()) > 1750 then
		self:SetEnemy(NULL)
	end
	end
	
	if self.Leaping == true then
		self:SetSchedule(SCHED_RANGE_ATTACK1 )
		return
	end

	if self.Alerted == true && self:GetEnemy() != NULL && self:GetEnemy() != nil && !self:HasCondition(27) then
			self:UpdateEnemyMemory(self:GetEnemy(),self:GetEnemy():GetPos())
			self:SetSchedule(SCHED_CHASE_ENEMY)
			self.Chasing = true
	elseif (self.Alerted == true || math.random(1,8) == 1) then
		self:SetSchedule(SCHED_CHASE_ENEMY_FAILED)
		self.Alerted = false
	else
		self:SetSchedule(SCHED_RUN_RANDOM)
	end
end

/*
function ENT:FindNearestLight()
	for i=1,10 do
		local enttable = ents.FindInSphere(self:GetPos(),i*500)
		for _,v in pairs(enttable) do
			if v:GetClass() == "light" then
				return v
			end
		end
	end
end

function ENT:FindNearestEnt()
	for i=1,10 do
		local enttable = ents.FindInSphere(self:GetPos(),i*500)
		for _,v in pairs(enttable) do
			//if v:GetClass() == "light" then
			if v != self then
			return v
			end
		end
	end

function ENT:FindEnviromentLight()
	local sun = ents.FindByName("light_environment")
	for _,i in pairs(sun) do
		return i
	end
end
*/

function ENT:OnTakeDamage(dmg)
   if math.random(1,3) == 1 then
		self:SetPos(self.teleportPos)
		self:EmitSound( "ambient/wind/wind_moan1.wav",350,math.random(80,120))
		return
   end
   local c = self:GetColor()
   local r,g,b,a = c.r, c.g, c.b, c.a
   if a < 100 then -- do nothing if our alpha value is less than nominal.
		return
   end
   if (self.TakingCover == false) && self.Flinches == true then
   	self:SetSchedule(SCHED_SMALL_FLINCH)//
   end 
   if self.Bleeds == true then
	self:SpawnBlood(dmg)
   end
   self:SetHealth(self:Health() - dmg:GetDamage())
   if math.random(4) == 1 then
	local sound_seed = math.random(1,7)
	if sound_seed == 1 then
	self:EmitSound( self.hurt1,350,math.random(80,120))
	elseif sound_seed == 2 then
	self:EmitSound( self.hurt2,350,math.random(80,120))
	elseif sound_seed == 3 then
	self:EmitSound( self.hurt3,350,math.random(80,120))
	end	
   end
   if dmg:GetAttacker():GetClass() != self:GetClass() && math.random(1,7) == 1 then
   	self:ResetEnemy()
   	self:AddEntityRelationship( dmg:GetAttacker(), 1, 10 )
   	self:SetEnemy(dmg:GetAttacker())
	self:SetSchedule(SCHED_CHASE_ENEMY)
	self.Chasing = true
   end
   if self:Health() <= 0 && !self.dead then //run on death
	self.dead = true;
	self:KilledDan()
   end
end

function ENT:FindEnemyDan()
	local MyNearbyTargets = ents.FindInCone(self:GetPos(),self:GetForward(),1750,45)
	
	for k,v in pairs(MyNearbyTargets) do
	    if (v:IsPlayer() && GetConVarNumber("ai_ignoreplayers") == 0) then
		self:ResetEnemy()
   		self:AddEntityRelationship( v, 1, 10 )
	      	self:SetEnemy(v)
		self:UpdateEnemyMemory(v,v:GetPos())
		local distance = self:GetPos():Distance(v:GetPos())
	      	local randomsound = math.random(1,5)
		if self.Alerted == false then
			if randomsound == 1 then
	      		self:EmitSound( self.alert1,350,math.random(80,120))
			elseif randomsound == 2 then
	      		self:EmitSound( self.alert2,350,math.random(80,120))
			elseif randomsound == 3 then
	      		self:EmitSound( self.alert3,350,math.random(80,120))
			end
		end
		self.Alerted = true
	      	return
	    end
	end
	//if ClosestDistance == 4000 then
	//self:SetEnemy(NULL)
	//end
end


function ENT:ResetEnemy()
	local enttable = ents.FindByClass("npc_*")
	local monstertable = ents.FindByClass("monster_*")
	table.Add(monstertable,enttable)//merge

	//sort through each ent.
	for _, x in pairs(monstertable) do
		//print(x)
		if (x:GetClass() != self:GetClass()) then
			self:AddEntityRelationship( x, 2, 10 )
		end
	end
	self:AddRelationship("player D_NU 10")
end


function ENT:FindCloseEnemies()
	local MyNearbyTargets = ents.FindInCone(self:GetPos(),self:GetForward(),250,45)
	//local ClosestDistance = 3000
	for k,v in pairs(MyNearbyTargets) do
	    if v:Disposition(self) == 1 || (v:IsPlayer() && GetConVarNumber("ai_ignoreplayers") == 0) then
		

		self:ResetEnemy()
   		self:AddEntityRelationship( v, 1, 10 )
	      	self:SetEnemy(v)
		
		self.Alerted = true
	      	return
	    end
	end
end


function ENT:HasLOS()
	if self:GetEnemy() != nil then
	//local shootpos = self:GetAimVector()*(self:GetPos():Distance(self:GetEnemy():GetPos())) + self:GetPos()
	//local shootpos = self:GetEnemy():GetPos()
	local tracedata = {}

	tracedata.start = self:GetPos()
	tracedata.endpos = self:GetEnemy():GetPos()
	tracedata.filter = self

	local trace = util.TraceLine(tracedata)
	if trace.HitWorld == false then
		
		return true
	else 
		return false
	end
	end
	
	return false
end


function ENT:SpawnBlood(dmg)
   if self.AcidBlood then
	local entstoattack = ents.FindInSphere(self:GetPos(),75)
	for _,v in pairs(entstoattack) do
		if ( (v:IsNPC() || ( v:IsPlayer() && v:Alive())) && (v != self) && (v:GetClass() != "npc_drone_xenomorph") && (v:GetClass() != self:GetClass()) || (v:GetClass() == "prop_physics")) && v.AcidBlood != true then
			v:TakeDamage( 3, self ) 
		end
	self:EmitSound( "ambient/wind/wind_moan1.wav" ,350,math.random(80,120))
	end
   end
   if (self.Bleeds == true) then
   	//local bloodeffect = ents.Create( "info_particle_system" )
	//if self.BleedsRed == true then
   	//	bloodeffect:SetKeyValue( "effect_name", "blood_impact_red_01" )
	//else
	//	bloodeffect:SetKeyValue( "effect_name", "blood_impact_yellow_01")
	//end
    //    bloodeffect:SetPos( dmg:GetDamagePosition() ) 
	//bloodeffect:Spawn()
	//bloodeffect:Activate() 
	//bloodeffect:Fire( "Start", "", 0 )
	//bloodeffect:Fire( "Kill", "", 0.1 )
   end
   
end

function ENT:KilledDan()
	/*I Took some of silverlan's code for ragdolling, cause I didn't want to recode it :P*/
	//emit cry of death
	local deathseed = math.random(1,3)
	if     deathseed == 1 then
	  self:EmitSound( self.die1,350,math.random(80,120))
	elseif deathseed == 2 then
	  self:EmitSound( self.die2,350,math.random(80,120))
	elseif deathseed == 3 then
	  self:EmitSound( self.die3,350,math.random(80,120))
	end

	//create ragdoll
	local ragdoll = ents.Create( "prop_ragdoll" )
	ragdoll:SetModel( self:GetModel() )
	ragdoll:SetPos( self:GetPos() )
	ragdoll:SetAngles( self:GetAngles() )
	ragdoll:Spawn()
	ragdoll:SetSkin( self:GetSkin() )
	ragdoll:SetColor( self:GetColor() )
	local phys = ragdoll:GetPhysicsObject()
	if phys != nil then
		phys:EnableGravity(false)
	end
	
	//my code
	undo.ReplaceEntity(self,ragdoll)
	cleanup.ReplaceEntity(self,ragdoll)

	//ignight ragdoll if on fire.
	if self:IsOnFire() then ragdoll:Ignite( math.Rand( 8, 10 ), 0 ) end

	//position bones the same way.
        for i=1,128 do
		local bone = ragdoll:GetPhysicsObjectNum( i )
		if IsValid( bone ) then
			local bonepos, boneang = self:GetBonePosition( ragdoll:TranslatePhysBoneToBone( i ) )
			bone:SetPos( bonepos )
			bone:SetAngles( boneang )
		end
	end
	if( GetConVarNumber("ai_keepragdolls") == 0 ) then
		ragdoll:SetCollisionGroup( 1 )//COLLISION_GROUP_DEBRIS )
		ragdoll:Fire( "FadeAndRemove", "", 0)
	end
	self:Remove()
end
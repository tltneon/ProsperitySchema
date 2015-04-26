-----------------------------------------------------------------------------------
--------- Nextbot Cat v0.3 : By Jeezy
--------- *************************************************************************
--------- Description: This is one of my very first nextbots that I put a lot of time into
--------- some of my methods may be hacky, or inefficient, although it does work.
--------- This is a work in progress, I'm still getting the hang of NextBots.
--------- *************************************************************************
--------- Note: If you're wondering why I'm not setting the activity for the animations it's
--------- because I was having difficulties getting it to work smoothly. So I ended up just
--------- setting the sequences when necessary.

AddCSLuaFile()

ENT.Base 			= "base_nextbot"
ENT.Spawnable		= false -- It's actually spawnable via the NPC menu, if this was enabled it'd be in the entities menu too.
ENT.MeowSounds = { "jeezy/animals/cat/meow01.wav", "jeezy/animals/cat/meow02.wav" }
ENT.PainSounds = { "jeezy/animals/cat/pain01.wav", "jeezy/animals/cat/pain02.wav" }
ENT.RunMultiplier = 2.5 -- The multiplier that will be applied to the movespeed convar when running.
ENT.RndHungerMulti = 5 -- The offset of the hunger change, the larger the number, the bigger the potential offset.
ENT.DefaultBounds = { Vector( -4, -4, 0 ), Vector( 4, 4, 32 ) } -- Default collision bounds, for reseting the collision bounds when changed to 0.

-- AI Status Enums
ENT.CAT_IDLE = 1
ENT.CAT_ROAMING = 2
ENT.CAT_FOLLOWING = 3
ENT.CAT_SITTING = 4
ENT.CAT_FLEEING = 5
ENT.CAT_POUNCING = 6
ENT.CAT_LAYINGDOWN = 7
ENT.CAT_FRENZY = 8
ENT.CAT_FOODSEARCH = 9
ENT.CAT_WATERSEARCH = 10

-- Speed Enums
ENT.CAT_SPEED_WALK  = 1
ENT.CAT_SPEED_RUN = 2

-- Cat Statistics & Info
ENT.CAT_LIFE = 1
ENT.CAT_HUNGER = 2
ENT.CAT_AGE = 3
ENT.CAT_HYDRATION = 4
ENT.CAT_FATIGUE = 5
ENT.CAT_FOLLOWTARGET = 6

ENT.CAT_STARVING = 40
ENT.CAT_DEHYDRATED = 50
ENT.CAT_EXHAUSTED = 70

-- Easy sequence access, can use the AI Status to determine which sequence to play.
ENT.Cat_Anims = { }
ENT.Cat_Anims[ENT.CAT_IDLE] = { "idle01", "idle02", "idle03" }
ENT.Cat_Anims[ENT.CAT_ROAMING] = { "walk" }
ENT.Cat_Anims[ENT.CAT_FOLLOWING] = { "run" }
ENT.Cat_Anims[ENT.CAT_FLEEING] = { "run" }
ENT.Cat_Anims[ENT.CAT_SITTING] = { "sitting01", "sitting02" }
ENT.Cat_Anims[ENT.CAT_LAYINGDOWN] = { "layingdown" }
ENT.Cat_Anims[ENT.CAT_FRENZY] = { "run" }

function ENT:Initialize( )
	self:SetModel( "models/jeezy/animals/siamese_cat/siamese_cat.mdl" )
	self:SetSkin( math.random( 0, 9 ) )
	self:SetHealth( 100 )
	self:SetMaxHealth( 100 )
	self:SetCollisionBounds( self.DefaultBounds[1], self.DefaultBounds[2] )
	self:SetModelScale( 0.5, 0 ) -- The smallest size, a kitten.
	self:SetBodygroup( 1, 0 ) -- Hide the collar if not hidden for some reason.
	self:SetBodygroup( 2, math.random( 0, 2 ) )

	-- Statistics Initiation
	self:SetStat( self.CAT_LIFE, self:Health( ) ) -- Sets the clientside health variable.
	self:SetStat( self.CAT_AGE, 0 ) -- Sets the age, for server and client.
	self:SetStat( self.CAT_HUNGER, 100 ) -- Sets the hunger, for server and client.
	self:SetStat( self.CAT_HYDRATION, 100 )
	self:SetStat( self.CAT_FATIGUE, 0 )
	self:SetStat( self.CAT_FOLLOWTARGET, nil )
	timer.Simple( 2, function( ) if ( IsValid( self ) ) then self:RefreshStats( ) end end ) -- Variable don't appear right away serverside oddly.
	-- Control Variables
	local hungerRate = GetConVarNumber( "npc_siamesecat_hungerrate" )
	local rndHungerRate = math.random( -hungerRate/self.RndHungerMulti, hungerRate/self.RndHungerMulti )
	self.nextGrowth = CurTime( ) + GetConVarNumber( "npc_siamesecat_agerate" )
	self.nextHungerTick = CurTime( ) + math.Clamp( hungerRate + rndHungerRate, 1, hungerRate + hungerRate/self.RndHungerMulti )
	self.nextFatigueTick = CurTime( ) + GetConVarNumber( "npc_siamesecat_fatiguerate" ) + math.random( 4, 16 )
	self.nextDehydrateTick = CurTime( ) + GetConVarNumber( "npc_siamesecat_dehydraterate" ) + math.random( 4, 16 )

	self.seqOverride = nil -- Used to override the sequences played by the think hook.
	self.aiStatus = self.CAT_IDLE -- Sets the cat's status to idle.
	self.nextUse = CurTime( ) -- Variable used for cooldown on the cat's use action.
	self.cancelMove = false -- Variable used to escape the overriden MoveToPos function.
	self.nextBlinkTime = CurTime( ) + 2
end

function ENT:OnInjured( dmgInfo )
	if not ( tobool( GetConVarNumber( "npc_siamesecat_enabledeath" ) ) ) then -- If death is disabled, scale damage to 0.
		dmgInfo:ScaleDamage( 0 )
	end

	local sndChance = math.random( 1, 5 )
	if ( sndChance >= 3 ) then -- Don't always play the hurt sound.
		self:EmitSound( self.PainSounds[math.random( #self.PainSounds )], GetConVarNumber( "npc_siamesecat_soundvolume" ), math.random( 100, 200 ) )
	end

	if ( self:GetStat( self.CAT_FOLLOWTARGET ) == dmgInfo:GetAttacker( ) ) then -- If the cat was following the attacker, cease it.
		self:SetStat( self.CAT_FOLLOWTARGET, nil )
		self:SetBodygroup( 1, 0 ) -- Hide the collar again.
	end

	self:SetStat( self.CAT_LIFE, self:Health( ) - dmgInfo:GetDamage( ) ) -- Sends new health to client.
	if ( dmgInfo:GetAttacker( ) == self or self.aiStatus == self.CAT_FOLLOWING ) then return end
	self.cancelMove = true -- Escape the MoveToPos function if it's occuring.
	self.skipSequence = false -- Don't skip the next sequence.
	self:SetNextTask( self.CAT_FLEEING ) -- Sets the cat's next task to flee.
end

function ENT:OnKilled( dmgInfo )
	self:SetModelScale( 1, 0 ) -- Seems to help the ragdoll not get stuck in the ground when the cat is killed while small.
	self:EmitSound( self.PainSounds[math.random( #self.PainSounds )], GetConVarNumber( "npc_siamesecat_soundvolume" ), math.random( 100, 200 ) )
	self:TriggerParticles( "sprites/jeezy/skull_and_crossbones" )
	self:BecomeRagdoll( dmgInfo )
end

function ENT:OnLandOnGround( )
	-- When the cat lands on the ground, disable the think hook sequences override.
	if ( self.seqOverride ) then
		self.seqOverride = nil
		self:SetCycle( 0 )
		self:SetPlaybackRate( 0.25 )
		self:SetSequence( "land" )
	end
end

function ENT:OnLeaveGround( )
	-- When the cat leaves the ground, override the think hook sequences.
	self.seqOverride = "airborne"
end

--------------------------------------------------------------------------
--- Instead of using the ACT enums for the animations, I just used
--- the sequences directly, was having trouble getting it to work otherwise.
function ENT:Think( )
	if ( self.nextBlinkTime < CurTime( ) ) then
		self:SetFlex( 0.1, 0, 0.25 )
		self:SetFlex( 0.2, 0, 0.5 )
		self:SetFlex( 0.3, 0, 0.75 )
		self:SetFlex( 0.4, 0, 1 )
		self:SetFlex( 0.5, 0, 0.75 )
		self:SetFlex( 0.6, 0, 0.5 )
		self:SetFlex( 0.7, 0, 0.25 )
		self:SetFlex( 0.8, 0, 0 )
		self.nextBlinkTime = CurTime( ) + 5 + ( math.random( -2, 4 ) )
	end
	if ( self.seqOverride ) then -- If the override is enabled, set the sequence and return.
		self:SetPlaybackRate( 1 )
		self:SetSequence( self.seqOverride )
		return
	end
end

function ENT:Use( activator, caller, type, val )
	if ( self.nextUse > CurTime( ) ) then return end -- If next use isn't now, return.

	if ( activator:KeyDown( IN_RELOAD ) ) then -- If holding R after pressing E, push the cat.
		self:PushCat( )
		self.nextUse = CurTime( ) + 2 -- Delay the next use.
		return
	end

	if ( IsValid( self:GetStat( self.CAT_FOLLOWTARGET ) ) and self:GetStat( self.CAT_FOLLOWTARGET ) == activator ) then -- If following, stop.
		self:TriggerParticles( "sprites/jeezy/brokenheart" )
		self:SetStat( self.CAT_FOLLOWTARGET, nil )
		self.aiStatus = self.CAT_ROAMING
		self:EmitSound( self.PainSounds[math.random( #self.PainSounds )], GetConVarNumber( "npc_siamesecat_soundvolume" ), math.random( 100, 200 ) )
		self.nextUse = CurTime( ) + 2
		self:SetBodygroup( 1, 0 ) -- Hide the collar.
		return
	end

	--if ( self.aiStatus == self.CAT_FOLLOWING or IsValid( self:GetFollowTarget( ) ) ) then return end -- If the cat's already following somebody, return.
	
	self:TriggerParticles( "sprites/jeezy/hearts" )
	activator:EmitSound( "jeezy/misc/whistle01.wav", GetConVarNumber( "npc_siamesecat_soundvolume" ), math.random( 85, 100 ) )
	self:SetStat( self.CAT_FOLLOWTARGET, activator ) -- Sets the target for the cat to follow.
	self:SetNextTask( self.CAT_FOLLOWING ) -- Queues the cat to follow.
	self.nextUse = CurTime( ) + 2
	self:SetBodygroup( 1, math.random( 1, 2 ) ) -- Show the collar.
end

function ENT:RunBehaviour( )
	while ( true ) do
		local rndChance = math.random( 1, 10 ) -- Random change determining many factors of the actions below.
		-- Check if the cat is exhausted.
		if ( CurTime( ) > self.nextFatigueTick and self.aiStatus ~= self.CAT_LAYINGDOWN ) then
			self:SetStat( self.CAT_FATIGUE, self:GetStat( self.CAT_FATIGUE ) + math.random( 8, 16 ) )
			self.nextFatigueTick = CurTime( ) + GetConVarNumber( "npc_siamesecat_fatiguerate" ) + math.random( 4, 16 )
		end
		if ( self:GetStat( self.CAT_FATIGUE ) > self.CAT_EXHAUSTED and !( self:GetStat( self.CAT_HUNGER ) <= self.CAT_STARVING ) and !( self:GetStat( self.CAT_HYDRATION ) <= self.CAT_DEHYDRATED ) and self.aiStatus ~= self.CAT_SITTING and self.aiStatus ~= self.CAT_LAYINGDOWN  ) then
			self:SetNextTask( self.CAT_SITTING ) -- Don't sit if you're starving or dehydrating..
		end
		-- Check if the cat is dehydrated.
		if ( CurTime( ) > self.nextDehydrateTick ) then
			self:SetStat( self.CAT_HYDRATION, self:GetStat( self.CAT_HYDRATION ) - 15 )
			if ( self:GetStat( self.CAT_HYDRATION ) <= 0 and tobool( GetConVarNumber( "npc_siamesecat_enabledeath" ) ) ) then
				self:TakeDamage( self:GetMaxHealth( ) * 0.1, self, nil )
			end
			self.nextDehydrateTick = CurTime( ) + GetConVarNumber( "npc_siamesecat_dehydraterate" ) + math.random( 4, 16 )
		end
		if ( self:GetStat( self.CAT_HYDRATION ) < self.CAT_DEHYDRATED ) then
			if ( self:FindClosestResource( "ent_waterbowl" ) ) then
				self:StandUp( ) -- Smoothly stand up the cat.
				self:SetNextTask( self.CAT_WATERSEARCH )
			else
				self:TriggerParticles( "sprites/jeezy/water_bottle" )
			end
		end
		-- Check if the cat is starving.
		if ( CurTime( ) > self.nextHungerTick ) then
			self:SetStat( self.CAT_HUNGER, self:GetStat( self.CAT_HUNGER ) - 15 )
			if ( self:GetStat( self.CAT_HUNGER ) <= 0 and tobool( GetConVarNumber( "npc_siamesecat_enabledeath" ) ) ) then
				-- If death is disabled, don't take any damage.
				self:TakeDamage( self:GetMaxHealth( ), self, nil )
			end
			-- Varying hunger rate.
			local hungerRate = GetConVarNumber( "npc_siamesecat_hungerrate" )
			local rndHungerRate = math.random( -hungerRate/self.RndHungerMulti, hungerRate/self.RndHungerMulti )
			self.nextHungerTick = CurTime( ) + math.Clamp( hungerRate + rndHungerRate, 1, hungerRate + hungerRate/self.RndHungerMulti )
		end
		if ( self:GetStat( self.CAT_HUNGER ) < self.CAT_STARVING ) then
			if ( self:FindClosestResource( "ent_catfood" ) ) then -- Make sure there's still food on the map.
				self:StandUp( )
				self.aiStatus = self.CAT_FOODSEARCH
			else
				self:TriggerParticles( "sprites/jeezy/drumstick_hunger" )
			end
		end
		-- Check if the cat should grow.
		if ( CurTime( ) > self.nextGrowth ) then
			local nextGrowthMulti = 1 -- Used to potentially double the next age tick, when the cat is fully grown.
			self:SetStat( self.CAT_AGE, math.Clamp( self:GetStat( self.CAT_AGE ) + 1, 0, GetConVarNumber( "npc_siamesecat_maxage" ) ) )
			if ( self:GetStat( self.CAT_AGE ) >= GetConVarNumber( "npc_siamesecat_maxage" ) ) then
				if ( rndChance == 1 ) then -- One out of ten chance to die.
					self:TakeDamage( self:GetMaxHealth( ), self, nil )
				else
					nextGrowthMulti = math.random( 1, 2 ) -- Either use the initial value, or double it.
				end
			end
			self:SetModelScale( 0.5 + ( 0.1 * self:GetStat( self.CAT_AGE ) ), 1 ) -- Size changes depending on the age.
			self.nextGrowth = CurTime( ) + ( GetConVarNumber( "npc_siamesecat_agerate" ) * nextGrowthMulti )	
		end
		if ( self.nextTask ) then -- If there's a task queued, set it.
			self.aiStatus = self.nextTask
			self.nextTask = nil
		end
		if ( self.aiStatus == self.CAT_IDLE ) then
			self:PlaySequenceAndWait( self:FetchRandomAnim( self.CAT_IDLE ), 1 )
			if ( IsValid( self:GetStat( self.CAT_FOLLOWTARGET ) ) ) then
				self.aiStatus = self.CAT_FOLLOWING
				continue
			end
			if ( rndChance >= 1 and rndChance < 3 ) then
				self:SetAIStatus( self.CAT_POUNCING )
			elseif ( rndChance >= 3 and rndChance < 7 ) then
				self:SetAIStatus( self.CAT_ROAMING )
			elseif ( rndChance >= 7 and rndChance < 9 ) then
				self:PlaySequenceAndWait( "standtosit", 0.8 )
				self.aiStatus = self.CAT_SITTING
			elseif ( rndChance >= 9 ) then
				self:SetAIStatus( self.CAT_FRENZY )
			end
		elseif ( self.aiStatus == self.CAT_SITTING ) then
			self:PlaySequenceAndWait( self:FetchRandomAnim( self.CAT_SITTING ), 1 )
			if ( rndChance > 6 and self:GetStat( self.CAT_FATIGUE ) < self.CAT_EXHAUSTED  ) then
				self:PlaySequenceAndWait( "sittostand", 0.5 )
				self:SetAIStatus( self.CAT_IDLE )
			elseif ( rndChance < 4 or self:GetStat( self.CAT_FATIGUE ) >= self.CAT_EXHAUSTED ) then
				self:PlaySequenceAndWait( "sittolaydown", 0.5 )
				self:SetAIStatus( self.CAT_LAYINGDOWN )
			end
		elseif ( self.aiStatus == self.CAT_LAYINGDOWN ) then
			self:PlaySequenceAndWait( "layingdown", 1 )
			self:TriggerParticles( "sprites/jeezy/sleep" )
			self:SetStat( self.CAT_FATIGUE, math.Clamp( self:GetStat( self.CAT_FATIGUE ) - math.random( 6, 12 ), 0, 100 ) )
			if ( rndChance < 2 and self:GetStat( self.CAT_FATIGUE ) < self.CAT_EXHAUSTED/4 ) then
				self:PlaySequenceAndWait( "laydowntosit", 0.75 )
				if ( self:GetStat( self.CAT_FOLLOWTARGET ) ) then
					self:PlaySequenceAndWait( "sittostand", 0.75 )
					self.aiStatus = self.CAT_FOLLOWING -- Go back to following if the cat was.
				else
					self:SetAIStatus( self.CAT_SITTING )
				end
			end
		
		elseif ( self.aiStatus == self.CAT_FLEEING ) then
			self:StandUp( false )
			self:SetSpeed( self.CAT_SPEED_RUN )
			--self:PlaySequenceAndWait( self.Cat_Anims[ self.aiStatus ][1], 1.5 )
			self:SetPlaybackRate( 1.5 )
			self:SetSequence( "run" )
			self:Flee( 10 ) -- Makes the cat flee, the argument determines how long it'll attempt to complete the path.
			self:SetAIStatus( self.CAT_IDLE ) -- Revert to idle after fleeing.
		
		elseif ( self.aiStatus == self.CAT_POUNCING ) then
			local goalPos = self:GetPos( ) + Vector( math.random( -2, 2 ) * 100, math.random( -2, 2 ) * 100, 0 )   
			self:JumpTowards( goalPos, { maxage = 2 } ) -- Modified MoveToPos function so the cat jumps towards a position rather than straight up.
		
		elseif ( self.aiStatus == self.CAT_ROAMING ) then
			self:SetSpeed( self.CAT_SPEED_WALK ) -- Sets the speed to walking.
			self:SetPlaybackRate( 1 )
			self:SetSequence( "walk" )
			self:WalkToRandom( self:GetPos( ), -5, 5, 0, 0, 50, 100, 5 )
			self:EmitSound( self.MeowSounds[math.random( #self.MeowSounds )], GetConVarNumber( "npc_siamesecat_soundvolume" ), math.random( 45, 200 ) )
			self:SetAIStatus( self.CAT_IDLE )
			self:PlaySequenceAndWait( self:FetchRandomAnim( self.CAT_IDLE ), 0.5 )

		elseif ( self.aiStatus == self.CAT_FRENZY ) then
			self:SetSpeed( self.CAT_SPEED_RUN ) -- Sets the speed to running.
			self:SetPlaybackRate( 1 )
			self:SetSequence( "run" )
			self:TriggerParticles( "sprites/jeezy/confused" )
			self:WalkToRandom( self:GetPos( ), -10, 10, 0, 0, 100, 100, 2.5, GetConVarNumber( "npc_siamesecat_movespeed" ) * ( self.RunMultiplier * 1.25 ) )
			self:EmitSound( self.MeowSounds[math.random( #self.MeowSounds )], GetConVarNumber( "npc_siamesecat_soundvolume" ), math.random( 150, 200 ) )
			self:PlaySequenceAndWait( self:FetchRandomAnim( self.CAT_IDLE ), 0.5 )
			if ( rndChance > 4 ) then
				self:SetAIStatus( self.CAT_IDLE )
				self:PlaySequenceAndWait( self:FetchRandomAnim( self.CAT_IDLE ), 0.5 )
			end

		elseif ( self.aiStatus == self.CAT_FOODSEARCH ) then
			self:TriggerParticles( "sprites/jeezy/drumstick_hunger" )
			self:SetSpeed( self.CAT_SPEED_RUN ) -- Sets the speed to running.
			self:SetPlaybackRate( 1 )
			self:SetSequence( "run" )
			local nearestFood = self:FindClosestResource( "ent_catfood" ) -- Find the closest food.
			if not ( nearestFood ) then -- If cannot find food, return to roaming.
				self.aiStatus = self.CAT_ROAMING
			else
				-- If there is food, set the goal tolerance depending on the model scale.
				local goalTolerance = math.Clamp( ( 32 * ( self:GetModelScale( ) ) ) * 0.8, 0, 32 )
				if not ( nearestFood.curUser ) then nearestFood:InitiateUserTimeout( 15 ) end -- If the foods not being used, initiate timeout.
				nearestFood.curUser = self -- Sets the foodbowl's user to the cat.
				self:MoveNearTarget( nearestFood, goalTolerance, { maxage = 5, tolerance = goalTolerance }, 100, true )
				self.targetFood = nearestFood -- The food it's looking for.
				if ( IsValid( self.targetFood ) and self:GetRangeTo( nearestFood:GetPos( ) ) <= ( goalTolerance * 1.1 ) ) then
					self.foundEnt = nearestFood -- The food it successfully reached.
					self:PlaySequenceAndWait( "headdown", 1 ) -- Play eating animation.
					if ( IsValid( self.foundEnt ) ) then -- If the food is valid, execute the foodbowl's EatFood function.
						self.foundEnt:EatFood( self, 25 ) -- The second argument is the amount of hunger restored.
					end
					if ( self:GetStat( self.CAT_HUNGER ) > self.CAT_STARVING ) then -- If the cat's hunger is greater than 65, return to normal activities.
						if ( self:GetStat( self.CAT_FOLLOWTARGET ) ) then
							self.aiStatus = self.CAT_FOLLOWING -- Go back to following if the cat was.
						else
							self.aiStatus = self.CAT_ROAMING
						end
					end
				end
				self:PlaySequenceAndWait( self:FetchRandomAnim( self.CAT_IDLE ), 0.5 )
				self.foundEnt = nil -- Reset the cat's food variables to nil.
				self.targetFood = nil
			end

		elseif ( self.aiStatus == self.CAT_WATERSEARCH ) then
	 		self:TriggerParticles( "sprites/jeezy/water_bottle" )
	 		self:SetSpeed( self.CAT_SPEED_RUN )
	 		self:SetPlaybackRate( 1 )
	 		self:SetSequence( "run" )
	 		local nearestWater = self:FindClosestResource( "ent_waterbowl" )
	 		if not ( nearestWater ) then
	 			self.aiStatus = self.CAT_ROAMING
	 		else
				local goalTolerance = math.Clamp( ( 32 * ( self:GetModelScale( ) ) ) * 0.8, 0, 32 )
				if not ( nearestWater.curUser ) then nearestWater:InitiateUserTimeout( 15 ) end -- If the foods not being used, initiate timeout.
				nearestWater.curUser = self -- Sets the foodbowl's user to the cat.
				self:MoveNearTarget( nearestWater, goalTolerance, { maxage = 5, tolerance = goalTolerance }, 100, true )
				self.targetWater = nearestWater -- The food it's looking for.
				if ( IsValid( self.targetWater ) and self:GetRangeTo( nearestWater:GetPos( ) ) <= ( goalTolerance * 1.1 ) ) then
					self.foundEnt = nearestWater -- The food it successfully reached.
					self:PlaySequenceAndWait( "headdown", 1 ) -- Play eating animation.
					if ( IsValid( self.foundEnt ) ) then -- If the food is valid, execute the foodbowl's EatFood function.
						self.foundEnt:DrinkWater( self, 25 ) -- The second argument is the amount of hunger restored.
					end
					if ( self:GetStat( self.CAT_HYDRATION ) > self.CAT_DEHYDRATED ) then -- If the cat's hunger is greater than 65, return to normal activities.
						if ( self:GetStat( self.CAT_FOLLOWTARGET ) ) then
							self.aiStatus = self.CAT_FOLLOWING -- Go back to following if the cat was.
						else
							self.aiStatus = self.CAT_ROAMING
						end
					end
				end
				self:PlaySequenceAndWait( self:FetchRandomAnim( self.CAT_IDLE ), 0.5 )
				self.foundEnt = nil -- Reset the cat's food variables to nil.
				self.targetWater = nil
			end
		elseif ( self.aiStatus == self.CAT_FOLLOWING ) then
			if ( !IsValid( self:GetStat( self.CAT_FOLLOWTARGET ) ) or !self:GetStat( self.CAT_FOLLOWTARGET ):Alive( ) ) then -- If the the entity the cat was following is invalid or dead, revert to roaming.
				self.aiStatus = self.CAT_ROAMING
				self:SetBodygroup( 1, 0 )
			else
				self:SetSpeed( self.CAT_SPEED_RUN )
				self:SetPlaybackRate( 1 )
				self:SetSequence( "run" )
				self:MoveNearTarget( self:GetStat( self.CAT_FOLLOWTARGET ), 156, { maxage = 5, tolerance = 20 }, 100 )
				self:TriggerParticles( "sprites/jeezy/hearts" )
				self:EmitSound( self.MeowSounds[math.random( #self.MeowSounds )], GetConVarNumber( "npc_siamesecat_soundvolume" ), math.random( 100, 200 ) )
				self:PlaySequenceAndWait( self:FetchRandomAnim( self.CAT_IDLE ), 0.5 )
			end
		end
		/*if ( IsValid( self:GetStat( self.CAT_FOLLOWTARGET ) ) and self:GetStat( self.CAT_FOLLOWTARGET ) ) then
			self:SetNextTask( self.CAT_FOLLOWING )
		end*/
		coroutine.wait( 1 )
	end
end

function ENT:BehaveUpdate( fInterval )
	if ( !self.BehaveThread ) then return end
	if ( self.aiStatus == self.CAT_FOODSEARCH or self.aiStatus == self.CAT_WATERSEARCH ) then -- If the cats searching for food
		if ( IsValid( self.foundEnt ) ) then       -- and the cat successfully reached food,
			self.loco:FaceTowards( self.foundEnt:GetPos( ) ) -- face towards it.
		end
	end
	if ( self.loco:IsStuck( ) ) then
		self:PushCat( ) -- This doesn't really work, but when the cat gets stuck, 
	end                 -- attempt the PushCat function to try to unstuck the cat.
	local ok, message = coroutine.resume( self.BehaveThread )
	if ( ok == false ) then
		self.BehaveThread = nil
		Msg( self, "error: ", message, "\n" );
	end
end

--------------------------------------------------------------------------------------
------- Helper function for setting the speed of the cat.
function ENT:SetSpeed( enum )
	if ( enum == self.CAT_SPEED_WALK ) then
		self.loco:SetDesiredSpeed( GetConVarNumber( "npc_siamesecat_movespeed" ) )
		self.loco:SetAcceleration( 400 )
	elseif ( enum == self.CAT_SPEED_RUN ) then
		self.loco:SetDesiredSpeed( GetConVarNumber( "npc_siamesecat_movespeed" ) * self.RunMultiplier )
		self.loco:SetAcceleration( 400 )
	end
end

--------------------------------------------------------------------------------------
------- Use to make the cat properly stand up via animations..
function ENT:StandUp( toRoam )
	if ( self.aiStatus == self.CAT_LAYINGDOWN ) then
		self:PlaySequenceAndWait( "laydowntosit" )
		self:PlaySequenceAndWait( "sittostand" )
	elseif ( self.aiStatus == self.CAT_SITTING ) then
		self:PlaySequenceAndWait( "sittostand" )
	end
	if ( toRoam ) then
		self.aiStatus = self.CAT_ROAMING
	end
end

--------------------------------------------------------------------------------------
------- Used to attempt the unstuck the cat by disabling collision and jumping.
function ENT:PushCat( )
	if ( self.nextTask == self.CAT_POUNCING or self.aiStatus == self.CAT_POUNCING ) then return end -- If already jumping, escape.
	self.cancelMove = true -- Cancel potential ongoing MoveToPos function.
	self:SetCollisionBounds( Vector( 0, 0, 0 ), Vector( 0, 0, 0 ) ) -- Set the cat not to collide with anything, it is reset after the jump.
	self:SetNextTask( self.CAT_POUNCING )
	self.ignoreEntities = false
	self.skipSequence = true -- Skip the next sequence.
	self:EmitSound( "ambient/voices/citizen_punches2.wav", GetConVarNumber( "npc_siamesecat_soundvolume" ), math.random( 100, 200 ) )
	self:EmitSound( self.PainSounds[math.random( #self.PainSounds )], GetConVarNumber( "npc_siamesecat_soundvolume" ), math.random( 100, 200 ) ) 
end

--------------------------------------------------------------------------------------
------- Used to find the nearest food entity if any, and ensures it's not being used.
function ENT:FindClosestResource( class, checkUser )
	local resourceEnts = ents.FindByClass( class ) -- Find all catfood entities.
	if not ( #resourceEnts > 0 ) then return nil end -- If there are none, return.
	local distanceTable = { } -- The table for sorting all the entities by distance.
	for index, ent in ipairs ( resourceEnts ) do
		if ( IsValid( ent.curUser ) and checkUser ) then continue end -- If the foods being used, don't add it.
		table.insert( distanceTable, { resourceEnt = ent, distance = self:GetRangeTo( ent:GetPos( ) ) } )
	end
	table.SortByMember( distanceTable, "distance", true )
	if ( distanceTable and distanceTable[1] ) then -- If a index of 1 exists, return the food entity.
		return distanceTable[1].resourceEnt
	else
		return -- Return nothing.
	end
end

--------------------------------------------------------------------------------------
------- Used to find the nearest food entity if any, and ensures it's not being used.
function ENT:RefreshStats( )
	self:SetStat( self.CAT_LIFE, self:Health( ) ) -- Sets the clientside health variable.
	self:SetStat( self.CAT_AGE, self:GetStat( self.CAT_AGE ) ) -- Sets the age, for server and client.
	self:SetStat( self.CAT_HUNGER, self:GetStat( self.CAT_HUNGER ) ) -- Sets the hunger, for server and client.
	self:SetStat( self.CAT_HYDRATION, self:GetStat( self.CAT_HYDRATION ) )
	self:SetStat( self.CAT_FATIGUE, self:GetStat( self.CAT_FATIGUE ) )
	self:SetStat( self.CAT_FOLLOWTARGET, self:GetStat( self.CAT_FOLLOWTARGET ) )
end

--------------------------------------------------------------------------------------
------- This is to set delayed flexes, for example when blinking. 
------- Not the best way to do this, but it'll work for now.
function ENT:SetFlex( delay, id, weight )
	timer.Simple( delay, function( )
		if ( IsValid( self ) ) then
			self:SetFlexWeight( id, weight )
		end
	end )
end

--------------------------------------------------------------------------------------
------- Used for sending the particles to the client.
function ENT:TriggerParticles( sprite )
	net.Start( "CatNPCs_ReceiveData" ) 
		net.WriteString( "Particles" )
		net.WriteVector( self:GetPos( ) + ( Vector( 0, 0, 25 ) * self:GetModelScale( ) ) )
		net.WriteString( sprite )
	net.Send( player.GetAll( ) )
end

--------------------------------------------------------------------------------------
------- Restart the sequence once it ends
function ENT:DoCycles( )
	if ( self:GetCycle( ) == 1 ) then
		self:SetCycle( 0 )
	elseif ( self:GetCycle( ) == 1 ) then
		self:SetCycle( 1 )
	end
end

--------------------------------------------------------------------------------------
------- Set the next task the cat will do.
function ENT:SetNextTask( enum )
	self.nextTask = self.nextTask or nil
	if ( self.nextTask ) then return end
	self.nextTask = enum
end

--------------------------------------------------------------------------------------
------- Helper function for retrieving a random animation.
function ENT:FetchRandomAnim( enum ) 
	local randAnim = self.Cat_Anims[enum][math.random( #self.Cat_Anims[enum] )]
	return randAnim
end

--------------------------------------------------------------------------------------
------- Helper function to check if the sequence is already being played.
function ENT:IsSequenceActive( seq )
	local seqNum = self:GetSequence( )
	local seqName = self:GetSequenceName( seqNum )

	if ( seqName == seq ) then
		return true
	else
		return false
	end
end

--------------------------------------------------------------------------------------
------- This function did more previously, but removed those parts because they were no longe necessary.
------- I may add more to this function later on.
function ENT:SetAIStatus( status )
	self.aiStatus = status         -- I may add more to this function later on.
end

--------------------------------------------------------------------------------------
------- Just checks infront of the entity, used to check positions.
function ENT:IsEntityBlocking( filter, dist, ignoreWorld )
	local traceData = {}
	traceData.start = self:EyePos( )
	traceData.endpos = self:EyePos( ) + ( self:EyeAngles( ):Forward( ) * ( dist or 100 ) )
	traceData.filter = self
	local selTrace = util.TraceLine( traceData )
	local hitEnt = selTrace.Entity or nil
	if ( hitEnt:IsWorld( ) and ignoreWorld ) then
		hitEnt = nil
	end
	return hitEnt
end

--------------------------------------------------------------------------------------
------- Used when the cat is shot or damaged, the cat will flee.
function ENT:Flee( pathLife )
	local hidingSpot = self:FindSpot( "random", { type = 'hiding', radius = 5000 } ) -- Search for a hiding spot.
	
	self.loco:SetDesiredSpeed( GetConVarNumber( "npc_siamesecat_movespeed" ) * self.RunMultiplier )
	
	if not hidingSpot then -- If a hiding spot could not be found, go to a random position.
		self:WalkToRandom( self:GetPos( ), -25, 25, 0, 0, 50, 100, 10 )
		self:SetAIStatus( self.CAT_ROAMING )
		return
	end

	self:MoveToPos( hidingSpot, { maxage = pathLife } )
end

--------------------------------------------------------------------------------------
------- Used to find a valid position to walk to.
function ENT:WalkToRandom( selPos, minOffset, maxOffset, minStep, maxStep, maxDist, setTimeOut, pathLife, speed )
	local noPos = true
	local timeOut = 0 -- The timeout ensures there won't be an infinite loop.
	local isSearching = true

	while ( noPos and isSearching ) do
		selPos = selPos + Vector( math.Rand( minOffset, maxOffset ), math.Rand( minOffset, maxOffset ), math.Rand( minStep, maxStep ) ) * math.random( maxDist/2, maxDist )
		--self.loco:FaceTowards( selPos )

		if not ( IsValid( self:IsEntityBlocking( nil, 100, true ) ) ) then
			self:MoveToPos( selPos, { maxage = pathLife } )
			noPos = false
			isSearching = false
		end

		if ( timeOut < setTimeOut ) then
			timeOut = timeOut + 1
		else
			isSearching = false
			noPos = false
			return false
		end
	end

	return true
end

--------------------------------------------------------------------------------------
------- Used to move to a target, or near a target.
function ENT:MoveNearTarget( tar, dist, options, maxAttempt, toTarget )

	if ( !IsValid( tar ) ) then -- If there were too many attempts or the target is invalid, stop following.
		self:SetStat( self.CAT_FOLLOWTARGET, nil )
		self:SetBodygroup( 1, 0 )
		self.aiStatus = self.CAT_ROAMING
		return
	end

	local attemptPos = Vector( 0, 0, 0 )

	if ( toTarget ) then
		attemptPos = tar:GetPos( ) -- Go directly to the target, rather than around it.
	else
	 	attemptPos = tar:GetPos( ) + Vector( math.random( -dist, dist ), math.random( -dist, dist ), 0 ) -- The pose that will be attempted.
	 	local posTrace = util.TraceLine( { start = self:GetPos( ), endpos = attemptPos, filter = self } )
	 	if ( posTrace.Entity and self:GetStat( self.FOLLOWTARGET ) and posTrace.Entity == self:GetStat( self.FOLLOWTARGET ) ) then -- If the owner in in the way.
	 		self:MoveNearTarget( tar, dist, options, maxAttempt, false )
	 		return
	 	end
	end

	self.loco:FaceTowards( attemptPos )

	local status = self:MoveToPos( attemptPos, options )

end

-------------------------------------------------------------------------
---------- Had to modify the MoveToPos function to allow the npc to jump 
---------- towards a position rather than just upwards.
function ENT:JumpTowards( pos, options )
	--local checkForEntity = self:IsEntityBlocking( nil, 200, false )
	self.loco:SetDesiredSpeed( 600 )     
	self.loco:SetAcceleration( 1200 )
	local options = options or {}
	local path = Path( "Follow" )

	path:SetMinLookAheadDistance( options.lookahead or 300 )
	path:SetGoalTolerance( options.tolerance or 20 )
	path:Compute( self, pos )

	if ( !path:IsValid() ) then return "failed" end
	while ( path:IsValid() ) do
		local minBounds, maxBounds = self:GetCollisionBounds( ) -- Get the default bounds.
		--self:DoCycles( )
		if ( minBounds == Vector( 0, 0, 0 ) and maxBounds == Vector( 0, 0, 0 ) ) then -- If no collision, don't check for an entity.
			checkForEntity = nil
		end
		/*if ( IsValid( checkForEntity ) and !self.ignoreEntities ) then -- Checks if there is any entity blocking the jump.
			self.loco:SetDesiredSpeed( 0 ) -- To ensure the cat stops in its path.
			self.loco:SetAcceleration( 0 )
			self:PlaySequenceAndWait( self:FetchRandomAnim( self.CAT_IDLE ) )
			self.aiStatus = self.CAT_IDLE
			self.ignoreEntities = false
			path:Invalidate( ) -- Ensures that there is no more progression of the path.
			continue
		end*/
		self:SetPlaybackRate( 1 )
		self:SetSequence( "leap" )
		self.loco:FaceTowards( pos )
		path:Update( self )

		if ( options.draw ) then
			path:Draw()
		end

		if ( self.loco:IsStuck() ) then
			self:HandleStuck()
		end

		if ( options.maxage ) then
			if ( path:GetAge() > options.maxage ) then return "timeout" end
		end

		if ( options.repath ) then
			if ( path:GetAge() > options.repath ) then path:Compute( self, pos ) end
		end

		-- Basically what this does is as soon as the cat begins moving to the position, it will jump, and then it breaks out of the while loop.
		if ( !self.loco:IsClimbingOrJumping( ) and path:GetAge( ) > options.maxage * 0.1 ) then
			self.loco:Jump( )
			--self.loco:SetAcceleration( 400 )
			if ( IsValid( self:GetStat( self.CAT_FOLLOWTARGET ) ) ) then
				self.aiStatus = self.CAT_FOLLOWING
			else
				self.aiStatus = self.CAT_IDLE
			end
			self:SetCollisionBounds( self.DefaultBounds[1], self.DefaultBounds[2] ) -- Set the collision bounds back to normal.
			self.ignoreEntities = false
			path:Invalidate( )
			continue
		end

		coroutine.yield()
	end

	return "ok"
end

--------------------------------------------------------------------------------------
------- Modified MoveToPos function, allows escaping.
function ENT:MoveToPos( pos, options )
	self.cancelMove = false -- Reset the cancelMove variable.
	local options = options or {}
	local path = Path( "Follow" )

	path:SetMinLookAheadDistance( options.lookahead or 300 )
	path:SetGoalTolerance( options.tolerance or 20 )
	path:Compute( self, pos )

	if ( !path:IsValid() ) then return "failed" end

	while ( path:IsValid() ) do
		if ( self:IsOnGround( ) and self:IsSequenceActive( "land" ) ) then -- There must be a better way...
			if ( self.aiStatus == self.CAT_ROAMING ) then
				self:SetSequence( "walk" )
				self:SetPlaybackRate( 1 )
			elseif( self.aiStatus == self.CAT_FOLLOWING or self.aiStatus == self.CAT_FRENZY or self.aiStatus == self.CAT_WATERSEARCH or self.aiStatus == self.CAT_FOODSEARCH or 
				self.aiStatus == self.CAT_FOLLOWING or self.aiStatus ) then
				self:SetSequence( "run" )
				self:SetPlaybackRate( 1.2 )
			elseif ( self.aiStatus == self.CAT_FLEEING ) then
				self:SetSequence( "run" )
				self:SetPlaybackRate( 1.5 )
			end
		end
		self:DoCycles( )
		if ( self.cancelMove ) then
			if not ( self.skipSequence ) then -- If true, don't go to idle.
				self.aiStatus = self.CAT_IDLE
			else
				self.skipSequence = false
			end
			path:Invalidate( ) -- Ceases progression of the path.
			self.cancelMove = false -- Resets the variable just incase.
			continue
		end
		path:Update( self )

		if ( options.draw ) then
			path:Draw()
		end

		if ( self.loco:IsStuck( ) ) then
			self:HandleStuck()
			return "stuck"

		end

		if ( options.maxage ) then
			if ( path:GetAge() > options.maxage ) then return "timeout" end
		end

		if ( options.repath ) then
			if ( path:GetAge() > options.repath ) then path:Compute( self, pos ) end
		end

		coroutine.yield()

	end

	return "ok"

end

-- Helper functions for getting and setting stats for the server and client.
function ENT:SetStat( enum, val )
	net.Start( "CatNPCs_ReceiveData")
		if ( enum == self.CAT_LIFE ) then
			net.WriteString( "SetLife" )
			net.WriteInt( val, 32 )
		elseif ( enum == self.CAT_HUNGER ) then
			self.curHunger = val
			net.WriteString( "SetHunger" )
			net.WriteInt( val, 32 )
		elseif ( enum == self.CAT_AGE ) then
			self.curAge = val
			net.WriteString( "SetAge" )
			net.WriteInt( val, 32 )
		elseif ( enum == self.CAT_HYDRATION ) then
			self.curHydration = val
			net.WriteString( "SetHydration" )
			net.WriteInt( val, 32 )
		elseif ( enum == self.CAT_FATIGUE ) then
			self.curFatigue = val
			net.WriteString( "SetFatigue" )
			net.WriteInt( val, 32 )
		elseif ( enum == self.CAT_FOLLOWTARGET ) then
			self.followTarget = val
			net.WriteString( "SetFollowTarget" )
			net.WriteEntity( val )
		end
		net.WriteEntity( self )
	net.Send( player.GetAll( ) )
end

function ENT:GetStat( enum )
	if ( enum == self.CAT_HUNGER ) then
		return self.curHunger or 0
	elseif ( enum == self.CAT_AGE ) then
		return self.curAge or 0
	elseif ( enum == self.CAT_HYDRATION ) then
		return self.curHydration or 0
	elseif ( enum == self.CAT_FATIGUE ) then
		return self.curFatigue or 0
	elseif ( enum == self.CAT_FOLLOWTARGET ) then
		return self.followTarget
	end
end

--------------------------------------------------------------------------------------
------- Add NPC to spawnmenu listing.
list.Set( "NPC", "npc_siamesecat", {	
	Name = "Siamese Cat", 
	Class = "npc_siamesecat",
	Category = "Jeezy's NPCs"	
} )
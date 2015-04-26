AddCSLuaFile("shared.lua")

include('shared.lua')

local _R = debug.getregistry()
_R.NPCFaction.Create("NPC_FACTION_MUTANT","npc_quadralex")
ENT.NPCFaction = NPC_FACTION_MUTANT
ENT.iClass = CLASS_MUTANT
util.AddNPCClassAlly(CLASS_MUTANT,"npc_quadralex")
ENT.sModel = "models/sin/quadralex.mdl"
ENT.fMeleeDistance	= 60
ENT.fMeleeForwardDistance	= 400
ENT.fRangeDistance = 1500
ENT.fChargeDistance = 1600
ENT.m_fMaxYawSpeed = 10
ENT.m_bForceDeathAnim = true
ENT.UseCustomMovement = true
ENT.tblIgnoreDamageTypes = {DMG_DISSOLVE}
ENT.possOffset = Vector(-50,0,150)

ENT.skName = "quadralex"
ENT.CollisionBounds = Vector(55,55,90)

ENT.iBloodType = BLOOD_COLOR_GREEN
ENT.sSoundDir = "npc/quadralex/"

ENT.m_tbSounds = {
	["AttackShockwave"] = "quad_shockwave[1-2].wav",
	["ChargeStart"] = "quad_chargestart.wav",
	["ChargeStop"] = "quad_chargestop.wav",
	["ChargeAbort"] = "quad_chargeabort.wav",
	["ChargeHit"] = {"quad_chargehit.wav", "quad_chargehit2.wav"},
	["Death"] = "quad_death[1-2].wav",
	["PainSmall"] = {"quad_duaghit1a.wav","quad_duaghit1b.wav","quad_duaghit1c.wav","quad_duaghit1d.wav"},
	["PainBig"] = {"quad_duaghit2a.wav","quad_duaghit2b.wav","quad_duaghit2c.wav"},
	["Idle"] = "quad_idle.wav",
	["Roar"] = "quad_roar[1-3].wav",
	["Pain"] = "molerat_injured0[1-3].mp3",
	["Slash"] = "quad_slash[1-3].wav",
	["FootHeavy"] = "quad_step_heavy.wav",
	["FootLight"] = "quad_step_light.wav"
}

ENT.tblFlinchActivities = {
	[HITBOX_LEFTARM] = ACT_FLINCH_LEFTARM,
	[HITBOX_RIGHTARM] = ACT_FLINCH_RIGHTARM,
	[HITBOX_GENERIC] = ACT_FLINCH_CHEST
}

function ENT:OnInit()
	self:SetHullType(HULL_LARGE)
	self:SetHullSizeNormal()
	self:SetCollisionBounds(self.CollisionBounds,Vector(self.CollisionBounds.x *-1,self.CollisionBounds.y *-1,0))
	
	self:CapabilitiesAdd(bit.bor(CAP_MOVE_GROUND,CAP_OPEN_DOORS))
	self:SetHealth(GetConVarNumber("sk_" .. self.skName .. "_health"))
	self.cspIdle = CreateSound(self,self.sSoundDir .. "quad_idle.wav")
	self.cspIdle:Play()
	self:StopSoundOnDeath(self.cspIdle)
	self:SetSoundLevel(100)
	self.m_tNextRange = 0
end

function ENT:CustomFlinch(dmginfo,hitgroup)
	if dmginfo:IsDamageType(DMG_BLAST) then self:RestartGesture(ACT_GESTURE_BIG_FLINCH)
	else self:RestartGesture(ACT_GESTURE_SMALL_FLINCH) end
	self:OnFlinch(entAttacker)
end

function ENT:OnLimbCrippled(hitbox, attacker)
	if hitbox == HITBOX_LEFTLEG || hitbox == HITBOX_RIGHTLEG || hitbox == HITBOX_LEFTARM || hitbox == HITBOX_RIGHTARM then
		self:SetRunActivity(ACT_RUN_HURT)
	end
end

function ENT:Charge()
	if self.m_bCharge then
		self:PlayActivity(ACT_RUN_AIM_RELAXED)
		return
	end
	--if self.m_bCharging then return end
	self:PlayActivity(ACT_RUN_AIM)
	self.m_bCharging = true
end

function ENT:OnLimbCrippled(hitbox, attacker)
	if hitbox == HITBOX_LEFTLEG || hitbox == HITBOX_RIGHTLEG || hitbox == HITBOX_LEFTARM || hitbox == HITBOX_RIGHTARM then
		self:SetWalkActivity(ACT_WALK_HURT)
		self:SetRunActivity(ACT_RUN_HURT)
	end
end

function ENT:_PossPrimaryAttack(entPossessor, fcDone)
	self:PlayActivity(ACT_MELEE_ATTACK1,false,fcDone)
end

function ENT:_PossSecondaryAttack(entPossessor, fcDone)
	self:PlayActivity(ACT_RANGE_ATTACK1,false,fcDone)
end

function ENT:SetChargeActivity(act,bFaceEnemy)
	self.m_actCharge = act
	self.m_bChargeFaceEnemy = bFaceEnemy
end

function ENT:OnThink()
	self:UpdateLastEnemyPositions()
	local act = self:GetActivity()
	if act != self.m_iActivityLast then
		local snd = act == ACT_WALK && "quad_walk" || act == ACT_RUN && "quad_run" || act == ACT_RUN_HURT && "quad_runhurt" || act == ACT_RUN_AIM_RELAXED && "quad_chargeloop" || "quad_idle"
		self.m_iActivityLast = act
		local csp = CreateSound(self,self.sSoundDir .. snd .. ".wav")
		csp:Play()
		self:StopSoundOnDeath(csp)
		self.cspIdle:Stop()
		self.cspIdle = csp
		--Entity(1):ChatPrint("Setting IdleSound to " .. snd)
	end
	if self.m_actCharge then self:PlayActivity(self.m_actCharge,self.m_bChargeFaceEnemy) end
	if !self.m_bEndCharge && self.m_bCharging then
		if !self.m_bChargeStart then
			local posSelf = self:GetPos()
			if IsValid(self.entEnemy) then
				local angTgt = (self.entEnemy:GetPos() -posSelf):Angle()
				local ang = self:GetAngles()
				if !self.m_tHitTarget && self:CanSee(self.entEnemy) then
					self:SetAngles(Angle(0,math.ApproachAngle(ang.y,angTgt.y,0.325),0))
				end
				
				if self.m_tHitTarget && CurTime() -self.m_tHitTarget >= 1 then
					--Entity(1):ChatPrint("Ending charge!")
					self.m_tHitTarget = nil
					self:SetChargeActivity(ACT_RUN_AIM_STEALTH)
				else
					local vel = self:GetMovementVelocity()
					local bCrash = (CurTime() -self.m_chargeStart) >= 2 && vel:Length() == 0
					local mins, maxs = self:OBBMins(), self:OBBMaxs()
					local forward = self:GetForward()
					local pos = posSelf +forward *maxs.y +Vector(0,0,16)
					local posEnd = pos +self:GetForward() *20 +Vector(0,0,16)
					local tr = util.TraceHull({
						start = pos,
						endpos = posEnd,
						filter = self,
						mask = MASK_SOLID,
						mins = mins,
						maxs = maxs
					})
					--util.CreateSpriteBox(tr.StartPos +mins, tr.StartPos +maxs, 0.1, 60, tr.Hit && Color(255,0,0,255) || Color(0,0,255,255))
					if bCrash || tr.Hit then
						if IsValid(tr.Entity) && (tr.Entity:IsNPC() || tr.Entity:IsPlayer()) && tr.Entity:Health() > 0 && (self:Disposition(tr.Entity) == D_HT || self:Disposition(tr.Entity) == D_FR) then
							if !self.m_tHitTarget then
								self:PlaySound("ChargeHit")
								local posDmg = tr.Entity:NearestPoint(self:GetCenter())
								local dmgInfo = DamageInfo()
								dmgInfo:SetDamage(35)
								dmgInfo:SetAttacker(self)
								dmgInfo:SetInflictor(self)
								dmgInfo:SetDamageType(DMG_SLASH)
								dmgInfo:SetDamagePosition(posDmg)
								tr.Entity:TakeDamageInfo(dmgInfo)
								local vel = (tr.Entity:GetPos() -posSelf):GetNormal() *1000 +Vector(0,0,500)
								if(util.GMIsAftermath) then
									tr.Entity:KnockDown(8)
									local ragdoll = tr.Entity:GetRagdollEntity()
									if(IsValid(ragdoll)) then ragdoll:AddVelocity(vel)
									else tr.Entity:SetVelocity(vel) end
								else tr.Entity:SetVelocity(vel) end
								self.m_tHitTarget = CurTime()
								self:RestartGesture(ACT_GESTURE_RANGE_ATTACK1)
							end
						else self:Crash() end
					elseif !self.m_tHitTarget then
						local yawDiff = math.AngleDifference(angTgt.y,ang.y)
						local dist = self:OBBDistance(self.entEnemy)
						if dist >= 200 && (yawDiff <= -50 || yawDiff >= 50) then
							--Entity(1):ChatPrint("Cancelling charge!")
							self:EndCharge()
							self:SetChargeActivity()
							self:PlayActivity(ACT_DOD_RUN_AIM)
						end
					end
				end
			end
			for _, ent in ipairs(ents.FindInSphere(posSelf,95)) do
				if ent != self && ent:IsValid() then
					local phys = ent:GetPhysicsObject()
					if IsValid(phys) then
						local mass = phys:GetMass()
						if mass <= 500 then
							local vel = (ent:GetPos() -posSelf):GetNormal() *2000 +Vector(0,0,500)
							phys:ApplyForceCenter(vel)
						else
							self:Crash()
							break
						end
					end
				end
			end
		end
	end
	self:NextThink(CurTime())
	return true
end

function ENT:Crash()
	if(!self.m_bCharging) then return end
	self:EndCharge()
	self.m_tHitTarget = nil
	self:PlayActivity(ACT_RUN_AIM_AGITATED)
	self:SetChargeActivity()
end

function ENT:EndCharge()
	self.m_tNextRange = CurTime() +math.Rand(2,8)
	self.m_bCharging = false
	self.m_chargeStart = nil
end

function ENT:EventHandle(...)
	local event = select(1,...)
	if(event == "chargeend") then
		self.m_bEndCharge = false
		self:EndCharge()
		self:SetChargeActivity()
		return true
	end
	if(event == "charge") then
		self.m_bChargeStart = false
		self:SetChargeActivity(ACT_RUN_AIM_RELAXED)
		self:OnThink()
		return true
	end
	if(event == "rattack") then
		local pos = self:GetPos() +self:GetForward() *60 +self:GetUp() *10
		local posTgt
		if(IsValid(self.entEnemy) || self:IsPossessed()) then
			local posSelf = self:GetPos()
			if(!self:IsPossessed()) then posTgt = self.entEnemy:GetCenter() +self.entEnemy:GetVelocity() *0.5
			else
				local entPossessor = self:GetPossessor()
				posTgt = entPossessor:GetPossessionEyeTrace().HitPos
			end
		else posTgt = self:GetForward() *500 +Vector(0,0,10) end
		ParticleEffect("quadralex_rock_smoke",pos,Angle(0,0,0),self)
		local ent = ents.Create("obj_quadralex_rock")
		ent:SetPos(pos)
		ent:SetAngles(self:GetAngles())
		ent:NoCollide(self)
		ent:SetEntityOwner(self)
		ent:Spawn()
		ent:Activate()
		local eta = ent:SetArcVelocity(pos,self.entEnemy:GetCenter() +self.entEnemy:GetVelocity() *0.5,2000,self:GetForward(),0.65,vector_origin)
		return true
	end
	if(event == "mattack") then
		local dist = self.fMeleeDistance
		local dmg = GetConVarNumber("sk_quadralex_dmg_shove")
		local ang = Angle(10,-40,2)
		self:DealMeleeDamage(dist,dmg,ang)
		return true
	end
	if(event == "stopmoving") then
		self:StopMoving()
		self:StopMoving()
		return true
	end
end

function ENT:Interrupt()
	if self.actReset then self:SetMovementActivity(self.actReset); self.actReset = nil end
	self.bInSchedule = false
	if self:IsPossessed() then self:_PossScheduleDone() end
end

function ENT:CanCharge()
	if !self.currentPath then return true end
	local posSelf = self:GetPos()
	local angToEnemy = (self.entEnemy:GetPos() -posSelf):Angle()
	for _, node in ipairs(self.currentPath) do
		local ang = (node.pos -posSelf):Angle()
		local yawDiff = math.AngleDifference(angToEnemy.y,ang.y)
		if yawDiff >= 30 || yawDiff <= -30 then return false end
		local pitchDiff = math.AngleDifference(angToEnemy.p,ang.p)
		if pitchDiff >= 30 || pitchDiff <= -30 then return false end
	end
	return true
end

function ENT:SelectScheduleHandle(enemy,dist,distPred,disp)
	if(disp == D_HT) then
		if self:CanSee(enemy) then
			local bMelee = dist <= self.fMeleeDistance || distPred <= self.fMeleeDistance
			if bMelee then
				self:PlayActivity(ACT_MELEE_ATTACK1, true)
				return
			end
			if dist >= 200 && CurTime() >= self.m_tNextRange then
				if dist <= self.fChargeDistance && math.random(1,5) >= 3 && self:CanCharge() then
					self:StopMoving()
					self:StopMoving()
					self:SetChargeActivity(ACT_RUN_AIM,true)
					self.m_chargeStart = CurTime()
					self.m_bChargeStart = true
					self.m_bCharging = true
					self:OnThink()
					return
				elseif dist <= self.fRangeDistance then
					self.m_tNextRange = CurTime() +math.Rand(8,15)
					self:PlayActivity(ACT_RANGE_ATTACK1,true)
					return
				end
			end
		end
		self:ChaseEnemy()
	elseif(disp == D_FR) then
		self:Hide()
	end
end
local PART = {}

PART.ClassName = "effect"

pac.StartStorableVars()
	pac.GetSet(PART, "Effect", "default")
	pac.GetSet(PART, "Loop", true)
	pac.GetSet(PART, "Follow", true)
	pac.GetSet(PART, "Rate", 1)
	pac.GetSet(PART, "UseParticleTracer", false)
	
	pac.SetupPartName(PART, "PointA")
	pac.SetupPartName(PART, "PointB")
	pac.SetupPartName(PART, "PointC")
	pac.SetupPartName(PART, "PointD")
	
pac.EndStorableVars()

function PART:GetNiceName()
	return pac.PrettifyName(self:GetEffect())
end

function PART:Initialize()
	self:SetEffect(self.Effect)
end

function PART:SetControlPointA(var)
	self.ControlPointA = var
	self:ResolveControlPoints()
end

function PART:SetControlPointB(var)
	self.ControlPointB = var
	self:ResolveControlPoints()
end

function PART:GetOwner()
	local parent = self:GetParent()
	
	if parent:IsValid() then		
		if parent.ClassName == "model" and parent.Entity:IsValid() then
			return parent.Entity
		end
	end
	
	return self.BaseClass.GetOwner(self)
end

PART.last_spew = 0

LOADED_PARTICLES = LOADED_PARTICLES or {}

for key, file_name in pairs(file.Find("particles/*.pcf", "GAME")) do
	if not LOADED_PARTICLES[file_name] then
		game.AddParticles("particles/" .. file_name)
	end
	LOADED_PARTICLES[file_name] = true
end

function PART:SetEffect(name)
	self.Effect = name
	self.Ready = false
	
	net.Start("pac_request_precache")
		net.WriteString(name)
	net.SendToServer()
end

net.Receive("pac_effect_precached", function()
	local name = net.ReadString()
	pac.dprint("effect %q precached!", name)
	for key, part in pairs(pac.GetParts()) do
		if part.ClassName == "effect" then
			if part.Effect == name then
				part.Ready = true
			end
		end
	end
end)

local CurTime = CurTime

function PART:OnDraw(owner, pos, ang)
	if not self.Ready then return end
	
	local ent = self:GetOwner()

	if ent:IsValid() then
		if self.Loop then
			local time = CurTime()
			if self.last_spew < time then
				ent:StopParticles()
				ent:StopParticleEmission()
				self:Emit(pos, ang)
				self.last_spew = time + math.max(self.Rate, 0.1)
			end
		end
	end
end

function PART:OnHide()
	local ent = self:GetOwner()
	
	if ent:IsValid() then
		ent:StopParticles()
		ent:StopParticleEmission()
	end
end

function PART:ResolveControlPoints()
	for key, part in pairs(pac.GetParts()) do	
		if part.Name == self.ControlPointA then
			self.ControlPointAPart = part
			break
		end
	end
	
	for key, part in pairs(pac.GetParts()) do	
		if part.Name == self.ControlPointB then
			self.ControlPointBPart = part
			break
		end
	end
end

local ParticleEffect = ParticleEffect
local ParticleEffectAttach = ParticleEffectAttach

function PART:OnShow(from_rendering)
	if from_rendering then
		self:Emit(self:GetDrawPosition())
	end
end

function PART:Emit(pos, ang)
	local ent = self:GetOwner()
	
	if ent:IsValid() then
		if not self.Effect then
			ent:StopParticles()
			ent:StopParticleEmission()
			return
		end
		
		if self.UseParticleTracer and self.PointA:IsValid() then
			local ent2 = self.PointA.Entity and self.PointA.Entity or self.PointA:GetOwner()
			
			util.ParticleTracerEx(
				self.Effect, 
				ent:GetPos(), 
				ent2:GetPos(),
				true, 
				ent:EntIndex(),
				0
			)
			return
		end
		
		if self.PointA:IsValid() then
			local points = {}
			
			table.insert(points, {
				entity = self.PointA.Entity and self.PointA.Entity or self.PointA:GetOwner(),
				attachtype = PATTACH_ABSORIGIN_FOLLOW,
			})
			
			if self.PointB:IsValid() then
				table.insert(points, {
					entity = self.PointB.Entity and self.PointB.Entity or self.PointB:GetOwner(),
					attachtype = PATTACH_ABSORIGIN_FOLLOW,
				})
			end
			
			if self.PointC:IsValid() then
				table.insert(points, {
					entity = self.PointC.Entity and self.PointC.Entity or self.PointC:GetOwner(),
					attachtype = PATTACH_ABSORIGIN_FOLLOW,
				})
			end

			if self.PointD:IsValid() then
				table.insert(points, {
					entity = self.PointD.Entity and self.PointD.Entity or self.PointD:GetOwner(),
					attachtype = PATTACH_ABSORIGIN_FOLLOW,
				})
			end
			
			
			ent:CreateParticleEffect(self.Effect, points)
		elseif self.Follow then
			ent:StopParticles()
			ent:StopParticleEmission()
			ParticleEffectAttach(self.Effect, PATTACH_ABSORIGIN_FOLLOW, ent, 0)
		else
			ent:StopParticles()
			ent:StopParticleEmission()
			ParticleEffect(self.Effect, pos, ang, ent)
		end
	end
end

pac.RegisterPart(PART)
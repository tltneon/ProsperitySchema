
function EFFECT:Init(data)
	self.pos = data:GetOrigin()
	self.time = CurTime() + 200
	self.Emitter = ParticleEmitter(self.pos, true)
	
	if data:GetFlags() != nil then
		self.goretype = data:GetFlags()
	else
		self.goretype = 1
	end
	
	self.EffectEntity = data:GetEntity()
	self.EffectPhysBone = data:GetAttachment()
	self.EffectBone = data:GetScale()
end

function Collide(particle, hitpos, hitnorm)
	local ang = hitnorm:Angle()
	
	if ang.r == 0 && ang.p == 270 then
		ang.y = math.random(0, 359)
	end

	particle:SetAngleVelocity(Angle(0,0,0))
	particle:SetAngles(ang)
	particle:SetVelocity(Vector(0,0,0))
	particle:SetGravity(Vector(0,0,0))
	particle:SetPos(hitpos + hitnorm)
	particle:SetDieTime(200)
	particle:SetEndSize(math.random(15,30))
end

function ParticleThink(particle)
	//particle:SetAngles(particle:GetVelocity():GetNormalized():Angle())
	
	local LightColor = render.GetLightColor(particle:GetPos()) * 255
	LightColor.r = math.Clamp(LightColor.r, 30, 255)
	LightColor.g = math.Clamp(LightColor.g, 30, 255)
	
	if particle.goretype == 1 then
		particle.color = Color(LightColor.r * 0.5, 0, 0, 255)
	elseif particle.goretype == 2 then
		particle.color = Color(LightColor.r * 0.5, LightColor.g * 0.5, 0, 255)
	elseif particle.goretype == 3 then
		particle.color = Color(LightColor.r * 0.5, 0, 0, 255)
	end
	
	particle:SetColor(particle.color.r, particle.color.g, particle.color.b, 255)
	
	if particle:GetLifeTime() == 5 then
		particle:SetEndSize(0)
		particle:SetEndAlpha(0)
	end
end

function EFFECT:Think()
	if self.EffectEntity:IsValid() and self.EffectEntity:GetNWBool("clientboneisgibbed" .. self.EffectBone) then
		if math.random(1, 35) == 1 then
			if self.goretype == 1 then
				self.color = Color(175, 0, 0)
			elseif self.goretype == 2 then
				self.color = Color(math.random(230, 255), math.random(230, 255), 0)
			elseif self.goretype == 3 then
				self.color = Color(160, 230, 0)
			end
			
			if self.Emitter != nil then
				local particle = self.Emitter:Add("dismemberment/blood_drop", self.EffectEntity:GetPhysicsObjectNum(self.EffectPhysBone):GetPos())
					particle:SetColor(self.color.r, self.color.g, self.color.b, 255)
					particle:SetVelocity(VectorRand() * 25)//VectorRand():GetNormal() * 50 -- sprays randomly in a circle //VectorRand() * 80 --sprays randomly
					particle:SetGravity(Vector(0, 0, -600))
					particle:SetStartSize(math.random(6, 10))
					particle:SetEndSize(math.random(5, 10))
					particle:SetCollide(true)
					particle:SetCollideCallback(Collide)
					particle:SetDieTime(20)
					//particle:SetLifeTime(5)
					particle:SetLighting(false)
					particle:SetStartAlpha(math.random(240,250))
					particle:SetEndAlpha(math.random(200,220))
					particle:SetRoll(math.random(-80,80))
					particle:SetRollDelta(.4)
					particle:SetStartLength(1)
					particle:SetEndLength(5)
					
					local LightColor = render.GetLightColor(particle:GetPos()) * 255
					LightColor.r = math.Clamp(LightColor.r, 30, 255)
					LightColor.g = math.Clamp(LightColor.g, 30, 255)

					if self.goretype == 1 then
						self.color = Color(LightColor.r * 0.5, 0, 0, 255)
					elseif self.goretype == 2 then
						self.color = Color(LightColor.r * 0.5, LightColor.g * 0.5, 0, 255)
					elseif self.goretype == 3 then
						self.color = Color(LightColor.r * 0.5, 0, 0, 255)
					end

					particle:SetColor(self.color.r, self.color.g, self.color.b, 255)
			end
		end
	end
	
	if DMCleanup then
		self.Emitter:SetNoDraw(true)
		self.Emitter:Finish()
		return false
	end
	
	if CurTime() < self.time then
		return true
	else
		self.Emitter:SetNoDraw(true)
		self.Emitter:Finish()
		return false
	end
end

function EFFECT:Render()
end


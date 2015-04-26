
function EFFECT:Init(data)
	self.pos = data:GetOrigin()
	self.time = CurTime() + 125
	
	local Dir = VectorRand() * 0.5 + data:GetNormal() * 0.5
	local Speed = math.Rand(1000, 1500)
	
	if data:GetFlags() != nil then
		self.goretype = data:GetFlags()
	else
		self.goretype = 1
	end
	
	if self.goretype == 1 then
		self.color = Color(175, 0, 0)
	elseif self.goretype == 2 then
		self.color = Color(math.random(230, 255), math.random(230, 255), 0)
	elseif self.goretype == 3 then
		self.color = Color(160, 230, 0)
	end
	
	self.Emitter = ParticleEmitter(self.pos, true)
	
	if self.Emitter != nil then
		for i = 1, math.random(5, 10) do
			local particle = self.Emitter:Add("dismemberment/blood_drop", self.pos)//old texture "effects/blood_puff"
				particle.emitter = self.Emitter
				particle:SetColor(self.color.r, self.color.g, self.color.b, 255)
				particle:SetVelocity((Dir * 0.95 + VectorRand() * 0.02) * (Speed * (i /40)))//VectorRand():GetNormal() * 50 -- sprays randomly in a circle //VectorRand() * 80 --sprays randomly
				particle:SetGravity(Vector(0, 0, -600))
				particle:SetStartSize(math.random(6, 10))
				particle:SetEndSize(math.random(5, 10))
				particle:SetCollide(true)
				particle:SetCollideCallback(Collide)
				particle:SetDieTime(20)
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
	else
		print("Particle Overflow!!! Too many particles to spawn new ones. Reloading your game or waiting a little bit should fix this.")
	end
end

function Collide(particle, hitpos, hitnorm)
	if math.random(1,5) == 1 then
		if particle.goretype == 1 then
			util.Decal("Blood", hitpos + hitpos:GetNormal(), hitpos - hitpos:GetNormal())
		elseif particle.goretype == 2 then
			util.Decal("YellowBlood", hitpos + hitpos:GetNormal(), hitpos - hitpos:GetNormal())
		elseif particle.goretype == 3 then
			util.Decal("Blood", hitpos + hitpos:GetNormal(), hitpos - hitpos:GetNormal())
			util.Decal("YellowBlood", hitpos + hitpos:GetNormal(), hitpos - hitpos:GetNormal())
		end
	end
	local ang = hitnorm:Angle()
	
	if ang.r == 0 && ang.p == 270 then
		ang.y = math.random(0, 359)
	end

	particle:SetAngleVelocity(Angle(0,0,0))
	particle:SetAngles(ang)
	particle:SetVelocity(Vector(0,0,0))
	particle:SetGravity(Vector(0,0,0))
	particle:SetPos(hitpos + hitnorm)
	particle:SetDieTime(100)
	particle:SetEndSize(math.random(15,30))
end

function EFFECT:Think()
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




function EFFECT:Init(data)
	local pos = data:GetOrigin()
	pos = pos + Vector(0, 0, 12)

	local emitter = ParticleEmitter(pos)
	emitter:SetNearClip(40, 45)
		for i=1, math.random(12, 15) do
			local heading = VectorRand():GetNormalized()
			local particle = emitter:Add("particle/smokestack", pos + heading * 16)
			particle:SetVelocity(heading * 255)
			particle:SetDieTime(math.Rand(0.8, 1.0))
			particle:SetStartAlpha(220)
			particle:SetEndAlpha(0)
			particle:SetStartSize(16)
			particle:SetEndSize(16)
			particle:SetColor(20, 100, 20)
			particle:SetRoll(math.Rand(0, 150))
			particle:SetRollDelta(math.Rand(-1, 1))
		end
		for i=1, math.random(5, 8) do
			local particle = emitter:Add("particle/smokestack", pos)
			particle:SetVelocity(VectorRand():GetNormalized() * math.Rand(78, 122))
			particle:SetDieTime(math.Rand(1.2, 1.6))
			particle:SetStartAlpha(220)
			particle:SetEndAlpha(0)
			particle:SetStartSize(16)
			particle:SetEndSize(16)
			particle:SetColor(0, 30, 0)
			particle:SetRoll(math.Rand(0, 150))
			particle:SetRollDelta(math.Rand(-1, 1))
			particle:SetAirResistance(10)
		end
	emitter:Finish()
end

function EFFECT:Think()
	return false
end

function EFFECT:Render()
end
include( "shared.lua" )

function ENT:Initialize()
end

function ENT:Think()
	self:DrawModel()
end

function ENT:OnRemove()
	local effectdata = EffectData()
	effectdata:SetOrigin(self:GetPos())
	
	util.Effect("dismemberment_bloodgibs", effectdata)
	/*
	for i = 1, math.random(20, 40)  do
		local emitter = ParticleEmitter(self:GetPos(), true)
		if emitter != nil then
			local particle = emitter:Add("effects/blood_core", self:GetPos())
				particle:SetColor(175, 0, 0, 255)
				particle:SetVelocity(VectorRand():GetNormal() * 50) -- sprays randomly in a circle //VectorRand() * 80 --sprays randomly
				particle:SetGravity(Vector(0, 0, -600))
				particle:SetStartSize(math.random(5, 10))
				particle:SetEndSize(math.random(2, 8))
				particle:SetCollide(true)
				particle:SetCollideCallback(Collide)
				particle:SetDieTime(20)
				particle:SetLighting(true)
				particle:SetStartAlpha(math.random(240,250))
				particle:SetEndAlpha(math.random(200,220))
				particle:SetRoll(math.random(-80,80))
				particle:SetRollDelta(.4)
				particle:SetStartLength(1)
				particle:SetEndLength(5)
		end
	end
	*/
end
include("shared.lua")

ENT.NextEmit = 0

function ENT:Initialize()

	self:SetModelScale(4, 0)
	self:SetMaterial("models/flesh")
	self:SetModel("models/Gibs/HGIBS.mdl")
	self:SetColor( Color(100, 255, 100, 255) )
	
	self.Emitter = ParticleEmitter(self:GetPos())
	self.Emitter:SetNearClip(16, 24)
end

function ENT:Draw()
	self:DrawModel()

	if CurTime() >= self.NextEmit and self:GetVelocity():Length() >= 16 then
		self.NextEmit = CurTime() + 0.05

		local particle = self.Emitter:Add("flesh_ball/sprite_bloodspray"..math.random(8), self:GetPos())
		particle:SetVelocity(VectorRand():GetNormalized() * math.Rand(8, 16))
		particle:SetDieTime(1)
		particle:SetStartAlpha(230)
		particle:SetEndAlpha(230)
		particle:SetStartSize(10)
		particle:SetEndSize(0)
		particle:SetRoll(math.Rand(0, 360))
		particle:SetRollDelta(math.Rand(-25, 25))
		particle:SetColor(200, 255, 100)
		particle:SetLighting(true)
	end
end

function ENT:Think()
	self.Emitter:SetPos(self:GetPos())
end

function ENT:OnRemove()
	--self.Emitter:Finish()
end
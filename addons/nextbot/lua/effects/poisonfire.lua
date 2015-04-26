function EFFECT:OnRemove()
	self.AmbientSound:Stop()
end

local matGlow = Material("sprites/glow04_noz")
local colGlow = Color(95, 255, 95, 255)
function EFFECT:Init(data)

	self:DrawShadow(false)
	self:SetRenderBounds(Vector(-40, -40, -18), Vector(40, 40, 90))

	self.Emitter = ParticleEmitter(self:GetPos())
	self.Emitter:SetNearClip(32, 48)

	local pos = data:GetOrigin()
	pos = pos + Vector(0, 0, 12)

	local emitter = ParticleEmitter(pos)
	emitter:SetNearClip(40, 45)
	
		render.SetMaterial(matGlow)
		render.DrawSprite(pos, math.Rand(64, 72), math.Rand(64, 72), colGlow)

		if ( self.Timer or 0 ) < CurTime() then
		self.Timer = CurTime() + 0.15

			local particle = emitter:Add("particle/smokestack", pos)
			particle:SetVelocity( Vector(0,0,0) )
			particle:SetDieTime(math.Rand(1, 1.35))
			particle:SetStartAlpha(220)
			particle:SetEndAlpha(0)
			particle:SetStartSize(math.Rand(36, 47))
			particle:SetEndSize(20)
			particle:SetRoll(math.Rand(0, 360))
			particle:SetRollDelta(math.Rand(-3, 3))
			particle:SetGravity(Vector(0, 0, 125))
			particle:SetCollide( false )
			particle:SetBounce(0.45)
			particle:SetAirResistance(12)
			particle:SetColor(0, 200, 0)
		end
		
	emitter:Finish()
end

function EFFECT:Think()
	return false
end

function EFFECT:Render()
end
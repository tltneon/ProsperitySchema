include( "shared.lua" )

ENT.RenderGroup = RENDERGROUP_TRANSLUCENT

local GlowMat = Material( "sprites/light_glow02_add" )
--local GlowMat = Material( "particle/particle_glow_01_additive" )

--LightSpheres fixed by Gmod4phun, original by Dlaor. All credit goes to him, I only fixed it

function ENT:Draw()

	self:DrawShadow( false )

	render.SetMaterial( GlowMat )
	
	local Seed1 = self:GetDTFloat( 0 )
	local Seed2 = self:GetDTFloat( 1 )
	local MyPos = self:GetPos()
	local Index = self:EntIndex()
	
	for i = 1, 180 do
		local Ang = ( Index + 1337 + CurTime() ) * i --Yeah, random math makes awesome shit!
		local Size = ( 155 - i ) / 6 
		local Forward = Angle( Ang * Seed1, Ang * Seed2, 0 ):Forward()
		local Pos = MyPos + Forward * i * 0.1
		render.DrawSprite( Pos, Size, Size, self:GetColor() )
	end

end

function ENT:Think()
	local dlight = DynamicLight( self:EntIndex() )
	if ( dlight ) then
		local color = self:GetColor()
		local r,g,b,a = color.r,color.g,color.b,color.a --Alright, now Dynamic Light works :D
		dlight.Pos = self:GetPos()
		dlight.r = r
		dlight.g = g
		dlight.b = b
		dlight.Brightness = 1
		dlight.Size = 128
		dlight.Decay = 0
		dlight.DieTime = CurTime() + 1
	end
end

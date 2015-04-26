AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )

include('shared.lua')

local attachChance = 0.3

function ENT:Initialize()	
	self:PhysicsInit( SOLID_VPHYSICS )
	self:SetMoveType( MOVETYPE_VPHYSICS )   
	self:SetSolid( SOLID_VPHYSICS )
	
	self:SetCollisionGroup( COLLISION_GROUP_DEBRIS )
	
	self.DoneSim = false
	self:DrawShadow( false )
end
 	
function ENT:PhysicsCollide( data, physobj )	
	if self.DoneSim then return end
	if data.HitEntity.GibMod_IsHeadCrab then return end
	
	-- sound
	math.randomseed( math.random() )
	local rand = math.random(1,5)
	local sound = "dismemberment/body_head_01.wav"
	
	if rand >= 1 and rand <= 4 then
		sound = "dismemberment/bloodspout_0"..math.random(1,3)..".wav"
	elseif rand == 5 then
		sound = "dismemberment/bloodspout_05.wav"
	end
	
	self:EmitSound( sound, 100, math.Clamp( math.Clamp( (self:BoundingRadius() * 10), 1, 5000 ) * -1 + 255 + math.random(-5, 5), 50, 255 )  )
	
	-- blood spurt
	local effectdata = EffectData()
		effectdata:SetOrigin( self:GetPos() )
	util.Effect( "BloodImpact", effectdata )
	
	-- decal
	local tr = util.TraceLine{ start = self:GetPos(),
								endpos = physobj:GetPos() + self:GetPhysicsObject():GetVelocity(),
								filter = self.Entity }
	util.Decal( "Blood", tr.HitPos + tr.HitNormal, tr.HitPos - tr.HitNormal )
	
	-- weld and sag
	if not data.HitEntity:IsPlayer() then
		math.randomseed( math.random() )
		if math.random() > attachChance and not self.IsOrigin then return end
		
		timer.Simple( 0, function() constraint.Weld( self.Entity, data.HitEntity, 0, 0, 0, false, false ) end )
		self.DoneSim = true
		
		if self.rope and self.rope:IsValid() then
			local originPos = self.originEnt:GetPos()
			
			local height = math.abs(data.HitPos.z - originPos.z)
			local dist = originPos:Distance( data.HitPos )
		
			local slack = math.sqrt( (dist ^ 2) - (height ^ 2) )
			local newLen = dist + slack
			
			--constraint.RemoveConstraints( self.Entity, "Rope" )
			--timer.Simple( 0, function() constraint.Rope( self.Entity, self.originEnt, 0, 0, Vector(0, 0, 0), Vector(0, 0, 0), dist, slack, 1000, 15, "gibmod/bloodstream", false ) end )
			
			self.rope:Fire( "SetSpringLength", newLen, 0 )
			self.rope:Fire( "SetLength", newLen, 0 )
		end
	end	
end

function ENT:Think()

end
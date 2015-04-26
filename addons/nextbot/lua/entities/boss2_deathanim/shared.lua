AddCSLuaFile()

ENT.Base             = "base_nextbot"
ENT.Spawnable        = false
ENT.AdminSpawnable   = false
ENT.AutomaticFrameAdvance = true 

--Stats--
--Model Settings--
ENT.Model = ("")

function ENT:Precache()
end

function ENT:Initialize()
	self:SetHealth(999999)
	self:SetModel(self.Model)
	self:SetCollisionGroup(COLLISION_GROUP_IN_VEHICLE)
end

function ENT:BehaveAct()
end

function ENT:Think()

	if ( self.EffectTimer or 0 ) < CurTime() then
	self.EffectTimer = CurTime() + 0.425
	local effectdata = EffectData()
	effectdata:SetStart( self:GetPos() + Vector(0,0,48) ) 
	effectdata:SetOrigin( self:GetPos() + Vector(0,0,48) )
	effectdata:SetScale( 0.8 )
	util.Effect( "poisonfire", effectdata )
	end
	
	if ( self.DamageTimer or 0 ) < CurTime() then
	self.DamageTimer = CurTime() + 1
	local ents = ents.FindInSphere( self:GetPos(), 100 )
	for _,v in pairs(ents) do
	
		if v:IsPlayer() then
		v:TakeDamage(5, self)
		v:EmitSound("npc/headcrab_poison/ph_hiss1.wav")
	
		local painsounds = {}
		painsounds[1] = ("player/pl_pain7.wav")
		painsounds[2] = ("player/pl_pain6.wav")
		painsounds[3] = ("player/pl_pain5.wav")
		v:EmitSound( painsounds[math.random(1,3)] )
		
		local moveAdd=Vector(0,0,250)
			if not v:IsOnGround() then
			moveAdd=Vector(0,0,0)
			end
			v:SetVelocity(moveAdd+((v:GetPos()-self:GetPos()):GetNormal()*200)) -- apply the velocity
		end
		
		if v:GetClass("prop_physics") then
		local phys = v:GetPhysicsObject()
			if (phys != nil && phys != NULL && phys:IsValid()) then
			phys:ApplyForceCenter(self:GetForward():GetNormalized()*10000 + Vector(0, 0, 2))
			v:TakeDamage(10, self)	
			end
		end	
	end
	
	end

end

function ENT:OnRemove()
end

function ENT:GetEnemy()
end

function ENT:OnStuck()
end

function ENT:OnUnStuck()
end

function ENT:SetEnemy()
end

function ENT:GetDoor()
end

function ENT:MoveToPos( pos, options )
end
	
function ENT:AttackProp()
end

function ENT:UpdateEnemy()
end

function ENT:RunBehaviour()
	while ( true ) do	
	if SERVER then
	
	timer.Simple(2.7, function()
	if !self:IsValid() then return end
	if self:Health() < 0 then return end

	local sounds = {}
			sounds[1] = ("physics/flesh/flesh_squishy_impact_hard1.wav")
			sounds[2] = ("physics/flesh/flesh_squishy_impact_hard2.wav")
			sounds[3] = ("physics/flesh/flesh_squishy_impact_hard3.wav")
			sounds[4] = ("physics/flesh/flesh_squishy_impact_hard4.wav")
			self:EmitSound( sounds[math.random(1,4)], 65, math.random(85,95) )
	
	end)
	
	timer.Simple(1.8, function()
	if !self:IsValid() then return end
	if self:Health() < 0 then return end

	local sounds = {}
			sounds[1] = ("physics/flesh/flesh_squishy_impact_hard1.wav")
			sounds[2] = ("physics/flesh/flesh_squishy_impact_hard2.wav")
			sounds[3] = ("physics/flesh/flesh_squishy_impact_hard3.wav")
			sounds[4] = ("physics/flesh/flesh_squishy_impact_hard4.wav")
			self:EmitSound( sounds[math.random(1,4)], 65, math.random(85,95) )
	
	end)
	
	self:PlaySequenceAndWait( "death_04", 1 )
	
	local deathanim = ents.Create("boss2_fakebody")
			if !self:IsValid() then return end
			if deathanim:IsValid() then 
			deathanim:SetPos(self:GetPos())
			deathanim:SetModel(self:GetModel())
			deathanim:SetAngles(self:GetAngles())
			deathanim:Spawn()
			
			deathanim:SetModelScale( 1.4, 0 )
			
			deathanim:SetSkin(self:GetSkin())
			deathanim:SetColor(self:GetColor())
			deathanim:SetMaterial(self:GetMaterial())
			end
	
	self:Remove()
	
	coroutine.wait( 0.01 )
	end
	end
end	

function ENT:OnLeaveGround()
end

function ENT:OnLandOnGround() 
end

function ENT:OnKilled( dmginfo )
end

function ENT:OnInjured( dmginfo )
dmginfo:ScaleDamage(0)
dmginfo:SetDamage(0)
end
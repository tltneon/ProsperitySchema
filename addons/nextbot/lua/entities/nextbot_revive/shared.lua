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
	self:SetHealth( 90 )
	self:SetCollisionGroup(COLLISION_GROUP_DEBRIS)
end

function ENT:BehaveAct()
end

function ENT:Think()

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
	
	self:StartActivity(ACT_HL2MP_ZOMBIE_SLUMP_RISE)
	self:SetPoseParameter("move_x",0)
	coroutine.wait( 3 )
		
	
	local effect = EffectData()
	effect:SetStart( ENT:GetPos() )
	effect:SetOrigin( ENT:GetPos() )
	effect:SetScale( 1 )
	util.Effect( "ragezombie_fade", effect )
	ragdoll:EmitSound("ambient/fire/gascan_ignite1.wav", 125, math.random(85,110))	
	
	local zombie = ents.Create("npc_nextbot_ragezombie")
			if not ( self:IsValid() ) then return end
			if zombie:IsValid() then 
			zombie:SetModel( self.Model )
			zombie:SetPos(self:GetPos() + Vector(0,0,10))
			zombie:SetAngles(self:GetAngles())
			zombie:Spawn()

			zombie:SetHealth(self:Health())
			zombie.Revived = true
			self:Remove()
			end
	
	end
	end
end	

function ENT:OnLeaveGround()
end

function ENT:OnLandOnGround() 
end

function ENT:OnKilled( dmginfo )
self:BecomeRagdoll(dmginfo)
end

function ENT:OnInjured( dmginfo )

	if dmginfo:IsExplosionDamage() then
	dmginfo:ScaleDamage(10)
	else
	dmginfo:ScaleDamage(1)
	end
end
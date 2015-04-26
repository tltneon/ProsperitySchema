AddCSLuaFile()

ENT.Base             = "base_nextbot"
ENT.Spawnable        = false
ENT.AdminSpawnable   = false
ENT.AutomaticFrameAdvance = true 

--Stats--
--Model Settings--
ENT.Model = ("models/player/zombie_fast.mdl")

ENT.Death1 = Sound("npc/zombie/zombie_die1.wav")
ENT.Death2 = Sound("npc/zombie/zombie_die2.wav")
ENT.Death3 = Sound("npc/zombie/zombie_die3.wav")

function ENT:Precache()
end

function ENT:Initialize()
	self:SetHealth(85)
	self:SetModel(self.Model)
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
	self:SetCycle(0.5)
	coroutine.wait( 1.4 )
	
	local zombie = ents.Create("npc_nextbot_reviver")
			if not ( self:IsValid() ) then return end
			if zombie:IsValid() then 
			zombie:SetPos(self:GetPos() + Vector(0,0,10))
			zombie:SetAngles(self:GetAngles())
			zombie:Spawn()
			zombie:SetModelScale(1.1, 0)
			zombie:SetSkin(self:GetSkin())
			zombie:SetColor(self:GetColor())
			zombie:SetMaterial(self:GetMaterial())
			zombie:SetHealth(self:Health())
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
local deathsounds = {}
		deathsounds[1] = (self.Death1)
		deathsounds[2] = (self.Death2)
		deathsounds[3] = (self.Death3)
		self:EmitSound( deathsounds[math.random(1,3)], 90, 75 )

self:SetColor(Color(95,95,95,255))
self:BecomeRagdoll(dmginfo)
end

function ENT:OnInjured( dmginfo )
if !dmginfo:GetAttacker():IsPlayer() and dmginfo:IsExplosionDamage() then
	dmginfo:ScaleDamage(0)
	end

	if dmginfo:IsExplosionDamage() then
	dmginfo:ScaleDamage(10)
	else
	dmginfo:ScaleDamage(1)
	end
end
AddCSLuaFile()

ENT.Base             = "base_nextbot"
ENT.Spawnable        = false
ENT.AdminSpawnable   = false

--Stats--
--Model Settings--
ENT.Model = ("models/props_junk/popcan01a.mdl")

function ENT:Precache()
end

function ENT:ModelHide()
self:DrawShadow(false)
self:SetNoDraw(true)
self:SetNotSolid(true)
end

function ENT:Initialize()
if SERVER then
	self:ModelHide()
	self:SetModel(self.Model)

self.random = ents.Create("npc_nextbot_torsofast")

	self.random:SetPos(self:GetPos())
	self.random:SetAngles(self:GetAngles())
	self.random:Spawn()
	self.random:Activate()

end
end

function ENT:BehaveAct()
end

function ENT:Think()

	if not ( self.random:IsValid()) then 
	
if SERVER then
self.random = ents.Create("npc_nextbot_torsofast")

	self.random:SetPos(self:GetPos())
	self.random:SetAngles(self:GetAngles())
	self.random:Spawn()
	self.random:Activate()

	self:NextThink(CurTime() + .5)
end
end
end

function ENT:OnRemove()
	if self.random then self.random:Remove() end
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
	if self:GetEnemy() then
		pos = self:GetEnemy():GetPos()
		if ( pos ) then
			self.loco:SetDesiredSpeed( 0 )
			local opts = {	lookahead = 300,
							tolerance = 20,
							draw = false,
							maxage = 1,
							repath = 1	}
			self:MoveToPos( pos, opts )	
		end
	else
		ent = player.GetAll()[math.random(1,#player.GetAll())]
		if !self:GetEnemy() or self.Enemy:Health() > 0 then
		self:SetEnemy()
		self.loco:SetDesiredSpeed( 0 )
		else
		self:SetEnemy(ent)
		end
		coroutine.yield()	
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
end
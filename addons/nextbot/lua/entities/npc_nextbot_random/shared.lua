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

	local randomspawn = math.random(1,17)
if randomspawn == 1 then self.random = ents.Create("npc_nextbot_zombine") end
if randomspawn == 2 then self.random = ents.Create("npc_nextbot_slowzombies") end
if randomspawn == 3 then self.random = ents.Create("npc_nextbot_fastzombies") end
if randomspawn == 4 then self.random = ents.Create("npc_nextbot_slowclassic") end
if randomspawn == 5 then self.random = ents.Create("npc_nextbot_fastclassic") end
if randomspawn == 6 then self.random = ents.Create("npc_nextbot_abnormal") end
if randomspawn == 7 then self.random = ents.Create("npc_nextbot_skeletons") end
if randomspawn == 8 then self.random = ents.Create("npc_nextbot_poisonremains") end
if randomspawn == 9 then self.random = ents.Create("npc_nextbot_burning") end
if randomspawn == 10 then self.random = ents.Create("npc_nextbot_infectedzombies") end
if randomspawn == 11 then self.random = ents.Create("npc_nextbot_ragezombie") end
if randomspawn == 12 then self.random = ents.Create("npc_nextbot_metrocop") end
if randomspawn == 13 then self.random = ents.Create("npc_nextbot_mutatedrebel") end
if randomspawn == 14 then self.random = ents.Create("npc_nextbot_reviver") end
if randomspawn == 15 then self.random = ents.Create("npc_nextbot_seekers") end
if randomspawn == 16 then self.random = ents.Create("npc_nextbot_behemoth") end
if randomspawn == 17 then self.random = ents.Create("npc_nextbot_risen") end

	self.random:SetPos(self:GetPos())
	self.random:SetAngles(self:GetAngles())
	self.random:Spawn()
	self.random:Activate()

end
end

function ENT:BehaveAct()
end

function ENT:Think()
end

function ENT:OnRemove()
if SERVER then
	if self.random:IsValid() then self.random:Remove() end
end
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
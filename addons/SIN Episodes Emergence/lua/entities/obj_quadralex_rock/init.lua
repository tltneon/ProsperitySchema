
AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include('shared.lua')

function ENT:Initialize()
	self:SetModel("models/props_debris/concrete_chunk01a.mdl")
	self:SetMoveCollide(COLLISION_GROUP_PROJECTILE)
	self:SetCollisionGroup(COLLISION_GROUP_PROJECTILE)
	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetMoveType(MOVETYPE_VPHYSICS)
	self:SetSolid(SOLID_CUSTOM)
	local phys = self:GetPhysicsObject()
	if IsValid(phys) then
		phys:SetBuoyancyRatio(0)
		phys:EnableDrag(false)
		phys:AddGameFlag(FVPHYSICS_NO_IMPACT_DMG)
	end
	self.delayRemove = CurTime() +8
	
	self.cspLoop = CreateSound(self,"npc/quadralex/thrown_rock_loop1.wav")
	self.cspLoop:Play()
	self.cspLoop:ChangeVolume(0.25,0)
end

function ENT:SetEntityOwner(ent)
	self:SetOwner(ent)
	self.entOwner = ent
end

function ENT:OnRemove()
	self.cspLoop:Stop()
end

function ENT:Think()
	if CurTime() < self.delayRemove then return end
	self:Remove()
end

function ENT:PhysicsCollide(data, physobj)
	ParticleEffect("quadralex_rock_smoke",self:GetPos() +self:OBBCenter(),Angle(0,0,0),self)
	self:EmitSound("npc/quadralex/thrown_rock_hit01.wav",75,100)
	if !IsValid(data.HitEntity) then self:Remove(); return true end
	local dmgInfo = DamageInfo()
	dmgInfo:SetDamage(38)
	dmgInfo:SetAttacker(IsValid(self.entOwner) && self.entOwner || self)
	dmgInfo:SetInflictor(self)
	dmgInfo:SetDamageType(DMG_CRUSH)
	dmgInfo:SetDamagePosition(data.HitPos)
	data.HitEntity:TakeDamageInfo(dmgInfo)
	if(util.GMIsAftermath && (data.HitEntity:IsPlayer() || data.HitEntity:IsNPC())) then
		data.HitEntity:KnockDown(5)
	end
	self:Remove()
	return true
end


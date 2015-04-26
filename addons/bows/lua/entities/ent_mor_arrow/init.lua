AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")

include('shared.lua')

/*---------------------------------------------------------
   Name: ENT:Initialize()
---------------------------------------------------------*/
function ENT:Initialize()
	self:SetModel("models/morrowind/steel/arrow/steelarrow.mdl")
	self.Weapon = self.Weapon:GetClass()	//MORE MAJICKZ
	self:PhysicsInit(SOLID_VPHYSICS)
	self.Entity:SetMoveType(MOVETYPE_VPHYSICS)
	self.Entity:SetSolid(SOLID_VPHYSICS)
	local phys = self.Entity:GetPhysicsObject()
	self.SpawnTime = CurTime()
	self.HitEnemy = false
	self.Disabled = false

	self.Entity:DrawShadow(false)
	self:SetGravity(.01)

	if (phys:IsValid()) then
		phys:Wake()
		phys:SetMass(2)
	end

	util.PrecacheSound("weapons/bow/HIT.wav")
	util.PrecacheSound("weapons/bow/HITWALL.wav")

	self.Hit = "weapons/bow/HIT.wav"

	self.HitWall = "weapons/bow/HITWALL.wav"

	self.Entity:SetUseType(SIMPLE_USE)
end

/*---------------------------------------------------------
   Name: ENT:Think()
---------------------------------------------------------*/
function ENT:Think()
	local velocity = self:GetPhysicsObject():GetVelocity()
	if velocity:Length() > 400 then
		self:SetAngles(self:GetVelocity():Angle() + Angle(180, 0, 0))	// MAJICKZ, DON'T FAIL ME NOW!
	end
	self:GetPhysicsObject():SetVelocity(velocity)
	if CurTime() > (self.SpawnTime + 30) then
		self:Remove()
	end
	if (self:GetParent():IsValid()) and !(self:GetParent():Health() > 0) then
		self:Remove()
	end

	local lifetime = CurTime() - self.SpawnTime
	local velx = velocity.x
	local vely = velocity.y
	local horizvel = (velx^2 + vely^2) ^ .5		// PYTHAGORAS WAS HERE.
	
	if velocity.z < 0 then
		local upvel = horizvel / 50
		self:GetPhysicsObject():SetVelocity(velocity + Vector(0, 0, upvel))
	end

	self:NextThink(CurTime() + .1)
	return true
end

/*---------------------------------------------------------
   Name: ENT:PhysicsCollide()
---------------------------------------------------------*/
function ENT:PhysicsCollide(data, phys)
	if self.Disabled == true then return end
	local Ent = data.HitEntity
	if !(IsValid(Ent) or Ent:IsWorld()) then return end
	if self.Trail then
		self.Trail:SetParent(nil)
		local trail = self.Trail
		self.Trail = nil
	end
	if Ent:IsWorld() then
		util.Decal("ManhackCut", data.HitPos + data.HitNormal, data.HitPos - data.HitNormal)
		self:EmitSound(self.HitWall)
		if data.OurOldVelocity:Length() > 400 then
			self:SetPos(data.HitPos + self:GetForward() * -2)
/*			local ang1 = self:GetAngles()
			local ang2 = data.HitNormal:Angle()
			self:SetAngles(Angle(ang2.x, ang2.y, ang1.z)) //+ Angle(0, 0, 0) + ang) */
//			self:SetAngles(self:GetAngles() + Angle(180, 180, 0))
			self.Entity:SetMoveType(MOVETYPE_NONE)
			self.Entity:SetCollisionGroup(COLLISION_GROUP_DEBRIS)
		end
		self.Disabled = true
		self.SpawnTime = CurTime()
	elseif self.HitEnemy == false then	// Only deal damage once.
		if not(Ent:IsPlayer() or Ent:IsNPC() or Ent:GetClass() == "prop_ragdoll") then 
			util.Decal("ManhackCut", data.HitPos + data.HitNormal, data.HitPos - data.HitNormal)
			self:EmitSound(self.Hit)
			self.HitEnemy = true
		end
		
		local damage = self.Damage
		local tr = {}
		tr.start = data.HitPos
		tr.endpos = data.HitPos + (data.OurOldVelocity * 25)
		tr.filter = self
		local trace = util.TraceLine(tr)
/*		
		local maxE = Ent:LocalToWorld(Ent:OBBMaxs())
		local minE = Ent:LocalToWorld(Ent:OBBMins())
		local height = maxE.z - minE.z
		local shotpos = maxE.z - data.HitPos.z
		local diff = math.Clamp(shotpos/height, 0, 1)
*/		
//		if diff < .25 then
		if trace.Entity == Ent and trace.HitGroup == HITGROUP_HEAD then
			damage = damage * 2
		end
		
		local boink = ents.Create(self.Weapon)
		Ent:TakeDamage(damage, self:GetOwner(), boink)	// If you have a killicon for the axe, this makes it appear.
		boink:Remove()

		if (Ent:IsPlayer() or Ent:IsNPC() or Ent:GetClass() == "prop_ragdoll") then 
			local effectdata = EffectData()
			effectdata:SetStart(data.HitPos)
			effectdata:SetOrigin(data.HitPos)
			effectdata:SetScale(1)
			util.Effect("BloodImpact", effectdata)

			self:EmitSound(self.Hit)
		end
		if (Ent:IsPlayer() or Ent:IsNPC()) and (Ent:Health() > 0) or Ent:GetMoveType() == MOVETYPE_VPHYSICS then //and (!Ent == self:GetOwner()) then
			self.Entity:SetMoveType(MOVETYPE_NONE)
			self.Entity:SetCollisionGroup(COLLISION_GROUP_DEBRIS)
			self:SetPos(self:GetPos() + self:GetForward() * -25)
			self:SetParent(Ent)
			self:SetOwner(Ent)
			self.SpawnTime = CurTime()
			self.Disabled = true
		end
	end
	if !self:GetParent():IsValid() then
		self.Entity:SetOwner(nil)
	end
end

/*---------------------------------------------------------
   Name: ENT:Use()
---------------------------------------------------------*/
function ENT:Use(activator, caller)
	if (activator:IsPlayer()) then
		activator:GiveAmmo(1, "XBowBolt", true)
		activator:SelectWeapon(self.Weapon)
	end
	self.Entity:Remove()
end

function ENT:OnRemove()
	
end
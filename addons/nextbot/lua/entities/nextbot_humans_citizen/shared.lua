AddCSLuaFile()

ENT.Base             = "base_nextbot"
ENT.Spawnable        = false
ENT.AdminSpawnable   = false


--Stats--
ENT.Speed = 90
ENT.RunSpeed = 215
ENT.WalkSpeedAnimation = 0.9

ENT.health = 100

--Model Settings--
ENT.Model = "models/player/group01/female_02.mdl"
ENT.Model2 = "models/player/group01/female_03.mdl"
ENT.Model3 = "models/player/group01/female_04.mdl"
ENT.Model4 = "models/player/group01/male_04.mdl"
ENT.Model5 = "models/player/group01/male_05.mdl"
ENT.Model6 = "models/player/group01/male_06.mdl"
ENT.Model7 = "models/player/group01/male_07.mdl"

ENT.WalkAnim = (ACT_HL2MP_WALK_ZOMBIE_01)
ENT.RunAnim = (ACT_HL2MP_RUN_PROTECTED)

function ENT:Precache()
	if SERVER then
--Models--
util.PrecacheModel(self.Model)
util.PrecacheModel(self.Model2)
util.PrecacheModel(self.Model3)
util.PrecacheModel(self.Model4)
util.PrecacheModel(self.Model5)
util.PrecacheModel(self.Model6)
util.PrecacheModel(self.Model7)
	end
end

function ENT:Initialize()

	--Stats--
    self:SetCollisionGroup(COLLISION_GROUP_DEBRIS)
	
	self.WalkAnims = { ACT_HL2MP_WALK  }
	self.Anims = { ACT_HL2MP_RUN_PROTECTED, ACT_HL2MP_RUN, ACT_HL2MP_RUN_FAST }
	
	local model = math.random(1,7)
	if model == 1 then
	self:SetModel( self.Model )
	self.WalkAnim = table.Random(self.WalkAnims)
	self.RunAnim = table.Random(self.Anims)
	elseif model == 2 then
	self:SetModel( self.Model2 )
	self.WalkAnim = table.Random(self.WalkAnims)
	self.RunAnim = table.Random(self.Anims)
	elseif model == 3 then
	self:SetModel( self.Model3 )
	self.WalkAnim = table.Random(self.WalkAnims)
	self.RunAnim = table.Random(self.Anims)
	elseif model == 4 then
	self:SetModel( self.Model4 )
	self.WalkAnim = table.Random(self.WalkAnims)
	self.RunAnim = table.Random(self.Anims)
	elseif model == 5 then
	self:SetModel( self.Model5 )
	self.WalkAnim = table.Random(self.WalkAnims)
	self.RunAnim = table.Random(self.Anims)
	elseif model == 6 then
	self:SetModel( self.Model6 )
	self.WalkAnim = table.Random(self.WalkAnims)
	self.RunAnim = table.Random(self.Anims)
	elseif model == 7 then
	self:SetModel( self.Model7 )
	self.WalkAnim = table.Random(self.WalkAnims)
	self.RunAnim = table.Random(self.Anims)
	end
	
	self:SetHealth( self.health )
	
	--Misc--
	self:Precache()
	self.loco:SetStepHeight(35)
	self.loco:SetAcceleration(400)
	self.loco:SetDeceleration(900)
	self.nextbot = true
end

function ENT:Think()
if !IsValid(self) then return end

	if self.IsAttacking then
		if (GetConVarNumber("nb_stop") == 0) then
	self.loco:FaceTowards( self.Enemy:GetPos() )
		end
	end
	
    if !self.nxtThink then self.nxtThink = 0 end
    if CurTime() < self.nxtThink then return end

    self.nxtThink = CurTime() + 0.025

	-- First Step
        local bones = self:LookupBone("ValveBiped.Bip01_R_Foot")
		
        local pos, ang = self:GetBonePosition(bones)

        local tr = {}
        tr.start = pos 
        tr.endpos = tr.start - ang:Right()*5 + ang:Forward()*10
        tr.filter = self
        tr = util.TraceLine(tr)

        if tr.Hit && !self.FeetOnGround then
		self:EmitSound("npc/zombie/foot"..math.random(3)..".wav", 70)
        end

        self.FeetOnGround = tr.Hit
		
	-- Second Step
		local bones2 = self:LookupBone("ValveBiped.Bip01_L_Foot")
		
        local pos2, ang2 = self:GetBonePosition(bones2)

        local tr = {}
        tr.start = pos2 
        tr.endpos = tr.start - ang2:Right()*5 + ang2:Forward()*10
        tr.filter = self
        tr = util.TraceLine(tr)

        if tr.Hit && !self.FeetOnGround2 then
		self:EmitSound("npc/zombie/foot"..math.random(3)..".wav", 70)
        end

        self.FeetOnGround2 = tr.Hit
end

function ENT:RunBehaviour()
    while ( true ) do
        -- walk somewhere random
        self:StartActivity( self.RunAnim )               
        self.loco:SetDesiredSpeed( self.RunSpeed )  
		self:SetPoseParameter("move_x",self.WalkSpeedAnimation)		
        self:MoveToPos( self:GetPos() + Vector( math.Rand( -1, 1 ), math.Rand( -1, 1 ), 0 ) * 200 )
        self:SetPoseParameter("move_x",0)
        -- find the furthest away hiding spot
        local pos = self:FindSpot( "random", { type = 'hiding', radius = 5000 } )
        -- if the position is valid
        if ( pos ) then
            self.loco:SetDesiredSpeed( self.Speed )
			self:StartActivity( self.WalkAnim )
			self:SetPoseParameter("move_x",self.WalkSpeedAnimation)	
            self:MoveToPos( pos )
            self:SetPoseParameter("move_x",0)
        else
       
        end
        coroutine.yield()
    end
end

	if SERVER then
function ENT:OnKilled( dmginfo )
	local zombie = ents.Create("citizen_deathanim")
			if !self:IsValid() then return end
			if zombie:IsValid() then 
			zombie:SetPos(self:GetPos())
			zombie:SetModel(self:GetModel())
			zombie:SetAngles(self:GetAngles())
			zombie:Spawn()
			zombie:StartActivity(self.WalkAnim)
			zombie:SetSkin(self:GetSkin())
			zombie:SetColor(self:GetColor())
			zombie:SetMaterial(self:GetMaterial())
			self:Remove()
			end
end

function ENT:OnInjured( dmginfo )

	if dmginfo:IsExplosionDamage() then
	dmginfo:ScaleDamage(10)
	else
	dmginfo:ScaleDamage(1)
	end

end
	end
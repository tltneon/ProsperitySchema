SWEP.Author              = "Jonascone"
SWEP.Contact             = ""
SWEP.Purpose             = "Disguise yourself as a prop."
SWEP.Instructions        = "Left-click to disguise yourself. Right-click to select a prop."

SWEP.Spawnable                  = true
SWEP.AdminSpawnable             = false

SWEP.UseHands = true;
SWEP.ViewModel                  = "models/weapons/v_pistol.mdl"
SWEP.HoldType                   = "normal"
SWEP.ViewModelFOV               = 75

SWEP.Primary.ClipSize           = -1
SWEP.Primary.DefaultClip        = -1
SWEP.Primary.Automatic          = false
SWEP.Primary.Ammo               = "none"

SWEP.Secondary.ClipSize         = -1
SWEP.Secondary.DefaultClip      = -1
SWEP.Secondary.Automatic        = false
SWEP.Secondary.Ammo             = "none"

SWEP.DisguiseModel = Model("models/props_interiors/Furniture_chair03a.mdl");
SWEP.Disguised     = false;
SWEP.DisguiseEnt   = NULL;

function SWEP:Initialize()
    self:SetWeaponHoldType(self.HoldType);
    self.Weapon:DrawShadow(false);
    return true;
end
function SWEP:Deploy()
    self.Owner:DrawViewModel(false);
end
function SWEP:DrawWorldModel() return false; end
function SWEP:Disguise()
    if (!IsValid(self.Owner) or !self.Owner:Alive()) then return false; end
    self.DisguiseEnt = ents.Create("prop_physics");
    self.DisguiseEnt:SetModel(self.DisguiseModel);
    if (self.DisguiseEnt:BoundingRadius() > 100) then // This shouldn't happen. But let's be safe and test if it's too big.
        self.DisguiseEnt:Remove();
        self.DisguiseEnt = NULL;
        self.Owner:ChatPrint("Selected model is too big to spawn!");
        return false;
    end
    self.DisguiseEnt:SetPos(self.Owner:GetPos() - Vector(0, 0, self.DisguiseEnt:OBBMins().z));
    self.DisguiseEnt:Spawn();
    local PhysObj = self.DisguiseEnt:GetPhysicsObject();
    PhysObj:SetVelocity(self.Owner:GetVelocity());
    self.Owner:Spectate(OBS_MODE_CHASE);
    self.Owner:SpectateEntity(self.DisguiseEnt);
    self.Owner:SetNoTarget(true);
    self.Owner:SetLocalVelocity(Vector(0, 0, 0));
    self.Disguised = true;
    hook.Add("EntityRemoved", "DisguiseDiscovered" .. self:EntIndex(), function(ent)
        if (!IsValid(self) or !IsValid(self.DisguiseEnt)) then
            return true;
        elseif (ent:EntIndex() == self.DisguiseEnt:EntIndex()) then
            self:OnRemove();
            hook.Remove("EntityRemoved", "DisguiseDiscovered" .. self:EntIndex());
        end
        return true;
    end);
    return true;
end
function SWEP:UnDisguise()
    self.Disguised = false;
    if (IsValid(self.DisguiseEnt)) then
        if (IsValid(self.Owner)) then
            self.Owner:UnSpectate();
            local EyeAng = self.Owner:EyeAngles();
            self.Owner:Spawn();
            self.Owner:SetNoTarget(false);
            local Pos = Vector(0, 0, self.DisguiseEnt:OBBMins().z);
            Pos:Rotate(self.DisguiseEnt:GetAngles());
            self.Owner:SetPos(self.DisguiseEnt:GetPos() + Pos);
            self.Owner:SetEyeAngles(EyeAng);
            self.Owner:SelectWeapon("disguise_swep");
        end
        hook.Remove("EntityRemoved", "DisguiseDiscovered" .. self:EntIndex());
        self.DisguiseEnt:Remove();
    elseif (IsValid(self.Owner)) then
        self.Owner:UnSpectate();
        local EyeAng = self.Owner:EyeAngles();
        self.Owner:Spawn();
        self.Owner:SetNoTarget(false);
        self.Owner:SetEyeAngles(EyeAng);
        self.Owner:SelectWeapon("disguise_swep");
    end
end
function SWEP:OnRemove()
    if (CLIENT or !IsValid(self.Owner) or !self.Disguised) then return; end
    self:UnDisguise();
end
function SWEP:Holster()
    self:OnRemove();
    return true;
end
function SWEP:Think()
    if (CLIENT or !self.Disguised or !IsValid(self.DisguiseEnt)) then return; end
    self.Owner:SetPos(self.DisguiseEnt:GetPos());
end
function SWEP:PrimaryAttack()
    if (CLIENT) then return false;
    elseif (!self.Disguised) then
        self:Disguise();
        return true;
    else
        self:UnDisguise();
        return true;
    end
    return false;
end
function SWEP:SelectModel()
    local Trace = self.Owner:GetEyeTraceNoCursor();
    if (IsValid(Trace.Entity)) then
        if (Trace.Entity:GetClass() == "prop_ragdoll" or Trace.Entity:IsNPC() or Trace.Entity:IsPlayer()) then
            self.Owner:ChatPrint("That's not a prop!");
            return false;
        end
        local Model = Trace.Entity:GetModel();
        if (Model == "") then return false;
        elseif (Trace.Entity:BoundingRadius() > 100) then
            self.Owner:ChatPrint("That model is too big!");
            return false;
        end
        self.DisguiseModel = Model;
        self.Owner:ChatPrint("Set model to: " .. Model);
    end
end
function SWEP:SecondaryAttack()
    if (CLIENT or self.Disguised) then return false; end
    return self:SelectModel();
end

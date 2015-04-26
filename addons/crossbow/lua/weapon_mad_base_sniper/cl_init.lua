include('shared.lua')

SWEP.PrintName			= "Mad Cows Weapon Sniper Base"		// 'Nice' Weapon name (Shown on HUD)	
SWEP.Slot				= 3							// Slot in the weapon selection menu
SWEP.SlotPos			= 1							// Position in the slot


/*---------------------------------------------------------
   Name: SWEP:TranslateFOV()
---------------------------------------------------------*/
local IRONSIGHT_TIME = 0.2

function SWEP:TranslateFOV(current_fov)

	local fScopeZoom = self.Weapon:GetNetworkedFloat("ScopeZoom")

	if self.Weapon:GetDTBool(2) then return current_fov / fScopeZoom end
	
	local bIron = self.Weapon:GetDTBool(1)

	if bIron ~= self.bLastIron then // Do the same thing as in CalcViewModel. I don't know why this works, but it does.
		self.bLastIron = bIron 
		self.fIronTime = CurTime()
	end
	
	local fIronTime = self.fIronTime or 0

	if not bIron and (fIronTime < CurTime() - IRONSIGHT_TIME) then 
		return current_fov
	end
	
	local Mul = 1.0 // More interpolating shit
	
	if fIronTime > CurTime() - IRONSIGHT_TIME then
		Mul = math.Clamp((CurTime() - fIronTime) / IRONSIGHT_TIME, 0, 1)
		if not bIron then Mul = 1 - Mul end
	end

	current_fov = current_fov*(1 + Mul/self.IronSightZoom - Mul)

	return current_fov
end

/*---------------------------------------------------------
   Name: SWEP:GetTracerOrigin()
   Desc: Allows you to override where the tracer comes from (in first person view)
	   returning anything but a vector indicates that you want the default action.
---------------------------------------------------------*/
function SWEP:GetTracerOrigin()

	if (self.Weapon:GetDTBool(1)) then
		local pos = self:GetOwner():EyePos() + self:GetOwner():EyeAngles():Up() * -5
		return pos
	end
end

/*---------------------------------------------------------
   Name: SniperCreateMove()
---------------------------------------------------------*/
local staggerdir = VectorRand():GetNormalized()

local function SniperCreateMove(cmd)
	
	
	if (LocalPlayer():GetActiveWeapon():IsValid() and LocalPlayer():GetActiveWeapon():GetDTBool(2)) then
		local ang = cmd:GetViewAngles()

		local ft = FrameTime()

		
		if LocalPlayer():GetActiveWeapon():GetDTBool(3) then 
			ang.pitch = math.NormalizeAngle(ang.pitch + staggerdir.z * ft * 0.2)
			ang.yaw = math.NormalizeAngle(ang.yaw + staggerdir.x * ft * 0.2)
			staggerdir = (staggerdir + ft * 100 * VectorRand()):GetNormalized()
		elseif LocalPlayer():Crouching() then 
			ang.pitch = math.NormalizeAngle(ang.pitch + staggerdir.z * ft * 0.4)
			ang.yaw = math.NormalizeAngle(ang.yaw + staggerdir.x * ft * 0.4)
			staggerdir = (staggerdir + ft * 100 * VectorRand()):GetNormalized()
		elseif LocalPlayer():GetVelocity():Length() > 50 then
			ang.pitch = math.NormalizeAngle(ang.pitch + staggerdir.z * ft * 5)
			ang.yaw = math.NormalizeAngle(ang.yaw + staggerdir.x * ft * 5)
			staggerdir = (staggerdir + ft * 100 * VectorRand()):GetNormalized()
		else
			ang.pitch = math.NormalizeAngle(ang.pitch + staggerdir.z * ft * 1)
			ang.yaw = math.NormalizeAngle(ang.yaw + staggerdir.x * ft * 1)
			staggerdir = (staggerdir + ft * 1 * VectorRand()):GetNormalized()
		end
		
		
		cmd:SetViewAngles(ang)		
	end
	
end
hook.Add ("CreateMove", "SniperCreateMove", SniperCreateMove)

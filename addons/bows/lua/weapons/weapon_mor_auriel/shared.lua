if( SERVER ) then
	AddCSLuaFile( "shared.lua" )
end

if( CLIENT ) then
	SWEP.PrintName = "Auriel's Bow"
	SWEP.Slot = 0
	SWEP.SlotPos = 1
	SWEP.DrawAmmo = true
	SWEP.DrawCrosshair = false
end

SWEP.Category = "Morrowind Bows"
SWEP.Author			= "Neotanks for LUA (Models, Textures, ect. By: Hellsing/JJSteel)"
SWEP.Base			= "weapon_mor_base_bow"
SWEP.Instructions	= "Spam left click, go!"
SWEP.Contact		= ""
SWEP.Purpose		= "OH GOD MY EYE"

SWEP.ViewModelFOV	= 72
SWEP.ViewModelFlip	= false

SWEP.Spawnable			= true
SWEP.AdminSpawnable		= true
  
SWEP.ViewModel      = "models/morrowind/ariel/longbow/v_ariel_longbow.mdl"
SWEP.WorldModel   = "models/morrowind/ariel/longbow/w_ariel_longbow.mdl"

SWEP.Primary.Damage		= 40
SWEP.Primary.Delay 		= 2
SWEP.Primary.Velocity 		= 1800

SWEP.Primary.ClipSize		= -1					// Size of a clip
SWEP.Primary.DefaultClip	= 0					// Default number of bullets in a clip
SWEP.Primary.Automatic		= true				// Automatic/Semi Auto
SWEP.Primary.Ammo			= "XBowBolt"
SWEP.Crosshair				= true

SWEP.Secondary.ClipSize		= -1					// Size of a clip
SWEP.Secondary.DefaultClip	= -1					// Default number of bullets in a clip
SWEP.Secondary.Automatic	= false				// Automatic/Semi Auto
SWEP.Secondary.Ammo		= "none"
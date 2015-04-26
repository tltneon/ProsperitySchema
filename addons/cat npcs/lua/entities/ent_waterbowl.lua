-----------------------------------------------------------------------------------
--------- Water Bowl Entity : By Jeezy
--------- *************************************************************************
--------- Description: Used for keeping the cats hydrated.
--------- *************************************************************************

ENT.Type = "anim"
ENT.Base = "base_entity"
ENT.PrintName = "Water Bowl"
ENT.Author = "Jeezy"
ENT.Category = "Jeezy's Entities"
ENT.Spawnable = true
ENT.Model = "models/props/jeezy/pet_waterbowl/pet_waterbowl.mdl"

if ( SERVER ) then
	AddCSLuaFile( )
	function ENT:Initialize( )
		self:SetModel( self.Model )
		self:PhysicsInit(SOLID_VPHYSICS)
		self:SetMoveType(MOVETYPE_VPHYSICS)
		self:SetSolid(SOLID_VPHYSICS)
		self:SetUseType(SIMPLE_USE)
		local phys = self:GetPhysicsObject()
		phys:Wake()
		self:SetRemainingWater( 100 )
	end

--------------------------------------------------------------------------------------
------- The function used when the cat successfully reaches food, refills cat's hunger, 
------- and lowers remaining food. Sets the current user to nil afterwards.
	function ENT:DrinkWater( catEnt, amt )

		if ( self:GetRemainingWater( ) > 0 ) then -- If the food amount is larger than
			catEnt:SetStat( catEnt.CAT_HYDRATION, catEnt:GetStat( catEnt.CAT_HYDRATION ) + amt )
			self:SetRemainingWater( self:GetRemainingWater( ) - amt )
		end

		if ( self:GetRemainingWater( ) <= 0 ) then
			catEnt.foundEnt = nil
			SafeRemoveEntity( self )
		end

		self.curUser = nil
	end

--------------------------------------------------------------------------------------
------- Sort of a hacky glitch temporary fix, ensures the foodbowl's user eventually 
------- resets to nil so another cat may use it.
	function ENT:InitiateUserTimeout( seconds )

		timer.Simple( seconds, function( )
			if ( IsValid( self ) ) then
				self.curUser = nil
			end
		end )

	end
else
	function ENT:Draw( )

		self:DrawModel( )

	end
end

function ENT:SetupDataTables()

	self:NetworkVar( "Int", 0, "RemainingWater" )

end
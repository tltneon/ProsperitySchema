-----------------------------------------------------------------------------------
--------- Catfood Entity : By Jeezy
--------- *************************************************************************
--------- Description: Used to feed the cats, has a limited amount of food. 
--------- *************************************************************************

ENT.Type = "anim"
ENT.Base = "base_entity"
ENT.PrintName = "Catfood"
ENT.Author = "Jeezy"
ENT.Category = "Jeezy's Entities"
ENT.Spawnable = true
ENT.Model = "models/props/jeezy/catfood_bowl/catfood_bowl.mdl"

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
		self:SetFoodAmount( 100 ) -- Set the initial food amount.
	end

--------------------------------------------------------------------------------------
------- The function used when the cat successfully reaches food, refills cat's hunger, 
------- and lowers remaining food. Sets the current user to nil afterwards.
	function ENT:EatFood( catEnt, amt )

		if ( self:GetFoodAmount( ) > 0 ) then -- If the food amount is larger than
			catEnt:SetStat( catEnt.CAT_HUNGER, catEnt:GetStat( catEnt.CAT_HUNGER ) + amt )
			self:SetFoodAmount( self:GetFoodAmount( ) - amt )
		end

		if ( self:GetFoodAmount( ) <= 0 ) then
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

	self:NetworkVar( "Int", 0, "FoodAmount" )

end
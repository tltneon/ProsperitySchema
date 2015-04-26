ITEM.name = "Beacon - Orange"
ITEM.model = "models/Items/grenadeAmmo.mdl"
ITEM.desc = "Can be used as a signal, or to illuminate areas."
ITEM.throwent = "nut_beacon_o"
ITEM.throwforce = 500
ITEM.flag = "v"
ITEM.functions = {}
ITEM.functions.Throw = {
	text = "Throw",
	tip = "Throws the item.",
	icon = "icon16/box.png",
	onRun = function(itemTable, client, data, entity)
		if (SERVER) then
			local grd = ents.Create( itemTable.throwent )
			grd:SetPos( client:EyePos() + client:GetAimVector() * 50 )
			grd:Spawn()
			grd:SetDTInt(0,2)
			function grd:Payload()
				RequestAirSupport( self:GetPos() + Vector( 0, 0, 50 ) )
			end
			local phys = grd:GetPhysicsObject()
			phys:SetVelocity( client:GetAimVector() * itemTable.throwforce * math.Rand( .8, 1 ) )
			phys:AddAngleVelocity( client:GetAimVector() * itemTable.throwforce  )
			return true
		end
	end,
}
ITEM.name = "Cinder Block"
ITEM.uniqueID = "j_cinder_block"
ITEM.model = "models/props_junk/cinderblock01a.mdl"
ITEM.desc = "A heavy block of concrete."
ITEM.flag = "j"
ITEM.width = 2
ITEM.height = 2

	function ITEM:OnEntityCreated(entity)
		entity:SetMaterial("models/props_c17/furnituremetal001a");
	end;
ITEM.name = "Towel"
ITEM.uniqueID = "j_towel"
ITEM.model = "models/props_junk/garbage_carboard002a.mdl"
ITEM.desc = "A piece of absorbent fabric used for drying."
ITEM.flag = "j"
ITEM.width = 2
ITEM.height = 2


	function ITEM:OnEntityCreated(entity)
		entity:SetMaterial("models/props_c17/FurnitureFabric003a");
	end;

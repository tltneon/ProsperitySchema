ITEM.name = "Rag"
ITEM.uniqueID = "j_old_rag"
ITEM.model = "models/props_debris/metal_panelshard01c.mdl"
ITEM.desc = "An old rag."
ITEM.flag = "j"
ITEM.width = 1
ITEM.height = 1


	function ITEM:OnEntityCreated(entity)
		entity:SetMaterial("models/props_c17/furnituremetal001a");
	end;
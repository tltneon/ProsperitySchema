ITEM.name = "Cereal Box"
ITEM.uniqueID = "j_cereal_box"
ITEM.model = "models/props_lab/harddrive02.mdl"
ITEM.desc = "An empty cardboard box that once contained cereal."
ITEM.flag = "j"
ITEM.width = 2
ITEM.height = 2

	function ITEM:OnEntityCreated(entity)
		entity:SetMaterial("models/props_c17/furnituremetal001a");
	end;
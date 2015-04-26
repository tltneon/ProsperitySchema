ITEM.name = "Meat Grinder"
ITEM.uniqueID = "j_meat_grinder"
ITEM.model = "models/props_c17/grinderclamp01a.mdl"
ITEM.desc = "A metal tool with a climb and a lever."
ITEM.flag = "j"
ITEM.width = 1
ITEM.height = 2

	function ITEM:OnEntityCreated(entity)
		entity:SetMaterial("models/props_canal/canalmap_sheet");
	end;

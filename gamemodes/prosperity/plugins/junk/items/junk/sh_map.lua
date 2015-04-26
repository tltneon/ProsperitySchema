ITEM.name = "Map"
ITEM.uniqueID = "j_map"
ITEM.model = "models/props_c17/paper01.mdl"
ITEM.desc = "An old map printed on a piece of paper."
ITEM.flag = "j"
ITEM.width = 2
ITEM.height = 2

	function ITEM:OnEntityCreated(entity)
		entity:SetMaterial("models/props_canal/canalmap_sheet");
	end;

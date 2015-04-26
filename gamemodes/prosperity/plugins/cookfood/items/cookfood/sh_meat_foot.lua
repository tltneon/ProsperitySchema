ITEM.name = "Human Foot"
ITEM.uniqueID = "food_human_foot"
ITEM.model = "models/dismemberment/gibs/legs/foot.mdl"
ITEM.hungerAmount = 30
ITEM.foodDesc = "A foot that was once connected to a human being. \n You thought they smelled badly before."
ITEM.quantity = 1
ITEM.price = 100
ITEM.width = 2
ITEM.height = 1

	function ITEM:OnEntityCreated(entity)
		entity:SetMaterial("models/flesh");
	end;
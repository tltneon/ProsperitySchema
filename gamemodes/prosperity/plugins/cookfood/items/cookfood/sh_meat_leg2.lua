ITEM.name = "Human Leg"
ITEM.uniqueID = "food_human_leg2"
ITEM.model = "models/dismemberment/gibs/legs/upper_leg.mdl"
ITEM.hungerAmount = 25
ITEM.foodDesc = "The upper leg of a human being."
ITEM.quantity = 2
ITEM.price = 100
ITEM.width = 2
ITEM.height = 1

	function ITEM:OnEntityCreated(entity)
		entity:SetMaterial("models/flesh");
	end;
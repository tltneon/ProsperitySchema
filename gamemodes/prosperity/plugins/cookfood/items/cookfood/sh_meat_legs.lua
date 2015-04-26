ITEM.name = "Human Leg"
ITEM.uniqueID = "food_human_legs"
ITEM.model = "models/dismemberment/gibs/legs.mdl"
ITEM.hungerAmount = 35
ITEM.foodDesc = "A leg that was once connected to a human being."
ITEM.quantity = 4
ITEM.price = 100
ITEM.width = 5
ITEM.height = 2

	function ITEM:OnEntityCreated(entity)
		entity:SetMaterial("models/flesh");
	end;